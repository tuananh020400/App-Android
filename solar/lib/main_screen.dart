import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  late MQTTAppState currentAppState;
  late MQTTManager manager;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    currentAppState = appState;
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
        _buildConnectButton(currentAppState.getAppConnectionState),
        Padding(padding: EdgeInsets.all(10)),
        _buildGate(),
        Padding(padding: EdgeInsets.all(10)),
        _buildScrollableTextWith(currentAppState.getHistotyText),
      ],
    );
  }

  Widget _buildConnectButton(MQTTAppConnectionState state){
    return Row(
      children: <Widget>[
        Expanded(
            child: RaisedButton(
              color: Colors.lightGreenAccent,
              child: const Text('Connect'),
              onPressed: state == MQTTAppConnectionState.disconnected? _configureAndConnect : null,
            )),
        const SizedBox(width: 10,),
        Expanded(
            child: RaisedButton(
              color: Colors.red,
              child: const Text('Disconnect'),
              onPressed: state == MQTTAppConnectionState.connected? _disconnect : null,
            ))
      ],
    );
  }

  Widget _buildGate(){
    if(currentAppState.getAppConnectionState == MQTTAppConnectionState.connected) {
      return
        InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GatePage()));
            },
            child: Container(
              padding: EdgeInsets.all(40),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text('GateWay', style: TextStyle(color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Container(
                    child: Row(
                      children: <Widget>[
                        CircularPercentIndicator(
                          radius: 45,
                          percent: currentAppState.getUserNhietDo.toDouble() / 100,
                          progressColor: Colors.red,
                          backgroundColor: Colors.deepPurple.shade100,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text("Nhiệt độ",style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.bold),),
                        ),
                        const SizedBox(width: 10,),

                        CircularPercentIndicator(
                          radius: 45,
                          percent: currentAppState.getUserNhietDo.toDouble() / 100,
                          progressColor: Colors.red,
                          backgroundColor: Colors.deepPurple.shade100,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text("Độ ẩm", style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.bold),),
                        ),
                        const SizedBox(width: 10,),
                        CircularPercentIndicator(
                          radius: 45,
                          percent: currentAppState.getUserNhietDo.toDouble() / 100,
                          progressColor: Colors.red,
                          backgroundColor: Colors.deepPurple.shade100,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text("Độ ẩm đất",style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
        );
    }
    else{
      return Container(
        padding: EdgeInsets.all(40),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: <Widget>[
            Container(
              child: Text('GateWay', style: TextStyle(color: Colors.white38,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Row(
                children: <Widget>[
                  Expanded(child: Container(
                    child:
                    CircularPercentIndicator(
                      radius: 50,
                      percent: 0,
                      progressColor: Colors.red,
                      backgroundColor: Colors.white38,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text("Nhiệt độ",style: TextStyle(color: Colors.white38, fontSize: 15,fontWeight: FontWeight.bold),),
                    ),
                  ),),
                  const SizedBox(width: 10,),

                  Expanded(child: Container(
                    child:
                    CircularPercentIndicator(
                      radius: 50,
                      percent: 0,
                      progressColor: Colors.red,
                      backgroundColor: Colors.white38,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text("Nhiệt độ",style: TextStyle(color: Colors.white38, fontSize: 15,fontWeight: FontWeight.bold),),
                    ),
                  ),),
                  const SizedBox(width: 10,),
                  Expanded(child: Container(
                    child:
                    CircularPercentIndicator(
                      radius: 50,
                      percent: 0,
                      progressColor: Colors.red,
                      backgroundColor: Colors.white38,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text("Nhiệt độ",style: TextStyle(color: Colors.white38, fontSize: 15,fontWeight: FontWeight.bold),),
                    ),
                  ),),
                  const SizedBox(width: 10,),
                ],
              ),
          ],
        ),
      );
    }
  }

  Widget _buildScrollableTextWith(String text){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 400,
        height: 200,
        child: SingleChildScrollView(
          child: Text(text),
        ),
      ),
    );
  }


  void _configureAndConnect(){
    manager = MQTTManager(
      host: 'broker.emqx.io',
      topicpub: 'publish',
      topicsub: 'subscribe',
      identifier: 'My App Flutter',
      state: currentAppState,
    );
    manager.initializeMQTTClient();
    manager.connect();
  }

  void _disconnect(){
    manager.disconnect();
  }
}



