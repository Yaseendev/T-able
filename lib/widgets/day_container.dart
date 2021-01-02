import 'package:flutter/material.dart';

class DayCircleWidget extends StatefulWidget {
  final String day;
  DayCircleWidget(this.day);
  @override
  _DayCircleWidgetState createState() => _DayCircleWidgetState();
}

class _DayCircleWidgetState extends State<DayCircleWidget> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 30.0,
        height: 30.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? Color(0xFF2176E4) : Color(0xFFEFF3F2)),
        child: Center(child: Text(widget.day,style: TextStyle(color: selected ? Colors.white : Colors.black))),
      ),
      onTap: () {
        setState(() {
          selected = !selected;
        });
        print(selected);
      },
    );
  }
}
