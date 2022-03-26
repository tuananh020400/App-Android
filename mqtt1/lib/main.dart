import 'package:flutter/material.dart';
import 'package:mqtt1/widgets/mqttView.dart';
import 'package:mqtt1/mqtt/state/MQTTAppState.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ChangeNotifierProvider<MQTTAppState>(
          create: (_) => MQTTAppState(),
          child: MQTTView(),
        ));
  }
}


/*
Padding(
        padding: const EdgeInsets.all(100.0),
        child: Center(
          child:Column(
            children: <Widget>[
              Center(
                child: RaisedButton(
                  child: Text("Connect"),
                  onPressed: manager.connect ,
                ),
              )
            ],
          ) ,
        ),
      )
 */