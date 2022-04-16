import 'package:flutter/material.dart';
import 'mqtt.dart';
import 'mqtt_app_state.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF292636),
          title: Text('GateWay',style: TextStyle(fontWeight: FontWeight.bold),),
          actions: <Widget>[
            Icon(_mqtt.getAppState.getIconData)
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            alignment: Alignment.topCenter,
            height: 500,width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xFF292636),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
                children: [
                  Container(
                    width: 150,
                        alignment: Alignment.topLeft,
                        child: Lottie.asset(
                            'assets/benuoc.json',
                            controller: _controller,
                            onLoaded: (composition){
                              _controller.duration = composition.duration;
                              _controller.forward();
                              _controller.value = _mqtt.getAppState.getGardent1.getNhietDo.toDouble()/100;
                            }
                        ),
                  ),
                  Container(
                    width: 60,
                    child: Text('${_mqtt.getAppState.getGardent1.getNhietDo}%'),
                  )
                ]),
          ),
        )
    );
  }
}