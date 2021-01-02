

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_draw/flutter_draw.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: DrawExample(),
    );
  }
}

class DrawExample extends StatefulWidget {
  @override
  _DrawExampleState createState() => _DrawExampleState();
}

class _DrawExampleState extends State<DrawExample> {

  File _drawImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _drawImage != null ? Image.file(_drawImage) : Container(),
              RaisedButton(
                onPressed: (){
                  getDrawing();
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text("Draw"),
              )
            ],),
        ),
      ),
    );
  }

  Future<void> getDrawing()  {
    final getDraw =   Navigator.push(context, MaterialPageRoute(
        builder: (context){
          return HomePage();
        }
    )).then((getDraw){
      if(getDraw != null){
        setState(() {
          _drawImage =  getDraw;
        });
      }
    }).catchError((er){print(er);});

  }
}
