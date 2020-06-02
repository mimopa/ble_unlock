import 'package:ble_unlock/app/home/end_confirm_page.dart';
import 'package:ble_unlock/app/sign_in/sign_out.dart';
import 'package:ble_unlock/common_widgets/areaParkingName_widget.dart';
import 'package:ble_unlock/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import 'models/area.dart';
import 'models/area_parking.dart';

class EndPage extends StatefulWidget {
  @override
  _EndPageState createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  // 地域選択:area_id
  String _areaDefaultValue = '001';

  // 駐輪場選択:park_id
  String _parkDefaultValue = '001';

  void _handleAreaChange(String value) {
    setState(() {
      _areaDefaultValue = value;
    });
  }

  void _handleParkChange(String value) {
    setState(() {
      _parkDefaultValue = value;
    });
  }

  // パスコード
  String _currentPassCode = "";

  void _passCodeChange(String newPassCode) {
    setState(() {
      _currentPassCode = newPassCode;
    });
  }

  @override
  void initState() {
    super.initState();
    _areaDefaultValue = '001';
    _parkDefaultValue = '001';
  }

  @override
  Widget build(BuildContext context) {
    final SignOutModule _signOutModule = SignOutModule();

    return Scaffold(
      appBar: AppBar(
        title: Text('利用終了'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _signOutModule.confirmSignOut(context),
          ),
        ],
      ),
      body: Scaffold(
        backgroundColor: Colors.white,
        body: _buldContents(
          context,
          _areaDefaultValue,
          _parkDefaultValue,
          _handleAreaChange,
          _handleParkChange,
          _currentPassCode,
          _passCodeChange,
        ),
      ),
    );
  }
}

Widget _buldContents(
  BuildContext context,
  String areaDefaultValue,
  String parkDefaultValue,
  Function handleAreaChange,
  Function handleParkChange,
  String currentPassCode,
  Function passCodeChanged,
) {
  final database = Provider.of<Database>(context);
  final areaParkingName = AreaParkingName();
  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(20.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Text(
            '駐輪場料金確認',
            style: TextStyle(
              fontSize: 19.0,
              color: Colors.black,
            ),
          ),
          Divider(
            color: Colors.black,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: <Widget>[
                Text(
                  '駐輪場No',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(width: 30),
                // 地域選択：Area
                // StreamBuilderにして、Firestoreからareaを取得するように変更する。
                StreamBuilder<List<Area>>(
                  stream: database.areasStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Loading');
                    } else {
                      return DropdownButton<String>(
                        value: areaDefaultValue,
                        onChanged: handleAreaChange,
                        items: snapshot.data.map<DropdownMenuItem<String>>((r) {
                          return DropdownMenuItem<String>(
                            value: r.id,
                            child: Text(
                              r.id,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
                SizedBox(width: 10),
                Text('ー'),
                SizedBox(width: 10),
                StreamBuilder<List<AreaParking>>(
                  stream: database.areaParkingsStream(areaId: areaDefaultValue),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Loading');
                    } else {
                      return DropdownButton<String>(
                        value: parkDefaultValue,
                        onChanged: handleParkChange,
                        items: snapshot.data.map<DropdownMenuItem<String>>((r) {
                          return DropdownMenuItem<String>(
                            value: r.id,
                            child: Text(
                              r.id,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              areaParkingName.areaName(context, areaDefaultValue),
              SizedBox(width: 5),
              areaParkingName.parkName(
                  context, areaDefaultValue, parkDefaultValue),
            ],
          ),
          Text(
            '※駐輪場名が異なる場合はお手数ですが、正しい駐輪場番号を\nご入力ください。',
            style: TextStyle(fontSize: 10.0),
          ),
          SizedBox(height: 20),
          Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'パスコード',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 80),
                child: PinCodeTextField(
                  length: 4,
                  obsecureText: false,
                  animationType: AnimationType.fade,
                  shape: PinCodeFieldShape.box,
                  animationDuration: Duration(milliseconds: 100),
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 40,
                  fieldWidth: 30,
                  inactiveColor: Colors.grey,
                  onChanged: (value) => passCodeChanged(value),
                )),
          ]),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[400],
            ),
            padding: EdgeInsets.only(
              left: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  '自身の利用状況の確認、決済画面への移動は',
                  style: TextStyle(fontSize: 15),
                ),
                RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      children: [
                        TextSpan(text: '設定した'),
                        TextSpan(
                          text: '四桁のパスコードによる認証',
                          style: TextStyle(color: Colors.red),
                        ),
                        TextSpan(text: 'が必要'),
                      ]),
                ),
                Text(
                  'です。',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 45.0),
                  child: SizedBox(
                    width: 210,
                    height: 40,
                    child: RaisedButton(
                      child: Text(
                        "パスコードの確認",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(2.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return Provider<Database>.value(
                                value: database,
                                child: EndConfirmPage(
                                  areaDefaultValue: areaDefaultValue,
                                  parkDefaultValue: parkDefaultValue,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 210,
            height: 40,
            child: RaisedButton(
              child: Text(
                "前のページに戻る",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(2.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    ),
  );
}
