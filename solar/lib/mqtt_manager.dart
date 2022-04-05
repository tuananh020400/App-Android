import 'package:solar/mqtt_app_state.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTManager{
  final MQTTAppState _currentState;
  MqttServerClient? _client;
  final String _identifier;
  final String _host;
  final String _topicpub;
  final String _topicsub;

  MQTTManager({
    required String host,
    required String topicpub,
    required String topicsub,
    required String identifier,
    required MQTTAppState state}):
        _identifier = identifier,
        _host = host,
        _topicpub = topicpub,
        _topicsub = topicsub,
        _currentState = state;

  void initializeMQTTClient(){
    _client = MqttServerClient(_host, _identifier);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = onDisconnected;
    _client!.secure = false;
    _client!.logging(on: true);

    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;

    final MqttConnectMessage mess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('Connecting to emqx client');
    _client!.connectionMessage = mess;
  }

  void connect() async {
    assert(_client != null);
    try {
      print("Start client connecting...");
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client!.connect();
    } on Exception catch (e){
      print('Client exception - $e');
      disconnect();
    }
  }

  void disconnect(){
    print('Disconnect');
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
    if(_client!.connectionStatus!.returnCode == MqttConnectReturnCode.noneSpecified){
      print('OnDisconnected callback is solicited, this is correct');
    }
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  void onConnected(){
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    print('Client connected');
    _client!.subscribe(_topicsub, MqttQos.atLeastOnce);
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
      _currentState.setReceivedText(pt);
    });
  }
}