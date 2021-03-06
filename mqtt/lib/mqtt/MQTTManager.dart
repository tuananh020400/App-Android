import 'package:mqtt_client/mqtt_client.dart';
import 'MQTTAppState.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttermqttnew/mqtt/MQTTView.dart';

enum MQTTAppConnectionState {connected, disconnected, connecting}

class MQTTAppState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState = MQTTAppConnectionState
      .disconnected;
  String _receivedText = '';
  String _historyText = '';
  int _nhietdo = 123;

  void setReceivedText(String text) {
    _receivedText = text;
    _historyText = _historyText + '\n' + _receivedText;
    _nhietdo = int.parse(_receivedText);
    notifyListeners();
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
    notifyListeners();
  }

  String get getReceivedText => _receivedText;

  String get getHistoryText => _historyText;

  int get getNhietDo => _nhietdo;

  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;

}
class MQTTManager {
  final MQTTAppState _currentState;
  MqttServerClient? _client;
  final String _identifier;
  final String _host;
  final String _topicpub;
  final String _topicsub;

  MQTTManager(
      {
        required String host,
        required String topicpub,
        required String topicsub,
        required String identifier,
        required MQTTAppState state,
      }) :
        _identifier = identifier, _topicpub = topicpub,_topicsub = topicsub, _host = host, _currentState = state;

  void initializeMQTTClient(){
    _client = MqttServerClient(_host, _identifier);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = onDisconnected;
    _client!.secure = false;
    _client!.logging(on: true);

    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic('willTopic')
        .withWillMessage('willMessage')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('Connecting to emqx...');
    _client!.connectionMessage = connMess;
  }

  void connect() async {
    assert(_client != null);
    try {
      print('Start client connecting...');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client!.connect();
    } on Exception catch (e) {
      print('client exception - $e');
      disconnect();
    }
  }
  void disconnect(){
    print('Disconnected');
    _client!.disconnect();
  }

  void publish(String message){
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(_topicpub, MqttQos.exactlyOnce, builder.payload!);
  }

  void onSubscribed(String topic)
  {
    print('Subscribed comfirmed for topic $_topicpub');
  }

  void onDisconnected(){
    print('OnDisconnected client callback - Client disconnection');
    if (_client!.connectionStatus!.returnCode == MqttConnectReturnCode.noneSpecified){
      print('callback is solicited, this is corect');
    }
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  void onConnected(){
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    print('Emqx client connected....');
    _client!.subscribe(_topicsub, MqttQos.atLeastOnce);
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String pt =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
      _currentState.setReceivedText(pt);
      print('Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    });
  }
}