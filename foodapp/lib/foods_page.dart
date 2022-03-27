import 'package:flutter/material.dart';
import 'package:foodapp/models/category.dart';
class FoodsPage extends StatelessWidget{
  Category category;
  FoodsPage({required this.category});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('You are in ${this.category.content}'),
      ),
      body: Center(
        child: Text('Hello'),
      ),
    );
  }
}