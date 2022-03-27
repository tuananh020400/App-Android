import 'package:flutter/material.dart';
import 'mqtt/MQTTView.dart';
import 'mqtt/MQTTAppState.dart';
import 'package:provider/provider.dart';
import 'gatepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*
    final MQTTManager manager = MQTTManager(host:'test.mosquitto.org',topic:'flutter/amp/cool',identifier:'ios');
    manager.initializeMQTTClient();
     */

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        home: ChangeNotifierProvider<MQTTAppState>(
          create: (context) => MQTTAppState(),
          child: MQTTView(),
        ));
  }
}