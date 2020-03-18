import 'package:ble_unlock/app/home/start_confirm_page.dart';
import 'package:ble_unlock/common_widgets/platform_alert_dialog.dart';
import 'package:ble_unlock/landing_page.dart';
import 'package:ble_unlock/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class EndConfirmPage extends StatefulWidget {
  @override
  _EndConfirmPageState createState() => _EndConfirmPageState();
}

class _EndConfirmPageState extends State<EndConfirmPage> {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return LandingPage();
          },
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  // 駐輪場選択
  String _defaultValue = '001';
  final List<String> _list = <String>['001', '002', '003', '004'];
  String _text = '';
  // 駐輪機選択
  String _keyDefaultValue = '001';
  final List<String> _keyList = <String>['001', '002', '003', '004'];

  // パスコード
  String currentPassCode = "";

  void _handleChange(String newValue) {
    setState(() {
      _text = newValue;
      _defaultValue = newValue;
    });
  }

  void _handleKeyChange(String newKeyValue) {
    setState(() {
      // _text = newValue;
      _keyDefaultValue = newKeyValue;
    });
  }

  void _passCodeChange(String newPassCode) {
    setState(() {
      currentPassCode = newPassCode;
      print(currentPassCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('決済'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: Scaffold(
        backgroundColor: Colors.white,
        body: _buldContents(
            context,
            _defaultValue,
            _list,
            _keyDefaultValue,
            _keyList,
            currentPassCode,
            _handleChange,
            _handleKeyChange,
            _passCodeChange),
      ),
    );
  }
}

Widget _buldContents(
    BuildContext context,
    String defaultValue,
    List<String> list,
    String keyDefaultValue,
    List<String> keyList,
    String currentPassCode,
    Function onChanged,
    Function handleKeyChange,
    Function passCodeChanged) {
  return Container(
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
              SizedBox(height: 30),
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
                height: 30,
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
              SizedBox(width: 30),
              Container(
                width: 100,
                child: DropdownButton<String>(
                  value: keyDefaultValue,
                  onChanged: onChanged,
                  items: keyList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          backgroundColor: Theme.of(context).canvasColor,
                          fontSize: 19.0,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
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
            left: 25.0,
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
                  SizedBox(
                    width: 80,
                  ),
                  Text(
                    '利用時間',
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
                    width: 105,
                  ),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        children: [
                          TextSpan(
                            text: '3',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '時間'),
                          TextSpan(
                            text: '12',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '分'),
                        ]),
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
            left: 2.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              Text(
                '駐輪キーナンバーを間違えて自分以外のロックキーを解錠して',
                style: TextStyle(fontSize: 12),
              ),
              RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    children: [
                      TextSpan(text: 'しまった場合の'),
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
        SizedBox(height: 100),
        FlatButton(
          child: new Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 60.0,
          ),
          shape: new CircleBorder(),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return StartConfirmPage(
                    keyDefaultValue: keyDefaultValue,
                  );
                },
              ),
            );
          },
        ),
      ],
    ),
  );
}
