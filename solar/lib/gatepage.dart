import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:solar/mqtt_app_state.dart';
import 'package:solar/mqtt_manager.dart';
import 'package:solar/mqtt.dart';
class GatePage extends StatefulWidget{
  @override
  _GatePageState createState()  => _GatePageState();
}

class _GatePageState extends State<GatePage>{
  late MQTT _mqtt;
  @override
  Widget build(BuildContext context) {
    final MQTT mqtt = Provider.of<MQTT>(context);
    _mqtt = mqtt;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('GateWay'),
        actions: <Widget>[
          Icon(_mqtt.getAppState.getIconData)
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
              percent: _mqtt.getAppState.getUserNhietDo.toDouble()/100,
              progressColor: Colors.red,
              backgroundColor: Colors.deepPurple.shade100,
              circularStrokeCap: CircularStrokeCap.round,
              center: Text("Nhiệt độ"),
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
}
