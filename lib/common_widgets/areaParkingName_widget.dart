import 'package:ble_unlock/app/home/models/area.dart';
import 'package:ble_unlock/app/home/models/area_parking.dart';
import 'package:ble_unlock/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AreaParkingName {
  String aeraNameTxt = '';
  String parkingNameTxt = '';

  Widget areaName(BuildContext context, String areaId,
      {double fontSize = 0, bool isRich = false}) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<Area>(
        stream: database.areaStream(areaId: areaId),
        builder: (context, snapshot) {
          final area = snapshot.data;
          aeraNameTxt = area?.areaAbbreviationName ?? '';
          if (fontSize == 0) {
            if (!isRich) {
              return Text(aeraNameTxt);
            } else {
              return RichText(
                text:
                    TextSpan(style: TextStyle(color: Colors.black), children: [
                  TextSpan(text: aeraNameTxt),
                ]),
              );
            }
          } else {
            if (!isRich) {
              return Text(
                aeraNameTxt,
                style: TextStyle(fontSize: fontSize),
              );
            } else {
              return RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: fontSize, color: Colors.black),
                    children: [
                      TextSpan(text: aeraNameTxt),
                    ]),
              );
            }
          }
        });
  }

  Widget parkName(BuildContext context, String areaId, String parkId,
      {double fontSize = 0, bool isRich = false}) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<AreaParking>(
        stream: database.areaParkingStream(areaId: areaId, parkId: parkId),
        builder: (context, snapshot) {
          final parking = snapshot.data;
          parkingNameTxt = parking?.areaParkingAbbreviationName ?? '';
          if (fontSize == 0) {
            if (!isRich) {
              return Text(parkingNameTxt);
            } else {
              return RichText(
                text:
                    TextSpan(style: TextStyle(color: Colors.black), children: [
                  TextSpan(text: parkingNameTxt),
                ]),
              );
            }
          } else {
            if (!isRich) {
              return Text(
                parkingNameTxt,
                style: TextStyle(fontSize: fontSize),
              );
            } else {
              return RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: fontSize, color: Colors.black),
                    children: [
                      TextSpan(text: parkingNameTxt),
                    ]),
              );
            }
          }
        });
  }

  String getAreaPakingName() {
    return aeraNameTxt + parkingNameTxt;
  }
}
