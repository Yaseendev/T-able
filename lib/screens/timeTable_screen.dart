import 'dart:convert';
import 'package:flutter/material.dart';

class TimeTableScreen extends StatefulWidget {
  final jsonRes;
  TimeTableScreen(this.jsonRes);
  @override
  _TimeTableScreenState createState() => _TimeTableScreenState();
}


 
class _TimeTableScreenState extends State<TimeTableScreen> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
                  children: [SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  showBottomBorder: true,
                  columns: extractColumns(),
                  rows: extractRows())),
                  Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text('Add to calendars'),
                      onPressed: ()  {
                      }),
                  RaisedButton(
                    child: Text('Create a personal Time Table'),
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  )
                ],
              ),
            ),
        ]),
      ),
    );
  }

  List<DataRow> extractRows() {
    final res = jsonDecode(widget.jsonRes);
    List<DataRow> temp = [];
    for (int i = 1; i < res['Tables'][0]['TableJson'].length; i++) {
      var row = res['Tables'][0]['TableJson']['$i'].values;
      var listRow = row.toList();
      List<DataCell> cells = [];
      for (String str in listRow)
        cells.add(DataCell(InkWell(onTap: () => print(str), child: Text(str))));
      temp.add(DataRow(cells: cells));
    }
    return temp;
  }

  List<DataColumn> extractColumns() {
    final res = jsonDecode(widget.jsonRes);
    var row = res['Tables'][0]['TableJson']['0'].values;
    var listRow = row.toList();
    List<DataColumn> temp = [];
    for (String str in listRow) temp.add(DataColumn(label: Text(str)));
    return temp;
  }
}
