import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_channel_test/camera.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    cameras = await availableCameras();
  } on CameraException catch(e){
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(cameras),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  MyHomePage(this.cameras);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  static const platformMethodChannel = const MethodChannel("com.channel.test");
  String message = "";
  List<dynamic>_recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  _incrementCounter() async {
    String res = "";
    try {
      res = await platformMethodChannel.invokeMethod("coba");
    } on PlatformException catch (e){
      res = "error";
    }

    setState(() {
      message = res;
    });
  }

  setRecognitions(recognitions,imageHeight,imageWidth){
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageWidth;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
      ),
      body: Stack(
        children: [
          Camera(widget.cameras,setRecognitions),
        ],
      )
    );
  }
}
