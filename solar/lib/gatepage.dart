import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:solar/Chart.dart';
import 'package:solar/mqtt.dart';
import 'package:solar/mqtt_app_state.dart';
import 'animatedbutton.dart';
import 'package:lottie/lottie.dart';
class GatePage extends StatefulWidget{
  @override
  _GatePageState createState()  => _GatePageState();
}

class _GatePageState extends State<GatePage>{
  late MQTT _mqtt;
  late MQTTAppState _currentState;
  @override
  Widget build(BuildContext context) {
    final MQTT mqtt = Provider.of<MQTT>(context);
    _mqtt = mqtt;
    final MQTTAppState currentState = Provider.of<MQTTAppState>(context);
    _currentState = currentState;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF292639),
        title: const Text('Vườn 1'),
        actions: <Widget>[
          Icon(_mqtt.getAppState.getIconData)
    ]),
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(5)),
          _buildButton(),
          _buildAuto(),
          //LottieState(),
        ],
      ),
    );
  }

  Widget _buildJson(){
    return Row(
      children: [
        Expanded(
            child: CircularPercentIndicator(
              radius: 60,
              percent: _mqtt.getAppState.getUserNhietDo.toDouble()/100,
              progressColor: Colors.red,
              backgroundColor: Colors.deepPurple.shade100,
              circularStrokeCap: CircularStrokeCap.round,
              center: Text("${_mqtt.getAppState.getUserNhietDo.toDouble()}"),
            ),
        ),
        Container(
          child: Container(
            child: RaisedButton(
              child: const Text('Send Text'),
              onPressed: (){
                setState(() {
                  print('alo');
                  _mqtt.getManager.publish('message');
                });
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildButton(){
    return DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF292639),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TabBar(
                        indicator: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        tabs: [
                          Tab(child: Text('Nhiệt độ',style: TextStyle(fontWeight: FontWeight.bold),),),
                          Tab(child: Text('Độ ẩm',style: TextStyle(fontWeight: FontWeight.bold),),),
                          Tab(child: Text('Độ ẩm đất',style: TextStyle(fontWeight: FontWeight.bold),),),
                        ]),
                  )
              ),
              SizedBox(height: 10,),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF292639),
                  ),
                  child: SizedBox(
                    height: 300,
                    child: TabBarView(
                      children: [
                        _buildNhietDo(),
                        _buildDoAm(),
                        _buildDoAmDat()
                      ],
                    ),
                  )
              )
            ],
          )
        )
    );
  }

  Widget _buildAuto(){
    return AnimatedToggle(
      values: ['Auto', 'Manual'],
      Stringtext: ['Manual', 'Auto'],
      textColor: Colors.white,
      backgroundColor: Colors.black,
      buttonColor: Colors.blue,
      onToggleCallback: (index) {
        setState(() {});
        print('$index');
        _mqtt.getManager.publish('$index');
      },
    );
  }

  Widget _buildDoAm() {
    return Container(
      height: 100,
      child: Stack(
        children: [
          Center(
            child: Lottie.asset('assets/water.json'),
          ),
          Center(
            child: Lottie.asset('assets/in.json'),
          ),
          Center(
            child: Text('${_mqtt.getAppState.getUserDoAm}%',
              style: TextStyle(
                color: Color(0xFF0D3770),
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDoAmDat(){
    return Container(
      height: 100,
      child: Stack(
        children: [
          Center(
            child: Lottie.asset('assets/out.json'),
          ),
          Center(
            child: Lottie.asset('assets/in.json'),
          ),
          Center(
            child: Text('${_mqtt.getAppState.getUserDoAmDat}%',
              style: TextStyle(
                color: Color(0xFF0D3770),
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _buildNhietDo(){
    return Chart(data: _mqtt.getAppState.getUserNhietDo.toDouble());
  }
}

class LottieState extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LottieState();
  }
}

class _LottieState extends State<LottieState> with SingleTickerProviderStateMixin{
  late final AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Lottie.asset(
        'assets/benuoc.json',
      controller: _controller,
      onLoaded: (composition) {
          _controller
            ..duration = composition.duration
              ..forward();
      }
    );

  }
}



