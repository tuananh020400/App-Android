/*
*
*   ***************************Created 03/25/2021**********************
*   ***************************     UET - VNU    **********************
*
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'config.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_client.dart';
import 'message.dart';
import 'send_message.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

Color activeColor1 = Colors.lightBlueAccent;
final flutterWebviewPlugin = new FlutterWebviewPlugin();



void main() => runApp(new MaterialApp(
  theme: ThemeData(
      appBarTheme: AppBarTheme(
        color: Colors.red,
      )),
  home: new MyApp(),
));



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'Baby Crib UET',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomePage(),
      );

  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  var nhietdo_Pcess = 0.0 ;
  var doam_Pcess = 0.0;
  var nhietdo_Process = 0.0;
  var doam_Process  = 0.0;


  bool _showPass = false;
  String titleBar = 'IOT SMART HOME MQTT';
  String clientIdentifier = 'lamhx';
  String mqtt_server = "mqtt.ngoinhaiot.com";
  String mqtt_user = "nguyennhatlam.uet";
  String mqtt_pass = "nguyennhatlam.uet";
  int mqtt_port = 1111; // esp kết nối mqtt => TCP
  String topic = 'nguyennhatlam.uet/subscribe';
  String topicapp = 'nguyennhatlam.uet/publish';
  String data = "Data MQTT";
  String nhietdo = "0";
  String doam = "0";
  String anhsang = "0";
  String thietbi1 = "OFF";
  String thietbi2 = "OFF";
  String thietbi3 = "OFF";
  String chedo = "AUTO";

  String diachi = "" ;
  String ipCam = "";


  var pirOld = 3;

  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;
  StreamSubscription subscription;
  TextEditingController brokerController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwdController = TextEditingController();
  TextEditingController identifierController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  Set<String> topics = Set<String>();
  List<myMessage> messages = <myMessage>[];
  ScrollController messageController = ScrollController();
  String CheckMQTT = "Disconnect";
  String Connect = "Connect";
  // int biencheckMqtt = 0;

  // String valueSwich = "OFF";
  // bool status = false;

  bool isSelected_connect = false;
  bool isSelected_1 = false;
  bool isSelected_2 = false;
  bool isSelected_3 = false;
  bool isSelected_4 = false;
  List<bool> isSelected_mode = [false, false];

  var selectedIndex = 0;
  bool deTect = false;

  bool isRunning = false;



  /* *******************local notification************************
  ************************************************************** */
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOs);

    // flutterLocalNotificationsPlugin.initialize(initSetttings,
    //     onSelectNotification: onSelectNotification);
  }


  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }
  Future<void> cancelNotification1() async {
    await flutterLocalNotificationsPlugin.cancel(1);
  }
  showNotification() async {
    var android = new AndroidNotificationDetails(
        'id', 'channel ', 'description',
        sound:RawResourceAndroidNotificationSound('goes_without_saying'),
        icon: 'app_icon',
        largeIcon: DrawableResourceAndroidBitmap('app_icon'),
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Smart Crib', 'Em bé đang khóc', platform,
        payload: 'Welcome to the Smart Crib ');
  }

  showNotification1() async {
    var android = new AndroidNotificationDetails(
        'id', 'channel ', 'description',
        sound:RawResourceAndroidNotificationSound('goes_without_saying'),
        icon: 'app_icon',
        largeIcon: DrawableResourceAndroidBitmap('app_icon'),
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        1, 'Smart Crib', 'Phát hiện chuyển động bất thường', platform,
        payload: 'Welcome to the Smart Crib ');
  }

  /* **************************************************************
  ************************************************************** */


  @override
  Widget build(BuildContext context) {

    bool kisweb;
    try{
      if(Platform.isAndroid||Platform.isIOS) {
        kisweb=false;
      } else {
        kisweb=true;
      }
    } catch(e){
      kisweb=true;
    }


    parsePercent(nhietdo, doam);
    /*
    ********** Icon state connect
     */
    IconData connectionStateIcon;
    switch (client?.connectionState) {
      case mqtt.MqttConnectionState.connected:
        connectionStateIcon = Icons.cloud_done;
        Connect = 'Disconnect';
        break;
      case mqtt.MqttConnectionState.disconnected:
        connectionStateIcon = Icons.cloud_off;
        Connect = 'Connect';
        /*
          ************ RESET full state button
         */
        nhietdo = '0';
        doam = '0';
        nhietdo_Process = 0;
        doam_Process = 0;
        isSelected_1 = false;
        isSelected_2 = false;
        isSelected_3 = false;
        isSelected_4 = false;
        isSelected_mode = [false, false];
        selectedIndex = 0;
        deTect = false;
        break;
      case mqtt.MqttConnectionState.connecting:
        connectionStateIcon = Icons.cloud_upload;
        break;
      case mqtt.MqttConnectionState.disconnecting:
        connectionStateIcon = Icons.cloud_download;
        Connect = 'Connect';
        break;
      case mqtt.MqttConnectionState.faulted:
        connectionStateIcon = Icons.error;
        Connect = 'Connect';
        break;
      default:
        connectionStateIcon = Icons.cloud_off;
    }

    return Scaffold(
      backgroundColor: primaryColor,
      body:
      Container(
        padding: EdgeInsets.all(0.5),
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(1.0),
                child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 3.0, color: Colors.lightBlue.shade900),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height:20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Container(
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Center(
                                    child: Icon(
                                      connectionStateIcon,
                                      color: Colors.grey,
                                      size: 31,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'SMART CRIB',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 50,
                                color: primaryColor,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Center(
                                    child:
                                    Image(
                                      image: AssetImage('assets/111.jpg'),)
                                  ),
                                ),
                              ),
                            ]),
                      ],
                    ))),
            Text(
              'UET-VNU',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new CircularPercentIndicator(
                          radius: 110.0,
                          lineWidth: 5.0,
                          animation: true,
                          percent: nhietdo_Process,
                          center: Text(
                            "$nhietdo°C",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          footer:
                          new Text(
                            "Nhiệt độ",
                            style: new TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.red,
                        ),
                        new Padding(
                          padding: EdgeInsets.all(15),
                        ),
                        new CircularPercentIndicator(
                          radius: 110.0,
                          lineWidth: 5.0,
                          animation: true,
                          percent: doam_Process,
                          center: new Text(
                            "$doam%",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          footer: Center(
                            child: Container(
                              child: Text(
                                "Độ ẩm",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            // Stream
            // SizedBox(height: 34),
            //

            // Text(
            //   "Live Stream",
            //   style: new TextStyle(
            //       fontWeight: FontWeight.bold, fontSize: 15),
            // ),

            Container(
              height: 220,
              width: 320,
                child: Mjpeg(
                  isLive: isRunning,
                  // stream: 'http://192.168.2.104:81/stream',
                  stream: diachi,
                )
            ),

            // Container(
              //   child: WebView(
              //     initialUrl:  'http://192.168.43.238:81/stream',
              //     javascriptMode: JavascriptMode.unrestricted,
              //   ),
              // ),

            // SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(12),
              // height: 250,
              height: 165,
              child: StaggeredGridView.count(
                crossAxisCount: 5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                staggeredTiles: [
                  StaggeredTile.count(2, 2),
                  StaggeredTile.count(3, 1),
                  StaggeredTile.count(1, 1),
                  StaggeredTile.count(1, 1),
                  StaggeredTile.count(1, 1),
                ],
                children: <Widget>[
                  // connect button
                  ClayContainer(
                      borderRadius: 10,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isSelected_connect = !isSelected_connect;
                            if (isSelected_connect) {
                              ConnectMQTT();
                              diachi =  ipCam ;
                              print(diachi);
                              isRunning = true;
                            } else if (!isSelected_connect) {
                              _disconnect();
                              diachi =  '';
                              isRunning = false;

                              flutterWebviewPlugin.reload();
                            }
                          });
                        },
                        child: ClayContainer(
                          height: MediaQuery.of(context).size.width * 1 / 7,
                          width: MediaQuery.of(context).size.width * 1 / 7,
                          borderRadius: 10,
                          color: primaryColor,
                          surfaceColor: isSelected_connect ? activeColor1 : activeColor3,
                          child: Icon(Icons.power_settings_new_outlined,
                              color: Colors.white, size: 30),
                        ),
                      )),
                  FlutterToggleTab(
                      width: 54,
                      borderRadius: 20,
                      initialIndex:0,
                      selectedIndex: selectedIndex,
                      selectedBackgroundColors: [activeColor1],
                      unSelectedBackgroundColors: [Colors.white30],
                      selectedTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      unSelectedTextStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      labels: ["MANUAL","AUTO"],
                      icons: [Icons.settings_sharp,Icons.person],
                      selectedLabelIndex: (index) {
                        setState(() {
                          selectedIndex = index;
                          if(selectedIndex == 1 )
                              {
                                publish('L1M'); // MANUAL
                              }
                              else {
                                publish('L0M'); // AUTO
                              }
                        });
                        }),

                  ClayContainer(
                      borderRadius: 10,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isSelected_1 = !isSelected_1;
                            if (!isSelected_1) {
                              publish('G0H');
                            } else
                              publish('G1H');
                          });
                        },
                        child: ClayContainer(
                          borderRadius: 10,
                          color: primaryColor,
                          surfaceColor: isSelected_1 ? activeColor1 : activeColor3,
                          child: Icon(FontAwesomeIcons.lightbulb,
                              color: Colors.white, size: 20),
                        ),
                      )),
                  ClayContainer(
                      borderRadius: 10,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isSelected_2 = !isSelected_2;
                            if (!isSelected_2) {
                              publish('H0I');
                            } else
                              publish('H1I');
                          });
                        },
                        child: ClayContainer(
                          height: MediaQuery.of(context).size.width * 1 / 7,
                          width: MediaQuery.of(context).size.width * 1 / 7,
                          borderRadius: 10,
                          color: primaryColor,
                          surfaceColor: isSelected_2 ? activeColor1 : activeColor3,
                          child: Icon(FontAwesomeIcons.fan,
                              color: Colors.white, size: 20),
                        ),
                      )),
                  ClayContainer(
                      borderRadius: 10,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isSelected_3 = !isSelected_3;
                            if (!isSelected_3) {
                              publish('I0K');
                            } else
                              publish('I1K');
                          });
                        },
                        child: ClayContainer(
                          height: MediaQuery.of(context).size.width * 1 / 7,
                          width: MediaQuery.of(context).size.width * 1 / 7,
                          borderRadius: 10,
                          color: primaryColor,
                          surfaceColor: isSelected_3 ? activeColor1 : activeColor3,
                          child: Icon(FontAwesomeIcons.music,
                              color: Colors.white, size: 20),
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // khai bao ham get du lieu MQTT

  void _Click_ConnectMQTT() async {
    setState(() {
      //ConnectMQTT();
      if (Connect == 'connect') {
        Connect = 'disconnect';
        ConnectMQTT();
      }
      else {
        Connect = 'connect';
        _disconnect();
      }
    });


  }

  void ConnectMQTT() async {
    client = mqtt.MqttClient(mqtt_server, '');
    client.port = mqtt_port;
    client.logging(on: true);
    client.keepAlivePeriod = 30;
    client.onDisconnected = _onDisconnected;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean()
        .keepAliveFor(30)
        .withWillTopic('DisconnectMQTT')
        .withWillMessage('DisconnectMQTT')
        .withWillQos(mqtt.MqttQos.atMostOnce);
    client.connectionMessage = connMess;
    try {
      //await client.connect('toannv10291', 'toannv10291');
      await client.connect(mqtt_user, mqtt_pass);
    } catch (e) {
      // print(e);
      _disconnect();
    }
    if (client.connectionState == mqtt.MqttConnectionState.connected) {
      setState(() {
        connectionState = client.connectionState;
        client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
        print('CONNECT MQTT AND SUBSCRIBE TOPIC: $topic');
      });
    } else {
      _disconnect();
      print('Connection failed , state is ${client.connectionState}');
    }
    subscription = client.updates.listen(_onMessage);
  }

  void _disconnect() {
    client.disconnect();
    _onDisconnected();
    print('Disconnect Broker MQTT');

  }

  void _onDisconnected() {
    setState(() {});
    print('Disconnect Broker MQTT');
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    // hàm nhận dũ liệu từ server mqtt
    final mqtt.MqttPublishMessage recMess =
    event[0].payload as mqtt.MqttPublishMessage;
    final String message =
    mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    // print('MQTT message:${message}');
    data = message;
    // print('Data :${data}');
    // xử lý dữ liệu json

    var DataJsonObject = json.decode(data);

    setState(() {
      nhietdo = DataJsonObject['nhietdo'];
      doam = DataJsonObject['doam'];

      if (DataJsonObject['ipCam'] != null) {
        ipCam =  DataJsonObject['ipCam'].toString();
      }
      print("***********************************************");
      print("***********************************************");
      print("***********************************************");
      print("***********************************************");
      print("***********************************************");
      print("***********************************************");
      print(ipCam);
    });

    //status
    setState(() {
      if (DataJsonObject['thietbi1'] == "OFF") {
        thietbi1 = "OFF";
        isSelected_1 = false;
      } else if (DataJsonObject['thietbi1'] == "ON") {
        isSelected_1 = true;
        thietbi1 = "ON";
      }
      if (DataJsonObject['thietbi2'] == "OFF") {
        thietbi2 = "OFF";
        isSelected_2 = false;
      } else if (DataJsonObject['thietbi2'] == "ON") {
        isSelected_2 = true;
        thietbi2 = "ON";
      }
      if (DataJsonObject['thietbi3'] == "OFF") {
        thietbi3 = "OFF";
        isSelected_3 = false;
      } else if (DataJsonObject['thietbi3'] == "ON") {
        isSelected_3 = true;
        thietbi3 = "ON";
      }
      if (DataJsonObject['chedo'] == "AU") {
        selectedIndex = 1;
      } else if (DataJsonObject['chedo'] == "MA") {
        selectedIndex = 0;
      }

      if (DataJsonObject['tiengdong'] == "1") {
        showNotification();
      }
      if (DataJsonObject['tiengdong'] == "0") {
        cancelNotification();
      }


      /**
      ************************************ Active pir notification
       * if pir send mqtt 10 signal edges ->  active notification
       * else
      ***/

      if (DataJsonObject['pir'] == "1")
      {
        pirOld -- ;
        print('**************************************');
        print(pirOld);
        if (pirOld == 0)
          {
            showNotification1();
            FlutterRingtonePlayer.playRingtone();
            pirOld = 3;

          }
        else {
          // FlutterRingtonePlayer.stop();
           }
      }
      if (DataJsonObject['pir'] == "0") {
        // FlutterRingtonePlayer.stop();
        // cancelNotification1();
        }
    });

    setState(() {
      messages.add(myMessage(
        mytopic: event[0].topic,
        mymessage: message,
        myqos: recMess.payload.header.qos,
      ));
      try {
        messageController.animateTo(
          0.0,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      } catch (_) {}
    });
  }

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      setState(() {
        if (topics.add(topic.trim())) {
          // print('Subscribing to ${topic.trim()}');
          client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
        }
      });
    }
  }

  void _unsubscribeFromTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      setState(() {
        if (topics.remove(topic.trim())) {
          // print('Unsubscribing from ${topic.trim()}');
          client.unsubscribe(topic);
        }
      });
    }
  }

  void publish(String message) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topicapp, MqttQos.exactlyOnce, builder.payload);
      // print('Data send:  ${message}');
    }
  }


  void parsePercent(String nhietdo1, String doam1)
  {
    nhietdo_Pcess = double.parse(nhietdo1);
    assert(nhietdo_Pcess is double);
    nhietdo_Process = nhietdo_Pcess /100;

    doam_Pcess = double.parse(doam1);
    assert(doam_Pcess is double);
    doam_Process = doam_Pcess / 100;
  }

}// class homepage
