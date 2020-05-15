import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FCM",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  String data = "Nenhuma notificação";

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');

        setState(() {
          data = message.toString();
        });
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');

        setState(() {
          data = message.toString();
        });
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');

        setState(() {
          data = message.toString();
        });
      },
    );
    _firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FCM"),
      ),
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            new Text(data),
            new RaisedButton(
                child: new Text("Enviar menssagem"),
                onPressed: () {
                  String DATA =
                      "{\"notification\": {\"body\": \"Texto da notificação\",\"title\": \"Título\"}, \"priority\": \"high\", \"data\": {\"click_action\": \"FLUTTER_NOTIFICATION_CLICK\", \"id\": \"1\", \"status\": \"done\"}, \"to\": \"<FCM TOKEN>\"}";
                  http.post("https://fcm.googleapis.com/fcm/send",
                      body: DATA,
                      headers: {"Content-Type": "application/json", "Authorization": "key=<FCM SERVER KEY>"});
                }),
          ],
        ),
      ),
    );
  }
}