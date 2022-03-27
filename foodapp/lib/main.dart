import 'package:flutter/material.dart';
import 'package:foodapp/categories_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Garden 1', style: TextStyle(color: Colors.white,fontFamily: 'AbrilFatface'),),
          backgroundColor: Colors.green,
        ),
        body: CategoriesPage(),
      ),
    );
  }
}
