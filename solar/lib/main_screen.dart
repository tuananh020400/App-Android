import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar/mqtt.dart';
import 'package:solar/mqtt_manager.dart';
import 'package:solar/mqtt_app_state.dart';
import 'package:solar/gatepage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


class MQTTView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MQTTViewState();
  }
}

class _MQTTViewState extends State<MQTTView>{
  late MQTTAppState _currentAppState;
  late MQTTManager _manager;
  late MQTT _mqtt;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    _currentAppState = appState;
    final MQTT mqtt = Provider.of<MQTT>(context);
    _mqtt = mqtt;
    final Scaffold scaffold = Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Solar App'),
        leading: Container(
          child: Center(
            child: Image(image: AssetImage('assets/Logo.png'),),
          ),

        ),
        actions: <Widget>[
          Icon(context.watch<MQTTAppState>().getIconData)
        ],
      ),
      body: _buildColumn(),
    );
    return scaffold;
  }

  Widget _buildColumn(){
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(10)),
        _buildConnectButton(_currentAppState.getAppConnectionState),
        Padding(padding: EdgeInsets.all(10)),
        _buildGardenButton(_currentAppState.getAppConnectionState),
        Padding(padding: EdgeInsets.all(10)),
      ],
    );
  }

  Widget _buildConnectButton(MQTTAppConnectionState state){
    return Row(
      children: <Widget>[
        Expanded(
            child: RaisedButton(
              color: Colors.lightGreenAccent,
              child: Icon(Icons.connected_tv),
              onPressed: state == MQTTAppConnectionState.disconnected? _configureAndConnect : null,
            )),
        const SizedBox(width: 10,),
        Expanded(
            child: RaisedButton(
              color: Colors.red,
              child: const Text('Disconnect'),
              onPressed: state == MQTTAppConnectionState.connected? _disconnect : null,
            ),
        )
      ],
    );
  }

  Widget _buildGardenButton(MQTTAppConnectionState state){
      return InkWell(
            onTap: () {
              if(state == MQTTAppConnectionState.connected) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GatePage()));
              }
              else{
                return null;
              }
            },
            child: Container(
              padding: EdgeInsets.all(40),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: state == MQTTAppConnectionState.connected? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text('Vườn 1',
                      style: TextStyle(
                          color: state == MQTTAppConnectionState.connected? Colors.white : Colors.white38,
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: CircularPercentIndicator(
                              radius: 50,
                              percent: _currentAppState.getUserNhietDo.toDouble() / 100,
                              progressColor: Colors.red,
                              backgroundColor: state == MQTTAppConnectionState.connected? Colors.deepPurple.shade100 : Colors.white38,
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text(state == MQTTAppConnectionState.connected? "${_currentAppState.getUserNhietDo.toDouble()}°C" : "Nhiệt độ",
                                style: TextStyle(
                                    color: state == MQTTAppConnectionState.connected? Colors.white : Colors.white38,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),

                        Expanded(
                          child: Container(
                            child: CircularPercentIndicator(
                              radius: 50,
                              percent: _currentAppState.getUserDoAm.toDouble() / 100,
                              progressColor: Colors.red,
                              backgroundColor: state == MQTTAppConnectionState.connected? Colors.deepPurple.shade100 : Colors.white38,
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text(state == MQTTAppConnectionState.connected? "${_currentAppState.getUserDoAm.toDouble()}%" : "Độ ẩm",
                                style: TextStyle(
                                    color: state == MQTTAppConnectionState.connected? Colors.white : Colors.white38,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            child: CircularPercentIndicator(
                              radius: 50,
                              percent: _currentAppState.getUserDoAmDat.toDouble() / 100,
                              progressColor: Colors.red,
                              backgroundColor: state == MQTTAppConnectionState.connected? Colors.deepPurple.shade100 : Colors.white38,
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text(state == MQTTAppConnectionState.connected? "${_currentAppState.getUserDoAmDat.toDouble()}%" : "Độ ẩm đất",
                                style: TextStyle(
                                    color: state == MQTTAppConnectionState.connected? Colors.white : Colors.white38,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  Padding(padding: EdgeInsets.all(5)),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Center(
                            child: const Text("Nhiệt độ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          child: Center(
                            child: const Text("Độ ẩm",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          child: Center(
                            child: const Text("Độ ẩm đất",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
        );
  }

  void _configureAndConnect(){
    _manager = MQTTManager(
      host: 'broker.emqx.io',
      topicpub: 'publish',
      topicsub: 'subscribe',
      identifier: 'My App Flutter',
      state: _currentAppState,
    );
    _manager.initializeMQTTClient();
    _manager.connect();
    _mqtt.setAppState(_currentAppState);
    _mqtt.setManager(_manager);
  }

  void _disconnect(){
    _manager.disconnect();
  }
  void publish(String text){
    _manager.publish(text);
  }
}



