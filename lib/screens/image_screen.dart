import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:t_able/screens/timeTable_screen.dart';

class ImageScreen extends StatelessWidget {
  final String imagePath;
  ImageScreen(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
              child: Center(
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
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text('Extract Time Table'),
                      onPressed: () async {
                        ProgressDialog pr = ProgressDialog(context);
                        pr.style(
                            message: 'Extracting Data...',
                            borderRadius: 10.0,
                            backgroundColor: Colors.white,
                            progressWidget: CircularProgressIndicator(),
                            elevation: 10.0,
                            insetAnimCurve: Curves.easeInOut,
                            progress: 0.0,
                            maxProgress: 100.0,
                            progressTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400),
                            messageTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 19.0,
                                fontWeight: FontWeight.w600));
                        Dio dio = Dio();
                        dio.options.headers['x-api-key'] =
                            'zsyCIG5fmEstCdWaINpcQl4ihWofFB9G5atNoYJs';

                        FormData formData = FormData.fromMap(
                            {'input': await MultipartFile.fromFile(imagePath)});
                        pr.show();
                         await dio
                            .post('https://trigger.extracttable.com',
                                data: formData)
                            .then((resVal) {
                          if (resVal.statusCode == 200 ||
                              resVal.statusCode == 202) {
                            print('done');
                            pr.hide().whenComplete(() {
                               print(resVal.data);
                              print(resVal.data.runtimeType);
                              print('ExtractTable Response: $resVal');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      TimeTableScreen(resVal.toString())));
                            });
                          } else {
                            pr.hide().whenComplete(() {
                              Platform.isIOS
                                  ? showCupertinoDialog(
                                      context: context,
                                      builder: (ctx) => CupertinoAlertDialog(
                                            title: Text('Network Error'),
                                            content:
                                                Text('The Server may be down'),
                                            actions: [
                                              FlatButton(
                                                  child: Text('Ok'),
                                                  onPressed: () =>
                                                      Navigator.pop(ctx))
                                            ],
                                          ))
                                  : showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                            title: Text('Network Error'),
                                            content:
                                                Text('The Server may be down'),
                                            actions: [
                                              FlatButton(
                                                  child: Text('Ok'),
                                                  onPressed: () =>
                                                      Navigator.pop(ctx))
                                            ],
                                          ));
                            });
                          }
                        }).catchError((e)=>print(e));
                        
                      }),
                  RaisedButton(
                    child: Text('Extract Appointment'),
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
      ),
    );
  }
}
