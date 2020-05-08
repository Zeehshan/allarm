import 'dart:isolate';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
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
      ),
      home: MyHomePage(title: 'Flutter Alaram Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int helloAlarmID = 0;

  static showToast(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void initialization() async {
    await AndroidAlarmManager.initialize();
  }

  TextEditingController videoLastNameController = new TextEditingController();
  int seconds;

  @override
  void initState() {
    initialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                  ],
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: "Enter value in second",
                    helperText: '',
                    border: OutlineInputBorder(),
                  ),
                  controller: videoLastNameController,
                  onSaved: (String val) {
                    seconds = int.parse(val);
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                      "What ever second you added after that alaram will trigger automatically")),
              RaisedButton(
                onPressed: () async {
                  if (videoLastNameController.text.trim().length > 0) {
                    await AndroidAlarmManager.periodic(
                      Duration(
                          seconds: int.parse(videoLastNameController.text)),
                      helloAlarmID,
                      (){
//                          Container(
//                            width: MediaQuery.of(context).size.width,
//                            height: MediaQuery.of(context).size.height,
//                            color: Colors.blue,
//                          );
                          showToast("Now Alaram is trigger");
                          final DateTime now = DateTime.now();
                          final int isolateId = Isolate.current.hashCode;
                          print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
                          var assetsAudioPlayer = AssetsAudioPlayer();
                          assetsAudioPlayer.open(
                            "assets/audio/svist_pticy_freetone.mp3",
                          );
                      },
                      wakeup: true,
                      exact: true,
                      rescheduleOnReboot: true,
                    ).then((onValue) {
                      showToast("Alaram is Started");
                    });
                    ;
                  } else {
                    showToast("please  enter seconds");
                  }
                },
                child: Text("Start Alaram"),
              ),
              RaisedButton(
                onPressed: () async {
                  await AndroidAlarmManager.cancel(0);
                  showToast("Alaram is Now Stop");
                },
                child: Text("Stop Alaram"),
              )
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  static void printHello(context) {

  }
}
