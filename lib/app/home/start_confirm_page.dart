import 'package:ble_unlock/app/sign_in/sign_out.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartConfirmPage extends StatelessWidget {
  final String keyDefaultValue;
  const StartConfirmPage({Key key, this.keyDefaultValue}) : super(key: key);

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
          // child: Text('${keyDefaultValue}'),
          child: _buldContents(context),
        ),
      ),
    );
  }

  Widget _buldContents(BuildContext context) {
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
                            text: '006',
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          ),
                        ]),
                  ),
                  Text(
                    '東京都〇〇駐輪場',
                    style: TextStyle(fontSize: 15),
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
                    '022',
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
                  SizedBox(height: 30),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 110),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          children: [
                            TextSpan(
                              text: '100',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '円'),
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: 30,
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
                showDialog(
                    context: context,
                    // return object of type AlertDialog
                    child: new CupertinoAlertDialog(
                      title: new Column(
                        children: <Widget>[
                          new Text("CupertinoAlertDialog"),
                          new Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      content: new Text("利用開始しました！"),
                      actions: <Widget>[
                        new FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: new Text("OK"))
                      ],
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
