import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar/main_screen.dart';
import 'package:solar/mqtt_app_state.dart';
import 'package:solar/mqtt.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MQTTAppState()),
          ChangeNotifierProvider(create: (context) => MQTT())
        ],
        child:  MaterialApp(
          home: MQTTView(),
        ),
      );
  }
}