import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MQTTAppState.dart';
import 'MQTTManager.dart';
import 'package:fluttermqttnew/gatepage.dart';

class MQTTView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MQTTViewState();
  }
}
class _MQTTViewState extends State<MQTTView>{
  late MQTTAppState currentAppState;
  late MQTTManager manager;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    currentAppState = appState;
    final Scaffold scaffold = Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.watch<MQTTAppState>().getNhietDo.toString()),
        actions: <Widget>[
          Icon(_iconMqttState(currentAppState.getAppConnectionState)),
          Padding(padding: EdgeInsets.all(6))],
        leading:Container(
          height: 60,
          width: 60,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Center(
                child:
                Image(
                  image: AssetImage('assets/Logo ĐH Công Nghệ-UET.png'),)
            ),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(left: 20, right: 20),
        child: _buildColumn(),
      ),);
    return scaffold;
  }

  Widget _buildColumn(){
    return Container(
      padding: EdgeInsets.all(0.5),
      child: Column(
      children: <Widget>[
        Padding(padding: const EdgeInsets.all(10)),
        _buildConnectButtonFrom(currentAppState.getAppConnectionState),
        buildGate(),
        //_buildNode(),
        _buildScrollableTextWith(currentAppState.getHistoryText)
      ],
    ),);
  }
  Widget buildGate(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
        InkWell(
            onTap: (){
              print('Alo');
            },
            child: Container(
              child: Text('Gate'),
            )
        )
      ],
    );
  }


  Widget _buildEditableColumn(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildConnectButtonFrom(currentAppState.getAppConnectionState),
        ],
      ),
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

  Widget _buildConnectButtonFrom(MQTTAppConnectionState state){
    return Row(
      children:<Widget> [
        Expanded(
            child: RaisedButton(
              color: Colors.lightBlueAccent,
              child: const Text('Connect'),
              onPressed: state == MQTTAppConnectionState.disconnected? _configureAndConnect : null,
        )),
        const SizedBox(width: 10,),
        Expanded(
            child: RaisedButton(
              color: Colors.redAccent,
              child: const Text('Disconnect'),
              onPressed: state == MQTTAppConnectionState.connected? _disconnect : null,
            ))
      ],
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
