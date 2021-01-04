import 'dart:convert';
import 'dart:io';
import 'package:draw_kids/ImageCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_draw/flutter_draw.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'UIHelper.dart';
import 'package:path/path.dart' as p;
// if (Platform.isWindows || Platform.isLinux) {
import 'package:flutter_audio_desktop/flutter_audio_desktop.dart';
// }else{
import 'package:assets_audio_player/assets_audio_player.dart';
// }
import 'package:permission_handler/permission_handler.dart';

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
    loadMp3();

  }
  Future<void> loadMp3() async {
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the counter key. If it doesn't exist, return null.
    var imagePath = prefs.getString("back_image");
    final file=File(imagePath + "/music/2.mp3");
    file.exists().then((value)  {
        if (Platform.isWindows || Platform.isLinux) {
          // Start AudioPlayer and provide int for id.
          var audioPlayer = new AudioPlayer(id: 0);

          // Load audio file
          audioPlayer.load(file.path).then((value) =>
              audioPlayer.play());
        } else {
          final assetsAudioPlayer = AssetsAudioPlayer();

          assetsAudioPlayer.open(Audio(file.path),
              loopMode: LoopMode.playlist);
        }
      }
    );

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
              buildBackImageList(),
              _drawImage != null
                  ? Image.file(_drawImage, fit: BoxFit.fill)
                  : Container(),
              RaisedButton(
                onPressed: (){
                  _initImages(isClear: true);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text("change Directory"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _initImages({isClear=false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Try reading data from the counter key. If it doesn't exist, return null.
      var imagePath = isClear?"":prefs.getString("back_image")?? "";
      if (Platform.isAndroid) {
        if(!await  Permission.storage.request().isGranted){
            return;
        }
      }
      if (imagePath =="" || await Directory(imagePath).exists()==false) {
        imagePath = await FilesystemPicker.open(
          title: 'load from folder',
          context: context,
          rootDirectory: Platform.isAndroid?Directory('/sdcard'):await getApplicationDocumentsDirectory(),
          fsType: FilesystemType.folder,
          pickText: 'load images from this folder',
          folderIconColor: Colors.teal,
        );
        prefs.setString("back_image",imagePath);
      }
      RegExp exp = new RegExp(r"(jpe?g|png)",caseSensitive: false);
      final imagePaths =Directory(imagePath).listSync().asMap().values.map((e) => e.path).where((element) => (exp.hasMatch(p.extension(element)))).toList();

      setState(() {
        hotList = imagePaths;
      });
    } catch (er) {
      print(er);
    }
  }
  Future<List<String>> loadFromAssert() async {
    final manifestContent = await DefaultAssetBundle.of(context)
        .loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('asserts/'))
        .where((String key) => !key.contains('music'))
        .toList();
    return imagePaths;
  }

  Widget buildBackImageList() {
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
        file.writeAsBytesSync(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      }
    });
    // await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Future<void> getDrawing(img) async {
    setImageFile(File(img));
    // setImageFile(await getImageFileFromAssets(img));
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
