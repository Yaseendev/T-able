import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';

class SavedEventsScreen extends StatelessWidget {
  final events;
  SavedEventsScreen(this.events);
  @override
  Widget build(BuildContext context) {
    var keys = events.values;
    for(var e in keys)
    print(e.title);

    return Scaffold(
      floatingActionButton: UnicornDialer(
      parentHeroTag: "btn1",
      parentButton: Icon(Icons.add),
      )
      ,
      body: ListView.builder(
          itemCount: events.length,
          itemBuilder: (_, int position) {
            return Card(
              elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                child:  Text("${events.get(position).title}"),
              ),
              title: new Text("Starts : ${events.get(position).startTime}"),
              subtitle: new Text("Ends : ${events.get(position).endTime}"),
            ),
            );
          })
    );
  }
}
