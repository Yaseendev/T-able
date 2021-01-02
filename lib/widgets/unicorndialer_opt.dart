import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';

Widget profileOption({IconData iconData, Function onPressed, String tag}) {
    return UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: tag,
      backgroundColor: Colors.grey[500],
      mini: true,
      child: Icon(iconData),
      onPressed: onPressed,
    )
    );
  }