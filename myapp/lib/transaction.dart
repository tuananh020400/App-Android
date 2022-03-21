import 'package:flutter/material.dart';
class Transaction {
  String content;
  double amount;
  DateTime createTime;
  //constructor
  Transaction({required this.content, required this.amount, required this.createTime});
  @override
  String toString() {
    // TODO: implement toString
    return 'content: $content, amount: $amount';
  }
}