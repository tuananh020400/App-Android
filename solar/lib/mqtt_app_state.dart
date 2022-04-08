import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum MQTTAppConnectionState {connected, disconnected, connecting}
class MQTTAppState with ChangeNotifier{
  MQTTAppConnectionState _appConnectionState = MQTTAppConnectionState.disconnected;
  String _receivedText = '';
  String _historyText = '';
  var _user;
  String _userName = '';
  String _userEmail = '';
  int _userNhietDo = 0;
  IconData _data = Icons.cloud_off;

  void setReceivedText(String text){
    _receivedText = text;
    _user = jsonDecode(_receivedText);
    _userName = _user['name'];
    _userEmail = _user['email'];
    _userNhietDo = _user['nhietdo'];
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
  String get getUserName => _userName;
  String get getUserEmail => _userEmail;
  int get getUserNhietDo => _userNhietDo;
}