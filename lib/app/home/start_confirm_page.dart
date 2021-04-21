import 'package:ble_unlock/app/home/models/entry.dart';
import 'package:ble_unlock/app/sign_in/sign_out.dart';
import 'package:ble_unlock/common_widgets/areaParkingName_widget.dart';
import 'package:ble_unlock/common_widgets/platform_exception_alert_dialog.dart';
import 'package:ble_unlock/landing_page.dart';
import 'package:ble_unlock/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StartConfirmPage extends StatelessWidget {
  // TODO:パスコードを追加する
  // 駐輪場ID
  final String areaDefaultValue;

  final String parkDefaultValue;
  // 駐輪機ID
  final String keyDefaultValue;
  const StartConfirmPage(
      {Key key,
      this.areaDefaultValue,
      this.parkDefaultValue,
      this.keyDefaultValue})
      : super(key: key);

  // 利用者の駐輪エントリー登録。登録完了後はダイアログを表示する。
  Future<void> _submit(BuildContext context) async {
    try {
      // databaseのインスタンス作成時に、useridは持たせている？
      final database = Provider.of<Database>(context);
      // 利用中かどうかのチェックを行うか？
      final entry = await database.getEntry();
      // print(entry.userId);
      if (entry != null) {
        // 既にエントリー済み
        // print('エントリー済！');
        // showDialog(
        //   context: context,
        //   child: CupertinoAlertDialog(
        //     title: Column(
        //       children: <Widget>[
        //         Text(
        //           "現在ご利用になれません。",
        //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        //         ),
        //         Icon(
        //           Icons.info,
        //           color: Colors.red,
        //         ),
        //       ],
        //     ),
        //     content: new Text("ご利用中の駐輪機を確認してください。"),
        //     actions: <Widget>[
        //       FlatButton(
        //         onPressed: () {
        //           Navigator.of(context).push(
        //             MaterialPageRoute(
        //               builder: (context) {
        //                 return LandingPage();
        //               },
        //             ),
        //           );
        //         },
        //         child: new Text("OK"),
        //       ),
        //     ],
        //   ),
        // );
        showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Column(
              children: <Widget>[
                Text(
                  "現在ご利用になれません。",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.info,
                  color: Colors.red,
                ),
              ],
            ),
            content: new Text("ご利用中の駐輪機を確認してください。"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return LandingPage();
                      },
                    ),
                  );
                },
                child: new Text("OK"),
              ),
            ],
          ),
        );
      } else {
        final entry = Entry(
          parkId: parkDefaultValue,
          keyId: keyDefaultValue,
          passCode: '',
        );
        // エントリーデータ登録
        await database.setEntry(entry);
        // showDialog(
        //   context: context,
        //   child: CupertinoAlertDialog(
        //     title: Column(
        //       children: <Widget>[
        //         Text(
        //           "ご利用ありがとうございます！",
        //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        //         ),
        //         Icon(
        //           Icons.favorite,
        //           color: Colors.red,
        //         ),
        //       ],
        //     ),
        //     content: new Text("利用を開始しました。"),
        //     actions: <Widget>[
        //       FlatButton(
        //         onPressed: () {
        //           Navigator.of(context).push(
        //             MaterialPageRoute(
        //               builder: (context) {
        //                 return LandingPage();
        //               },
        //             ),
        //           );
        //         },
        //         child: new Text("OK"),
        //       ),
        //     ],
        //   ),
        // );
        showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Column(
              children: <Widget>[
                Text(
                  "ご利用ありがとうございます！",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ],
            ),
            content: new Text("利用を開始しました。"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return LandingPage();
                      },
                    ),
                  );
                },
                child: new Text("OK"),
              ),
            ],
          ),
        );
      }
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final SignOutModule _signOutModule = SignOutModule();
    return Scaffold(
      appBar: AppBar(
        title: Text('利用開始'),
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
        body: Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.all(20.0),
          width: double.infinity,
          child: _buldContents(context),
        ),
      ),
    );
  }

  Widget _buldContents(BuildContext context) {
    final areaParkingName = AreaParkingName();

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(20.0),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              padding: EdgeInsets.only(
                left: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        children: [
                          TextSpan(text: '駐輪場No'),
                          TextSpan(
                            text: areaDefaultValue + " - " + parkDefaultValue,
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          ),
                        ]),
                  ),
                  Row(
                    children: [
                      areaParkingName.areaName(context, areaDefaultValue,
                          fontSize: 15),
                      SizedBox(width: 5),
                      areaParkingName.parkName(
                          context, areaDefaultValue, parkDefaultValue,
                          fontSize: 15),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: <Widget>[
                  Text(
                    '駐輪キーNo',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    keyDefaultValue,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              padding: EdgeInsets.only(
                left: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Text(
                        '利用開始時刻',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        '14:21',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              padding: EdgeInsets.only(
                left: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30),
                  Text(
                    '駐輪キーナンバーを間違えて自分以外のロックキーを',
                    style: TextStyle(fontSize: 12),
                  ),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 12, color: Colors.black),
                        children: [
                          TextSpan(text: '解錠してしまった場合の'),
                          TextSpan(
                            text: 'ご返金の対応は致しかねます。',
                            style: TextStyle(fontSize: 13, color: Colors.red),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            FlatButton(
              child: new Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 60.0,
              ),
              shape: new CircleBorder(),
              color: Colors.black,
              onPressed: () {
                // ここでエントリー登録の関数を呼び出すように修正する
                // FireStoreへの登録が正常に完了後、ダイアログを表示する。
                _submit(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
