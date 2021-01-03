import 'package:flutter/material.dart';
const Color lime = Color.fromRGBO(240, 203, 148, 1);
const Color orange = Color.fromRGBO(255, 158, 107, 1);
const Color primaryLight = Color.fromRGBO(240, 234, 248, 1);
const Color imgBG = Color.fromRGBO(230, 230, 254, 1);
const titleStyle = TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);

class ImageCard extends StatelessWidget {
  final String imageInfo;
  final Function onTap;

  ImageCard(this.imageInfo, {this.onTap});


  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: <Widget>[
          Expanded(child: buildImage()),
          // UIHelper.verticalSpace(24),
          // buildEventInfo(context),
        ],
      ),
    );
  }

  Widget buildImage() {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),

        child: Hero(
            tag: imageInfo,
            child: Image(image: AssetImage(imageInfo), fit: BoxFit.fitHeight)
        ),

      ),
    );
  }

}
