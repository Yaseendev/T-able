import 'package:t_able/utils/vars_consts.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:bubble/bubble.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _showSendButton = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<String> _data = [];
  TextEditingController _queryController = TextEditingController();
  String msg = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor1,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(bottom: 25.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            children: [
              Expanded(
                              child: AnimatedList(
                    // key to call remove and insert from anywhere
                    key: _listKey,
                    initialItemCount: _data.length,
                    itemBuilder:
                        (BuildContext context, int index, Animation animation) {
                      return _buildItem(_data[index], animation, index);
                    }),
              ),
              SizedBox(
                height: 10.0,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        onChanged: (val) {
                          if (val == null || val == '') {
                            setState(() {
                              _showSendButton = false;
                              msg = '';
                            });
                            print('no val');
                          } else {
                            setState(() {
                              _showSendButton = true;
                            });
                            msg = val;
                            print(val);
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Chat with me :)',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),
                        controller: _queryController,
                        textInputAction: TextInputAction.send,
                         onSubmitted: (msg){
this._getResponse();
setState(() {
                          _showSendButton = false;
                          });
              },
                      ),
                    ),
                    if (_showSendButton)
                      MaterialButton(
                        onPressed: () {
                          this._getResponse();
                          setState(() {
                          _showSendButton = false;
                          });
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Icon(
                          Icons.send,
                          size: 25,
                        ),
                        padding: EdgeInsets.all(16),
                        shape: CircleBorder(),
                      )
                  ],
                ),
                //),
              ),
            ],
          ),
        ),
      )),
    );
  }
  http.Client _getClient(){
    return http.Client();
  }
void _getResponse(){
    if (msg.length>0){
      this._insertSingleItem(_queryController.text);
      var client = _getClient();
      try{
        client.post(BOT_URL, body: {"query" : _queryController.text},)
        ..then((response){
          Map<String, dynamic> data = jsonDecode(response.body);
          _insertSingleItem(data['response']+"<bot>");
});
      }catch(e){
        print("Failed -> $e");
      }finally{
        client.close();
        _queryController.clear();
      }
    }
  }
void _insertSingleItem(String message){
_data.add(message); 
    _listKey.currentState.insertItem(_data.length-1);
  }
  Widget _buildItem(String item, Animation animation,int index){
    bool mine = item.endsWith("<bot>");
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(padding: EdgeInsets.only(top: 10),
      child: Container(
        alignment: mine ?  Alignment.topLeft : Alignment.topRight,
child : Bubble(
        child: Text(item.replaceAll("<bot>", "")),
        color: mine ? Colors.blue : Colors.indigo,
        padding: BubbleEdges.all(10),
)),
    )
);
  }
}
