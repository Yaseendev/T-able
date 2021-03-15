import 'package:t_able/utils/vars_consts.dart';
import 'package:t_able/widgets/action_button.dart';
import 'package:t_able/widgets/eventsList.dart';
import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: CustomActionButton(),
        backgroundColor: primaryColor1,
        appBar: AppBar(
          //backgroundColor: Colors.blueAccent,
          title: TabBar(
            tabs: [
              Tab(text: 'Events'),
              Tab(text: 'Important Events'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            EventsListWidget(),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}
