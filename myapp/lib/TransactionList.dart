import 'package:flutter/material.dart';
import 'transaction.dart';
class TransactionList extends StatelessWidget{
  List<Transaction> transactions;
  TransactionList ({required this.transactions});
  ListView _buildListView() {
    return ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            color: (index - 1) % 2 == 0 ? Colors.green : Colors.teal,
            elevation: 10,
            child: Row(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transactions[index].content,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white
                      ),),
                    Text("Date ${transactions[index].createTime}",
                      style: TextStyle(fontSize: 20, color: Colors.white),)
                  ],
                ),
                Text(data)
              ],
            )
            // ListTile(
            //   leading: const Icon(Icons.access_alarm),
            //   title: Text(transactions[index].content,
            //     style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 18,
            //         color: Colors.white
            //     ),
            //   ),
            //   subtitle: Text('Price: ${transactions[index].amount}',
            //       style: TextStyle(fontSize: 18, color: Colors.white)),
            //   onTap: () {
            //     print('You clicked: ${transactions[index].content}');
            //   },
            // ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 500,
      child: _buildListView(),
    );
  }
}