import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mqtt/MQTTAppState.dart';
import 'mqtt/MQTTManager.dart';
class GatePage extends StatelessWidget{
  MQTTAppState currentAppState;
  GatePage({required this.currentAppState});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<MQTTAppState>(create:(_) => MQTTAppState(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.watch<MQTTAppState>().getNhietDo.toString()),
        ),
        body: Center(
          child: Text(currentAppState.getNhietDo.toString()),
        ),
      ),);
  }
}