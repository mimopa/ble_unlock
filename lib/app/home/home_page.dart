import 'package:ble_unlock/app/home/start_confirm_page.dart';
import 'package:ble_unlock/app/sign_in/sign_out.dart';
import 'package:ble_unlock/services/database.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 駐輪場選択:park_id
  String _parkDefaultValue = '001';
  final List<String> _list = <String>['001', '002', '003', '004'];
  // 駐輪機選択:key_id
  String _keyDefaultValue = '001';
  final List<String> _keyList = <String>['001', '002', '003', '004'];

  // パスコード
  String currentPassCode = "";

  // パスコード確認
  String currentConfirmPassCode = "";

  void _handleChange(String newValue) {
    setState(() {
      _parkDefaultValue = newValue;
    });
  }

  void _handleKeyChange(String newKeyValue) {
    setState(() {
      _keyDefaultValue = newKeyValue;
    });
  }

  void _passCodeChange(String newPassCode) {
    setState(() {
      currentPassCode = newPassCode;
      print(currentPassCode);
    });
  }

  // パスコードの確認
  void _passCodeConfirmChange(String newPassCode) {
    setState(() {
      currentConfirmPassCode = newPassCode;
      print(currentConfirmPassCode);
    });
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
        body: _buldContents(
            context,
            _parkDefaultValue,
            _list,
            _keyDefaultValue,
            _keyList,
            currentPassCode,
            _handleChange,
            _handleKeyChange,
            _passCodeChange,
            _passCodeConfirmChange),
      ),
    );
  }
}

Widget _buldContents(
  BuildContext context,
  String parkDefaultValue,
  List<String> list,
  String keyDefaultValue,
  List<String> keyList,
  String currentPassCode,
  Function onChanged,
  Function handleKeyChange,
  Function passCodeChange,
  Function passCodeConfirmChange,
) {
  final database = Provider.of<Database>(context);
  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(25.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Text(
            '駐輪キー情報入力',
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
                DropdownButton<String>(
                  value: parkDefaultValue,
                  onChanged: onChanged,
                  items: list.map<DropdownMenuItem<String>>((String value) {
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
                SizedBox(width: 10),
                Text('ー'),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: parkDefaultValue,
                  onChanged: onChanged,
                  items: list.map<DropdownMenuItem<String>>((String value) {
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
              ],
            ),
          ),
          Text('東京都〇〇駐輪場'),
          Text(
            '※駐輪場名が異なる場合はお手数ですが、正しい駐輪場番号を\nご入力ください。',
            style: TextStyle(fontSize: 10.0),
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
                    onChanged: handleKeyChange,
                    items:
                        keyList.map<DropdownMenuItem<String>>((String value) {
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
                  SizedBox(width: 155),
                  SizedBox(
                    width: 55,
                    height: 25,
                    child: RaisedButton(
                      child: Text(
                        "任意",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 80),
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
                  onChanged: (value) => passCodeChange(value),
                )),
          ]),
          Text(
            '※四文字以上の英数字でご入力ください。',
            style: TextStyle(fontSize: 10.0),
          ),
          Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: <Widget>[
                  SizedBox(height: 35),
                  Text(
                    '確認',
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
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 80),
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
                  onChanged: (value) => passCodeConfirmChange(value),
                )),
          ]),
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
                    return Provider<Database>.value(
                      value: database,
                      child: StartConfirmPage(
                        parkDefaultValue: parkDefaultValue,
                        keyDefaultValue: keyDefaultValue,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
