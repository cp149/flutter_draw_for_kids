import 'dart:convert';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:draw_kids/ImageCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_desktop/flutter_audio_desktop.dart';
import 'package:flutter_draw/flutter_draw.dart';
import 'package:path_provider/path_provider.dart';

import 'UIHelper.dart';

const headerStyle =
    TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold);

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
  List<String> hotList;

  @override
  void initState() {
    super.initState();
    if( Platform.isWindows || Platform.isLinux){
      // Start AudioPlayer and provide int for id.
      var audioPlayer = new AudioPlayer(id: 0);

// Load audio file
      audioPlayer.load("asserts/music/2.mp3").then((value) => audioPlayer.play());

    }else {
      final assetsAudioPlayer = AssetsAudioPlayer();

      assetsAudioPlayer.open(Audio("asserts/music/2.mp3"),
          loopMode: LoopMode.playlist);
    }
  }

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
              buildUpComingEventList(),
              _drawImage != null
                  ? Image.file(_drawImage, fit: BoxFit.fill)
                  : Container(),
              // RaisedButton(
              //   onPressed: (){
              //     getDrawing();
              //     // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              //   },
              //   child: Text("Draw"),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUpComingEventList() {
    Future _initImages() async {
      // >> To get paths you need these 2 lines
      try {
        final manifestContent = await DefaultAssetBundle.of(context)
            .loadString('AssetManifest.json');

        final Map<String, dynamic> manifestMap = json.decode(manifestContent);
        // >> To get paths you need these 2 lines

        final imagePaths = manifestMap.keys
            .where((String key) => key.contains('asserts/'))
            //.where((String key) => key.contains('.jpg'))
            .toList();
        setState(() {
          hotList = imagePaths;
        });
      } catch (er) {
        print(er);
      }
    }

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initImages(),
      builder: (context, snapshot) {
        // Check for errors

        // Once complete, show your application
        if (hotList != null) {
          return Container(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Practising",
                    style: headerStyle.copyWith(color: Colors.white)),
                UIHelper.verticalSpace(16),
                Container(
                  height: 250,
                  child: ListView.builder(
                    itemCount: hotList.length,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final event = hotList[index];
                      return ImageCard(event,
                          onTap: () => getDrawing(event));
                    },
                  ),
                ),
              ],
            ),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }

  Future<File> getImageFileFromAssets(String path) async {

    final byteData = await rootBundle.load('$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    file.create(recursive: true).then((val) async {
      if (await val.exists()) {
        await file.writeAsBytesSync(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      }
    });
    // await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Future<void> getDrawing(img) async {
    setImageFile(await getImageFileFromAssets(img));
    final getDraw =
        Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    })).then((getDraw) {
      if (getDraw != null) {
        setState(() {
          _drawImage = getDraw;
        });
      }
    }).catchError((er) {
      print(er);
    });
  }
}
