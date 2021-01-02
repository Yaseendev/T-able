import 'dart:io';

import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final String imagePath;
  ImageScreen(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Container(
            child: Image.file(
              File(
                imagePath,
              ),
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
           child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10.0),
),
                    child: Text('Extract Time Table'), onPressed: () {}),
                RaisedButton(child: Text('Extract appointment'),onPressed: () {},shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10.0),
),)
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
