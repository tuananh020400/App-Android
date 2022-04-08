import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:solar/mqtt_app_state.dart';
import 'package:solar/mqtt_manager.dart';
class GatePage extends StatefulWidget{
  @override
  _GatePageState createState()  => _GatePageState();
}

class _GatePageState extends State<GatePage>{
  late MQTTAppState currentAppState;
  late MQTTManager _manager;
  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    currentAppState = appState;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('GateWay'),
        actions: <Widget>[
          Icon(currentAppState.getIconData)
    ]),
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(5)),
          _buildJson(),
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
              percent: currentAppState.getUserNhietDo.toDouble()/100,
              progressColor: Colors.red,
              backgroundColor: Colors.deepPurple.shade100,
              circularStrokeCap: CircularStrokeCap.round,
              center: Text("Nhiệt độ"),
            ),
        ),
        Expanded(
          child: RaisedButton(
            child: const Text('Send Text'),
            onPressed: (){
              setState(() {
                print('alo');
                _manager.publish("ALOALOALO123");
              });
            },
          ),
        )
      ],
    );
  }

}
