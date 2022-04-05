import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum MQTTAppConnectionState {connected, disconnected, connecting}
class MQTTAppState with ChangeNotifier{
  MQTTAppConnectionState _appConnectionState = MQTTAppConnectionState.disconnected;
  String _receivedText = '';
  String _historyText = '';
  IconData _data = Icons.cloud_off;

  void setReceivedText(String text){
    _receivedText = text;
    _historyText = _historyText + '\n' + _receivedText;
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state){
    _appConnectionState = state;
    switch (state) {
      case MQTTAppConnectionState.connected:
        _data = Icons.cloud_done;
        break;
      case MQTTAppConnectionState.disconnected:
        _data = Icons.cloud_off;
        break;
      case MQTTAppConnectionState.connecting:
        _data = Icons.cloud_upload;
        break;
    }
    notifyListeners();
  }
  String get getReceivedText => _receivedText;
  String get getHistotyText => _historyText;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
  IconData get getIconData => _data;
}