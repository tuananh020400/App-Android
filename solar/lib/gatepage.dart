import 'package:flutter/material.dart';
import 'package:solar/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:solar/mqtt_app_state.dart';
import 'package:solar/mqtt_manager.dart';
class GatePageState extends StatelessWidget{
  late MQTTAppState currentAppState;
  late MQTTManager manager;
  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    currentAppState = appState;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('GateWay'),
        actions: <Widget>[
          Icon(currentAppState.getIconData)
    ]),
      body: Center(
          child: Text(context.watch<MQTTAppState>().getReceivedText),
      ),
    );
  }
}
