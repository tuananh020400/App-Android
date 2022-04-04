import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solarapp/mqtt_manager.dart';
import 'package:solarapp/mqtt_app_state.dart';


class MQTTView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MQTTViewState();
  }
}

class _MQTTViewState extends State<MQTTView>{
  late MQTTAppState currentAppState;
  late MQTTManager manager;

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    currentAppState = appState;
    final Scaffold scaffold = Scaffold(body: _buildColumn(),);
    return scaffold;
  }

  Widget _buildColumn(){
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(10)),
        _buildConnectButton(currentAppState.getAppConnectionState),
        Padding(padding: EdgeInsets.all(10)),
        _buildGate(),
        Padding(padding: EdgeInsets.all(10)),
        _buildScrollableTextWith(currentAppState.getHistotyText),
      ],
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

  Widget _buildGate(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(padding: const EdgeInsets.all(5)),
        InkWell(
            onTap: (){
              print('Alo');
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GatePageState()));
            },
            child: Container(
              padding: EdgeInsets.all(40),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Text('Gate way', style: (TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),),
            )
        ),
      ],
    );

  }

  Widget _buildScrollableTextWith(String text){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 400,
        height: 200,
        child: SingleChildScrollView(
          child: Text(text),
        ),
      ),
    );
  }

  IconData _iconMqttState(MQTTAppConnectionState state){
    switch (state) {
      case MQTTAppConnectionState.connected:
        return Icons.cloud_done;
      case MQTTAppConnectionState.disconnected:
        return Icons.cloud_off;
      case MQTTAppConnectionState.connecting:
        return Icons.cloud_upload;
    }
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

  void _publishMessage(String text)
  {
    manager.publish(text);
  }
}

class GatePageState extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text(context.watch<MQTTAppState>().getReceivedText),
    );
  }
}