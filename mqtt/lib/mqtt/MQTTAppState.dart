import 'package:flutter/cupertino.dart';

enum MQTTAppConnectionState {connected, disconnected, connecting}

class MQTTAppState with ChangeNotifier{
  MQTTAppConnectionState _appConnectionState = MQTTAppConnectionState.disconnected;
  String _receivedText = '';
  String _historyText = '';
  int _nhietdo = 123;

  void setReceivedText(String text){
    _receivedText = text;
    _historyText = _historyText + '\n' + _receivedText;
    _nhietdo = int.parse(_receivedText);
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state){
    _appConnectionState = state;
    notifyListeners();
  }

  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
  int get getNhietDo => _nhietdo;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
}