import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum MQTTAppConnectionState {connected, disconnected, connecting}
class MQTTAppState with ChangeNotifier{
  MQTTAppConnectionState _appConnectionState = MQTTAppConnectionState.disconnected;
  String _receivedText = '';
  Garden _garden1 = Garden(nhietDo: 0,doAmDat: 0,doAm: 0,lightStatus: 0,fanStatus: 0,pumStatus: 0);
  var _json;
  IconData _icon = Icons.cloud_off;
  String _connectionStringText = 'Disconnected';

  void setReceivedText(String text){
    _receivedText = text;
    _json = jsonDecode(_receivedText);
    _garden1 = Garden(
      nhietDo: _json['nhietdo'],
      doAm: _json['doam'],
      doAmDat: _json['doamdat'],
      lightStatus: _json['light'],
      fanStatus: _json['fan'],
      pumStatus: _json['pump']
    );
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
  dynamic get getConnectionStringText => _connectionStringText;
  Garden get getGardent1 => _garden1;
}

class Garden{
  dynamic _nhietDo = 0;
  dynamic _doAm = 0;
  dynamic _doAmDat = 0;
  int _lightStatus = 0;
  int _fanStatus = 0;
  int _pumpStatus = 0;
  Garden({
    required dynamic nhietDo,
    required dynamic doAm,
    required dynamic doAmDat,
    required int lightStatus,
    required int fanStatus,
    required int pumStatus,
  }) :
        _nhietDo = nhietDo,
        _doAm = doAm,
        _doAmDat = doAmDat,
        _lightStatus = lightStatus,
        _pumpStatus = pumStatus,
        _fanStatus = fanStatus;

  dynamic get getNhietDo => _nhietDo;
  dynamic get getDoAm => _doAm;
  dynamic get getDoAmDat => _doAmDat;
  int get getLightStatus => _lightStatus;
  int get getFanStatus => _fanStatus;
  int get getPumpStatus => _pumpStatus;
}