import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'Item.dart';
import 'UIHelper.dart';
const Color lime = Color.fromRGBO(240, 203, 148, 1);
const Color orange = Color.fromRGBO(255, 158, 107, 1);
const Color primaryLight = Color.fromRGBO(240, 234, 248, 1);
const Color imgBG = Color.fromRGBO(230, 230, 254, 1);
const titleStyle = TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);

class UpComingEventCard extends StatelessWidget {
  final String event;
  final Function onTap;
  UpComingEventCard(this.event, {this.onTap});


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: <Widget>[
          Expanded(child: buildImage()),
          UIHelper.verticalSpace(24),
          buildEventInfo(context),
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
            tag: event,
            child: Image(image: AssetImage(event),fit: BoxFit.fitHeight)
          ),

      ),
    );
  }

  Widget buildEventInfo(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: <Widget>[
//                Text("${DateTimeUtils.getMonth(event.eventDate)}", style: monthStyle),
//                Text("${DateTimeUtils.getDayOfMonth(event.eventDate)}", style: titleStyle),
//              ],
//            ),
          ),
          UIHelper.horizontalSpace(16),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(event, style: titleStyle),
              UIHelper.verticalSpace(4),
//              Row(
//                children: <Widget>[
//                  Icon(Icons.location_on, size: 16, color: Theme.of(context).primaryColor),
//                  UIHelper.horizontalSpace(4),
//                  Text(event.location.toUpperCase(), style: subtitleStyle),
//                ],
//              ),
            ],
          ),
        ],
      ),
    );
  }
}
