import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'src/RekognitionHandler.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiOverlayStyle;
import 'package:audioplayers/audioplayers.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/painting.dart';
import 'package:vibration/vibration.dart';

int f = 1;
// flag to stop the timer while fetching the exist face details results (JSON)

Timer timer;
const int cCounter = 2;
int counter = cCounter; // Counting until capture a photo
int eyeClosedCounter = 0;
bool alreadySlept = false;
CameraController _controller;
Future<void> _initializeControllerFuture;
List<CameraDescription> cameras;
AudioCache audioCache = AudioCache();
AudioPlayer audioPlayer = AudioPlayer();

void takeAPhoto() async {
  try {
    f = 0;
    await _initializeControllerFuture;
    XFile image = await _controller.takePicture();
    print(image.path);
    await detectTheFace(image.path).then((value) async {
      File(image.path).delete(); // Delete the image immediately after
      // the response
      // to avoid much data on
      // the storage
      imageCache?.clear(); // Because when the image deleted, there
      // is a space taken by the application stored in the Documents Section
      f = 1;
    });
  } catch (e) {
    print(e);
  }
}

Future<void> detectTheFace(String srcImage) async {
  File sourceImageFile = File(srcImage);
  String accessKey = 'your-access-key',
      secretKey = 'your-secret-key',
      region = 'your-region';

  RekognitionHandler rekognition =
      new RekognitionHandler(accessKey, secretKey, region);
  Future<String> labelsArray = rekognition.detectFaces(sourceImageFile);
  //var results0 = json.decode(await labelsArray);

  final results = json.decode(await labelsArray);
  //print(await labelsArray); //For debugging
  if (results != null && !results['FaceDetails'].isEmpty) {
    if (results['FaceDetails'] != '' &&
        results['FaceDetails'][0]['Confidence'] > 98 &&
        results['FaceDetails'][0]['EyesOpen']['Value'] == false) {
      eyeClosedCounter++;
      if (eyeClosedCounter >= 1) {
        print("Sleep");
        Vibration.vibrate(duration: 3500);
        if (alreadySlept == false) {
          timeToAwake();
          alreadySlept = true;
        }
      }
    } else {
      print("Awake");
      audioPlayer?.stop();
      eyeClosedCounter = 0;
      Vibration.cancel();
      alreadySlept = false;
    }
  }
}

void timeToAwake() async {
  audioPlayer = await audioCache.loop("sounds/iphone_alarm.mp3");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _controller = CameraController(cameras[1], ResolutionPreset.low,
        imageFormatGroup: ImageFormatGroup.bgra8888);
    _initializeControllerFuture = _controller.initialize();
    _controller.setFlashMode(FlashMode.off); // MUST be in this order/line
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (f == 1) {
          if (counter == 0) {
            setState(() {
              takeAPhoto();
              //timer.cancel();
              counter = cCounter;
            });
          } else {
            setState(() {
              counter--;
            });
          }
        }
      },
    );
  }

  //CameraPreview(controller), -- To show the camera (Just for debugging). Add
  // it instead of Scaffold Below.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MaterialApp(
      home: GestureDetector(
        onTap: () {
          print("Awake");
          audioPlayer?.stop();
          eyeClosedCounter = 0;
          Vibration.cancel();
          alreadySlept = false;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    new TextSpan(
                      text: '• App is working, \nplease check:\n\n\n',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    new TextSpan(
                      text: 'Low Power Mode\n\nDo not disturb Mode\n'
                          '\nInternet\n\nHighest Volume\n\nLowest Brightness'
                          '\n\nStay Safe',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() async {
    _controller?.dispose();
    audioPlayer?.dispose();
    timer.cancel();
    Wakelock.disable();
    super.dispose();
  }
}
