import 'package:mqtt_client/mqtt_client.dart' as mqtt;

class myMessage {
  final String mytopic;
  final String mymessage;
  final mqtt.MqttQos myqos;

  myMessage({this.mytopic, this.mymessage, this.myqos});
}