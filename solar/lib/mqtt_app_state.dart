import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum MQTTAppConnectionState {connected, disconnected, connecting}
class MQTTAppState with ChangeNotifier{
  MQTTAppConnectionState _appConnectionState = MQTTAppConnectionState.disconnected;
  String _receivedText = '';
  var _user;
  dynamic _userNhietDo = 0;
  dynamic _userDoAm = 0;
  dynamic _userDoAmDat = 0;
  IconData _icon = Icons.cloud_off;
  String _connectionStringText = 'Disconnected';

  void setReceivedText(String text){
    _receivedText = text;
    _user = jsonDecode(_receivedText);
    _userNhietDo = _user['nhietdo'];
    _userDoAm = _user['doam'];
    _userDoAmDat = _user['doamdat'];
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state){
    _appConnectionState = state;
    switch (state) {
      case MQTTAppConnectionState.connected:
        _icon = Icons.cloud_done;
        _connectionStringText = 'Connected';
        break;
      case MQTTAppConnectionState.disconnected:
        _icon = Icons.cloud_off;
        _connectionStringText = 'Disconnected';
        break;
      case MQTTAppConnectionState.connecting:
        _icon = Icons.cloud_upload;
        _connectionStringText = 'Connecting';
        break;
    }
    notifyListeners();
  }
  String get getReceivedText => _receivedText;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
  IconData get getIconData => _icon;
  dynamic get getUserNhietDo => _userNhietDo;
  dynamic get getUserDoAm => _userDoAm;
  dynamic get getUserDoAmDat => _userDoAmDat;
  dynamic get getConnectionStringText => _connectionStringText;
}