import 'package:flutter/material.dart';

class LottieState extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LottieState();
  }
}
class _LottieState extends State<LottieState> with SingleTickerProviderStateMixin{
  late final AnimationController _controller;
  late MQTT _mqtt;
  late MQTTAppState _currentState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MQTT mqtt = Provider.of<MQTT>(context);
    _mqtt = mqtt;
    MQTTAppState currentState = Provider.of<MQTTAppState>(context);
    _currentState = currentState;
    return Column(
        children: [
          Lottie.asset(
              'assets/benuoc.json',
              controller: _controller,
              onLoaded: (composition){
                _controller.duration = composition.duration;
                _controller.forward();
                _controller.value = _mqtt.getAppState.getUserNhietDo.toDouble()/100;
              }
          ),
          Text('${_controller.value = _mqtt.getAppState.getUserNhietDo.toDouble()/100}'),
        ]);
  }
}