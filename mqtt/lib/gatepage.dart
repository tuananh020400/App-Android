import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mqtt/MQTTAppState.dart';
import 'mqtt/MQTTManager.dart';
class GatePage extends StatelessWidget {
  late MQTTAppState currentAppState;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => MQTTAppState(),
      child: GatePageState(),);
  }
}
class GatePageState extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text(context.watch<MQTTAppState>().getNhietDo.toString()),
    );
  }
}

