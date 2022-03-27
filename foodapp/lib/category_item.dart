import 'package:flutter/material.dart';
import 'package:foodapp/models/category.dart';
import 'package:foodapp/foods_page.dart';
class CategoryItem extends StatelessWidget{
  Category category;
  CategoryItem({required this.category});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: (){
        print('Tappppppp ${this.category.content}');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FoodsPage(category: this.category)
        ));
      },
      splashColor: Colors.black,

      child: Container(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(this.category.content, style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'AbrilFatface'),)
            ],
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                this.category.color.withOpacity(0.6),
                this.category.color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}