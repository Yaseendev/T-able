import 'package:flutter/material.dart';

String selectedRep = 'Days';
DropdownButton<String> dropdownmenu(StateSetter setStat) {
  List<DropdownMenuItem<String>> dropdownItems = [
    DropdownMenuItem(
      child: Text('Days'),
      value: 'Days',
    ),
    DropdownMenuItem(
      child: Text('Weeks'),
      value: 'Weeks',
    ),
    DropdownMenuItem(
      child: Text('Years'),
      value: 'Years',
    ),
  ];
  return DropdownButton<String>(
    value: selectedRep,
    items: dropdownItems,
    onChanged: (value) {
      setStat(() {
        selectedRep = value;
      });
    },
  );
}
