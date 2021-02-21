import 'package:T_able/models/Event/event.dart';
import 'package:T_able/utils/DateformatingHelper.dart';
import 'package:flutter/material.dart';
import '../utils/vars_consts.dart';

class EventCard extends StatefulWidget {
  final Event event;
  EventCard(this.event);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
          icon: selected ? Icon(Icons.star,color: Colors.yellow,):Icon(Icons.star_border),
          onPressed: () {
                              if (selected) {
                                impEvents.remove(widget.event);
                              } else
                                impEvents.add(widget.event);
                              setState(() {
                                selected = !selected;
                              });
                            },
        ),
        title: Text(widget.event.title),
        subtitle: Text(widget.event.getStartDate),
        trailing: Text(date2time(widget.event.startTime).format(context)),
      ),
    );
  }
}
