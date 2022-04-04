import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => CounterProvider(),
        child: MaterialApp(
          home: _CounterHome(),
        ),
      )
    )
  );
}

class CounterProvider extends ChangeNotifier{
  int _counter = 0;
  int get counter => _counter;
  void add(){
    _counter++;
    notifyListeners();
  }
}

class _CounterHome extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.watch<CounterProvider>().counter.toString(),
            style: TextStyle(fontSize:  50),),
            ElevatedButton(
                onPressed: (){
                  Navigator.push((context), MaterialPageRoute(builder: (_) => SecondScreen()));

                },
                child: Text('Go to second Screen'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.read<CounterProvider>().add();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.watch<CounterProvider>().counter.toString(),
              style: TextStyle(fontSize:  50),),
            ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);

                },
                child: Text('Go to HomeScreen'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.read<CounterProvider>().add();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

