import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar/Chart.dart';
import 'package:solar/mqtt.dart';
import 'package:solar/mqtt_app_state.dart';
import 'animatedbutton.dart';
import 'package:lottie/lottie.dart';

// _buildNhietDo()
// _buildDoAm()
// _buildDoAmDat()
// _buildTabView()

class NodePage extends StatefulWidget{
  @override
  _NodePageState createState()  => _NodePageState();
}

class _NodePageState extends State<NodePage> with TickerProviderStateMixin{
  late MQTT _mqtt;
  late MQTTAppState _currentState;
  late final AnimationController _lightController;
  late final AnimationController _fanController;
  late final AnimationController _pumpController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fanController = AnimationController(vsync: this);
    _lightController = AnimationController(vsync: this);
    _pumpController = AnimationController(vsync: this);
  }

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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(5)),
            _buildTabView(),
            _buildAuto(),
            _buildButton()
          ],
        ),
      )
    );
  }

  Widget _buildTabView(){
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
                        _buildDoAmDat(),
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
      text: ['Auto', 'Manual'],
      buttonText: ['Manual', 'Auto'],
      onColor: Colors.blue,
      offColor: Colors.blue,
      onToggleCallback: (index) {
        setState(() {});
        print('$index');
        _mqtt.getManager.publish('$index');
      },
    );
  }

  Widget _buildNhietDo(){
    return Chart(data: _mqtt.getAppState.getGardent1.getNhietDo.toDouble());
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
            child: Text('${_mqtt.getAppState.getGardent1.getDoAm}%',
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
            child: Text('${_mqtt.getAppState.getGardent1.getDoAmDat}%',
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
  
  Widget _buildButton(){
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Container(
          height: 100,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF292636),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            width: 60,
                            child: _mqtt.getAppState.getGardent1.getFanStatus == 1?
                            Lottie.asset(
                              'assets/fan.json',
                            ) :
                            Lottie.asset(
                                'assets/fanoff.json',
                                repeat: false,
                              controller: _fanController,
                              onLoaded: (composition){
                                  _fanController.duration = composition.duration;
                                  _fanController.forward();
                                  _fanController.value = 0;
                              }
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              SizedBox(width: 10,),
              Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF292636),
                    ),
                    child: Column(
                      children: [
                        Expanded(child: _mqtt.getAppState.getGardent1.getLightStatus == 1?
                            Lottie.asset(
                                'assets/light.json',
                              controller: _lightController,
                              repeat: true,
                              onLoaded: (composition){
                                  _lightController.duration = composition.duration;
                                  _lightController.forward();
                              }
                            ) :
                            Lottie.asset(
                                'assets/lightoff.json',
                              repeat: false
                            )),
                      ],
                    ),
                  )),
              SizedBox(width: 10,),
              Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF292636),
                    ),
                    child: Column(
                      children: [
                        Expanded(child: Lottie.asset(
                            'assets/binhnuoctuoicay.json'
                        )
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
    );
  }

}






