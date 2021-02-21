import 'package:T_able/widgets/event_card.dart';
import 'package:flutter/material.dart';
import '../utils/vars_consts.dart';

class EventsListWidget extends StatefulWidget {
  @override
  _EventsListWidgetState createState() => _EventsListWidgetState();
}

class _EventsListWidgetState extends State<EventsListWidget> {
  //var eventsVals = events.toMap().values.toList().reversed;
  //var revEvents ;
  //TODO: Implement reversing order of events list

  @override
  Widget build(BuildContext context) {
    //revEvents=eventsVals.reversed;
    return Container(
        child: events.length > 0
            ? ListView.builder(
                itemCount: events.length,
                itemBuilder: (BuildContext context, int position) {
                  return Dismissible(
                    onDismissed: (direction) {
                      setState(() {
                        events.get(position).delete();
                      });
                    },
                    secondaryBackground: Container(
                      color: Colors.red,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[  
                            Icon(Icons.delete,color: Colors.white),
                            SizedBox(width: 5.0,),
                           Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                          ],
                          ),
                      ),
                    ),
                    background: Container(),
                    child: EventCard(events.get(position)),
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                  );
                })
            : Center(
                child: Text('No Events yet'),
              ));
  }
}
