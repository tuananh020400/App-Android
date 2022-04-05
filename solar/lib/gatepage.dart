import 'package:flutter/material.dart';
import 'package:solar/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:solar/mqtt_app_state.dart';
import 'package:solar/mqtt_manager.dart';
class GatePage extends StatefulWidget{
  @override
  _GatePageState createState()  => _GatePageState();
}

class _GatePageState extends State<GatePage>{
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
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(5)),
          _buildConnectButton(currentAppState.getAppConnectionState),
        ],
      ),
    );
  }

  Widget _buildConnectButton(MQTTAppConnectionState state){
    return Row(
      children: <Widget>[
        Expanded(
            child: RaisedButton(
              color: Colors.lightGreenAccent,
              child: const Text('Connect'),
              onPressed: state == MQTTAppConnectionState.disconnected? _configureAndConnect : null,
            )),
        const SizedBox(width: 10,),
        Expanded(
            child: RaisedButton(
              color: Colors.red,
              child: const Text('Disconnect'),
              onPressed: state == MQTTAppConnectionState.connected? _disconnect : null,
            ))
      ],
    );
  }

  void _configureAndConnect(){
    manager = MQTTManager(
      host: 'broker.emqx.io',
      topicpub: 'publish',
      topicsub: 'subscribe',
      identifier: 'My App Flutter',
      state: currentAppState,
    );
    manager.initializeMQTTClient();
    manager.connect();
  }

  void _disconnect(){
    manager.disconnect();
  }
}
