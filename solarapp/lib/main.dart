import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solarapp/main_screen.dart';
import 'package:solarapp/mqtt_app_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'SolarApp',
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: ChangeNotifierProvider(
        create: (_) => MQTTAppState(),
        child: MQTTView(),
      ),
    );
  }
}