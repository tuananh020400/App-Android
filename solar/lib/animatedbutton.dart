import 'package:flutter/material.dart';
class AnimatedToggle extends StatefulWidget {
  final List<dynamic> text;
  final List<dynamic> buttonText;
  final ValueChanged onToggleCallback;
  final Color onColor;
  final Color offColor;

  final backgroundColor = Color(0xFF292636);
  final textColor = Colors.white;

  AnimatedToggle({
    required this.text,
    required this.buttonText,
    required this.onToggleCallback,
    required this.onColor,
    required this.offColor,
  });
  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  bool initialPosition = true;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              initialPosition = !initialPosition;
              var index = 0;
              if (!initialPosition) {
                index = 1;
              }
              widget.onToggleCallback(index);
              setState(() {});
            },
            child: Container(
              width: width,
              height: width * 0.155,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(width * 0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  widget.text.length,
                      (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: Text(
                      widget.text[index],
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF918f95),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(5),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.decelerate,
              alignment:
              initialPosition ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: width * 0.5,
                height: width * 0.13,
                decoration: ShapeDecoration(
                  color: initialPosition ?widget.offColor : widget.onColor,
                  shadows: null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.1),
                  ),
                ),
                child: Text(
                  initialPosition ? widget.buttonText[1] : widget.buttonText[0],
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: width * 0.045,
                    color: widget.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                alignment: Alignment.center,
              ),
            ),),
        ],
      ),
    );
  }
}