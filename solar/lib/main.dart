import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar/main_screen.dart';
import 'package:solar/mqtt_app_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MQTTAppState()),
          //ChangeNotifierProvider(create: (context) => MQTTViewState())
        ],
        child:  MaterialApp(
          home: MQTTView(),
        ),
      )
    );
  }
}