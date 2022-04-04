import 'package:flutter/material.dart';
import 'package:fluttermqttnew/mqtt/MQTTManager.dart';
import 'mqtt/MQTTView.dart';
import 'mqtt/MQTTAppState.dart';
import 'package:provider/provider.dart';
import 'gatepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        home: ChangeNotifierProxyProvider(
          create: (_) => MQTTAppState(),
          child: MQTTView(),
        )
    );
  }
}