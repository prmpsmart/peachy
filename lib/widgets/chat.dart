import 'package:flutter/material.dart';
import 'data.dart';

// class Chat extends Column {
//   int index;
//   Message chat;

//   Chat(this.index) {
//     chat = chats[index];
//   }

//   @override
//   _ChatState createState() => _ChatState();
// }

// class _ChatState extends State<Chat> {
//   int selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (_) => SafeArea(
//                   child: Text(widget.chat.sender.name),
//                 )),
//       ),
//       child: Container(
//         margin: EdgeInsets.only(
//           top: 2,
//           bottom: 2,
//           right: 10,
//         ),
//         padding: EdgeInsets.symmetric(
//           horizontal: 9,
//           vertical: 5,
//         ),
//         decoration: BoxDecoration(
//           color: widget.chat.unread ? Color(0xFFFFEFEE) : Colors.white,
//           borderRadius: BorderRadius.only(
//             topRight: Radius.circular(20),
//             bottomRight: Radius.circular(20),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: <Widget>[
//                 CircleAvatar(
//                   radius: 30,
//                   // backgroundImage: AssetImage(chat.sender.imageUrl),
//                   child: TextButton(
//                     onPressed: () {},
//                     child: null,
//                   ),
//                 ),
//                 SizedBox(width: 5),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       widget.chat.sender.name,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 15),
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.45,
//                       child: Text(
//                         widget.chat.text,
//                         style: TextStyle(
//                             color: Colors.blueGrey,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w100),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                   ],
//                 ),
//               ],
//             ),
//             Column(
//               children: <Widget>[
//                 Text(
//                   widget.chat.time,
//                   style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 5),
//                 widget.chat.unread
//                     ? Container(
//                         width: 40,
//                         height: 20,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).primaryColor,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           'NEW',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       )
//                     : Text(''),
//                 SizedBox(height: 5),
//                 Text(
//                   widget.chat.time,
//                   style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
