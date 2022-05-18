// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../ui_utils.dart';

class Camera extends P_StatefulWidget {
  static MethodChannel platform = const MethodChannel('yuv_transform');

  static Future<Uint8List> yuv_transform(CameraImage image) async {
    List<int> strides = new Int32List(image.planes.length * 2);
    int index = 0;

    List<Uint8List> data = image.planes.map((plane) {
      strides[index] = (plane.bytesPerRow);
      index++;
      strides[index] = plane.bytesPerPixel as int;
      index++;
      return plane.bytes;
    }).toList();

    Uint8List image_jpeg = await platform.invokeMethod('yuv_transform', {
      'platforms': data,
      'strides': strides,
      'height': image.height,
      'width': image.width,
    });

    return image_jpeg;
  }

  static List<CameraDescription> cameras = [];

  static CameraDescription? backCamera;
  static CameraDescription? frontCamera;
  static CameraDescription? externalCamera;

  late CameraDescription? currentCamera;
  VoidCallback? cameraChanged;
  int cameraInt = 1;

  late CameraImage cameraImage;

  Camera({int camera = 1}) {
    setCamera(camera: camera);
  }

  void setCamera({int camera = 1}) {
    cameraInt = camera;
    changeCamera();
  }

  void nextCamera() {
    if (cameraInt == 0)
      cameraInt = 1;
    else if (cameraInt == 1) {
      if (Camera.externalCamera == null)
        cameraInt = 0;
      else
        cameraInt = 2;
    } else if (cameraInt == 2)
      cameraInt = 0;
    else
      cameraInt = 0;
    changeCamera();
  }

  void changeCamera() {
    switch (cameraInt) {
      case 0:
        currentCamera = backCamera;
        break;
      case 1:
        currentCamera = frontCamera;
        break;
      case 2:
        currentCamera = externalCamera;
        break;
    }
    if (cameraChanged != null) cameraChanged!();
  }

  static bool get loaded => cameras.isNotEmpty;

  static Future<void> staticLoad() async {
    cameras = await availableCameras();

    cameras.forEach((camera) {
      switch (camera.lensDirection) {
        case CameraLensDirection.back:
          backCamera = camera;
          break;
        case CameraLensDirection.front:
          frontCamera = camera;
          break;
        case CameraLensDirection.external:
          externalCamera = camera;
          break;
      }
    });
  }

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends P_StatefulWidgetState<Camera> {
  CameraController? controller;

  Future<void> setController() async {
    if (controller != null) await controller!.dispose();

    controller = CameraController(
      widget.currentCamera as CameraDescription,
      ResolutionPreset.low,
      enableAudio: false,
    );
    controller!.addListener(() {
      if (mounted) setState(() {});
    });
    await controller!.initialize();
    controller!.startImageStream((image) {
      widget.cameraImage = image;
    });
  }

  @override
  void initState() {
    widget.cameraChanged = setController;
    if (Camera.loaded) setController();

    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var child;
    if (controller != null) {
      child = CameraPreview(controller!);
    } else
      CircularProgressIndicator();

    return Container(
      child: child,
      width: 310,
      height: 500,
    );
  }
}

class CameraDialog extends P_StatefulWidget {
  Function(CameraImage, bool, BuildContext) recv;

  CameraDialog(this.recv) : super();

  @override
  _CameraDialogState createState() => _CameraDialogState();
}

class _CameraDialogState extends P_StatefulWidgetState<CameraDialog> {
  late Camera camera;
  @override
  void initState() {
    camera = Camera();
    super.initState();
  }

  int get cameraInt => camera.cameraInt;
  set cameraInt(int value) => camera.cameraInt = value;

  @override
  Widget build(BuildContext context) {
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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            camera,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getButton(Icons.camera, 'Capture', onPressed: () {
                  widget.recv(camera.cameraImage,
                      camera.currentCamera == Camera.frontCamera, context);
                }),
                getButton(Icons.switch_camera_outlined, 'Switch',
                    onPressed: () => camera.nextCamera()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
