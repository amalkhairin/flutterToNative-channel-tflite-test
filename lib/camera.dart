import 'package:bitmap/bitmap.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  Camera(this.cameras,this.setRecognitions);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;
  bool isDetecting = false;
  var platformMethodChannel = const MethodChannel("com.channel.test");

  @override
  void initState() {
    super.initState();

    if(widget.cameras == null || widget.cameras.length < 1){
      print("camera not found");
    } else {
      controller = CameraController(widget.cameras[0], ResolutionPreset.high);

      controller.initialize().then((_) {
        if(!mounted){
          return;
        } else {
          setState(() {});
        }

        controller.startImageStream((image) async {
          if(!isDetecting){
            isDetecting = true;

            var bitmap = image.planes.map((plane){
              return plane.bytes;
            });

            print("cek: $bitmap");

            // sendBitmapToChannel(bitmap.toList()[0]).then((recognitions) {
            //   print("detex: $recognitions");
            //   widget.setRecognitions(recognitions, image.height, image.width);
            // });

          }
        });
      });
    }
  }

  Future<dynamic> sendBitmapToChannel(data) async {
    try{
      return await platformMethodChannel.invokeMethod("tflite",data);
    } on PlatformException catch(e){
      return "error";
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
        screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
        screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller),
    );
  }
}
