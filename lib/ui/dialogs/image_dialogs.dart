import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:peachy/backend/client.dart';
import 'package:peachy/backend/constants.dart';
import 'package:peachy/backend/tag.dart';
import 'package:peachy/backend/user.dart';
import 'package:peachy/backend/utils.dart';
import 'package:peachy/ui/dialogs/cropperx.dart';

class PreviewSendImage extends StatefulWidget {
  final List<int> image;
  final textCont = TextEditingController();
  final chatScreenState;
  final bool isFront;

  get chat_object => chatScreenState.chat_object;
  Client get client => chatScreenState.widget.client;
  User get user => chat_object.user;
  PreviewSendImage(this.image, this.isFront, this.chatScreenState) : super();

  @override
  _PreviewSendImageState createState() => _PreviewSendImageState();
}

class _PreviewSendImageState extends State<PreviewSendImage> {
  final cropperKey = GlobalKey();
  bool crop = false;
  TextEditingController get textCont => widget.textCont;
  @override
  Widget build(BuildContext context) {
    var padding = EdgeInsets.all(5);

    double size = 40;

    IconButton getButton(IconData icon, String tip, {onPressed}) {
      return IconButton(
        padding: const EdgeInsets.all(0.0),
        splashColor: Colors.white,
        splashRadius: size,
        icon: Icon(icon, color: Colors.white, size: size),
        onPressed: onPressed,
        tooltip: tip,
      );
    }

    var image = Image.memory(Uint8List.fromList(widget.image));

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor.withOpacity(.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                (!crop && widget.isFront)
                    ? RotatedBox(quarterTurns: 2, child: image)
                    : image,
                if (crop)
                  Cropper(
                    cropperKey: cropperKey,
                    image: image,
                    rotationTurns: 2,
                  ),
                getButton(crop ? Icons.crop_free : Icons.crop, 'Crop',
                    onPressed: () {
                  setState(() {
                    crop = !crop;
                  });
                }),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 35,
                    margin: EdgeInsets.only(right: 2.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: TextField(
                      controller: textCont,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type your message...',
                        hoverColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 2.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: IconButton(
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.send),
                    iconSize: 25,
                    onPressed: () async {
                      String text = textCont.text;
                      String istext = text.replaceAll(' ', '');

                      List<int> imageBytes = crop
                          ? await Cropper.crop(cropperKey: cropperKey)
                              as List<int>
                          : widget.image;

                      Tag tag = Tag({
                        if (istext.isNotEmpty) 'text': text,
                        'action': CHAT,
                        'chat': CHAT['IMAGE'],
                        'sender': widget.user.id,
                        'recipient': widget.chat_object.id,
                        'type': GET_TYPE(widget.chat_object),
                        if (imageBytes.length > 0)
                          'data': B64_ENCODE(imageBytes),
                          'isFront': widget.isFront
                      });
                      widget.client.send_chat_tag(tag);
                      Navigator.pop(context);
                      widget.chatScreenState.setState(() {});
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
