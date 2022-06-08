import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';


class TitleWithCost extends StatefulWidget {
  String title;
  int cost;
  TextStyle style;

  TitleWithCost({
    Key? key,
    required this.title,
    required this.cost,
    required this.style,
  }) : super(key: key);

  @override
  _TitleWithCostState createState() => _TitleWithCostState();
}

class _TitleWithCostState extends State<TitleWithCost> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: widget.style,
          ),
          CountdownTimer(
            endTime: widget.cost,
            textStyle: const TextStyle(fontSize: 20, color: Colors.red),
            onEnd: () {

            },
          ),
        ],
      ),
    );
  }
}
