import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MQTTAppState.dart';
import 'MQTTManager.dart';

class MQTTView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MQTTViewState();
  }
}
class _MQTTViewState extends State<MQTTView>{
  final TextEditingController _messageTextController = TextEditingController();
  late MQTTAppState currentAppState;
  late MQTTManager manager;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    _configureAndConnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    currentAppState = appState;
    final Scaffold scaffold = Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Hello Mai'),
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

  Widget _buildAppBar(BuildContext context){
    return AppBar(
      title: Center(
        child: Text('MQTT'),
      ),
        backgroundColor: Colors.blue,
    );
  }

  Widget _buildColumn(){
    return Container(
      padding: EdgeInsets.all(0.5),
      child: Column(
      children: <Widget>[
        _buildEditableColumn(),
        _buildScrollableTextWith(currentAppState.getHistoryText)
      ],
    ),);
  }

  Widget _buildEditableColumn(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildPublishMessageRow(),
          const SizedBox(height: 10),
          _buildConnectButtonFrom(currentAppState.getAppConnectionState),
        ],
      ),
    );
  }

  Widget _buildPublishMessageRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
            child: _buildTextFeildWith(_messageTextController,'Enter message',currentAppState.getAppConnectionState),
        ),
        _buildSendButtonFrom(currentAppState.getAppConnectionState),
      ],
    );
  }

  Widget _buildConnectionStateText(String status){
    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
              color: Colors.orangeAccent,
              child: Text(status,textAlign: TextAlign.center,),
            ),
        )
      ],
    );
  }

  Widget _buildTextFeildWith(TextEditingController controller,String hintText, MQTTAppConnectionState state){
    bool shouldEnable = false;
    if(controller == _messageTextController && state == MQTTAppConnectionState.connected){
      shouldEnable = true;
    }
    return TextField(
      enabled: shouldEnable,
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
          const EdgeInsets.only(left: 0, bottom: 0, right: 0, top: 0),
        labelText: hintText,
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

  Widget _buildSendButtonFrom(MQTTAppConnectionState state){
    return RaisedButton(
        color: Colors.green,
        child: const Text('Send'),
        onPressed: state == MQTTAppConnectionState.connected? (){
          _publishMessage(_messageTextController.text);
        } : null
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
    _messageTextController.clear();
  }
}