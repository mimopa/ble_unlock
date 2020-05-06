import 'dart:async';

import 'package:ble_unlock/app/home/payoff_comfirm_page.dart';
import 'package:ble_unlock/app/sign_in/sign_out.dart';
import 'package:ble_unlock/common_widgets/platform_alert_dialog.dart';
import 'package:ble_unlock/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

class EndConfirmPage extends StatefulWidget {
  @override
  _EndConfirmPageState createState() => _EndConfirmPageState();
}

class _EndConfirmPageState extends State<EndConfirmPage> {
  String _defaultValue = '0';
  List<Map<String, String>> _keyIds = [];
  // String openKey;
  BluetoothDevice _connectedDevice;
  String _keyId;
  String _openKey;

  StreamController<List<Map<String, String>>> _controller =
      StreamController<List<Map<String, String>>>.broadcast();

  void _deviceScan() {
    // FlutterBlue.instance.stopScan();
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
  }

  void _handleKeyChange(String newKeyValue) {
    setState(() {
      // _text = newValue;
      _defaultValue = newKeyValue;
    });
  }

  // BLEデバイスを選択した時に実行される。ここで駐輪機Noと、解錠コードを取得し、決済画面以降に引き継ぐ。
  void _changeDevices(
      BluetoothDevice device, List<Map<String, String>> keyIds) {
    setState(() {
      _connectedDevice = device;
      // _keyId = keyId;
      keyIds.asMap().forEach((index, keymap) {
        if (keymap.values.toList().indexOf(device.id.toString()) >= 0) {
          if (device.id.toString() == keymap['bd_id']) {
            // print('Stream!');
            // print(r.device.id);
            // print(keymap['bd_id']);
            // print(keymap['key_id']);
            // 駐輪機No
            _keyId = keymap['key_id'];
            // 解錠コード
            _openKey = keymap['open_key'];
          }
        }
      });
      // print('DeviceChenged');
      // print(_keyId);
      // print(_openKey);
    });
  }

  @override
  void initState() {
    //アプリ起動時に一度だけ実行される
    _deviceScan();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _setKeys(Database database) async {
    // データベース（駐輪機マスタ）から、設定情報を取得する。
    // BDIDと駐輪機IDのリストを取得しておく？
    _keyIds = await _getKeys(database, '001');
    // print('_setKeys');
    // print(_keyIds);
    _controller.add(_keyIds);
  }

  @override
  Widget build(BuildContext context) {
    final SignOutModule _signOutModule = SignOutModule();
    // ここで実行すると描画のたびに流れるので改善が必要！！
    final database = Provider.of<Database>(context);
    _setKeys(database);
    // print('build!');
    // print(_keyIds.isEmpty);

    return Scaffold(
      appBar: AppBar(
        title: const Text('利用終了'),
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
      body: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: _buldContents(
                  context,
                  _deviceScan,
                  _handleKeyChange,
                  _connectedDevice,
                  _changeDevices,
                  _keyIds,
                  _keyId,
                  _openKey,
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: new Center(
                    child: new Text(
                      "loading.. wait...",
                      style: new TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}

Future<List<Map<String, String>>> _getKeys(
  Database database,
  String parkId,
) async {
  List<Map<String, String>> keys =
      await database.getParkings(parkId).then((values) {
    List<Map<String, String>> _keyIds = [];
    // print('values');
    // print(values);
    values.forEach((value) {
      Map<String, String> _keymap = {};
      _keymap['bd_id'] = value.bdId;
      _keymap['key_id'] = value.keyId;
      _keymap['open_key'] = value.openKey;
      _keyIds.add(_keymap);
    });
    return _keyIds;
  });
  return keys;
}

Widget _buldContents(
  BuildContext context,
  Function deviceScan,
  Function handleKeyChange,
  BluetoothDevice connectedDevice,
  Function changeDevices,
  List<Map<String, String>> keyIds,
  String selectedKey,
  String openKey,
  // StreamController<List<Map<String, String>>> controller,
) {
  String keyName = '';
  List keyList = [];
  List<String> keyDeviceList = [];
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
                SizedBox(width: 10),
                Container(
                  width: 100,
                  child: StreamBuilder<BluetoothState>(
                    stream: FlutterBlue.instance.state,
                    initialData: BluetoothState.unknown,
                    builder: (c, snapshot) {
                      final state = snapshot.data;
                      if (state == BluetoothState.on) {
                        return Center(
                          // BluetoothのスキャンデータをDropdownボタンで表現する
                          child: StreamBuilder<List<ScanResult>>(
                            stream: FlutterBlue.instance.scanResults,
                            initialData: [],
                            builder: (c, snapshot) =>
                                DropdownButton<BluetoothDevice>(
                              value: null,
                              onChanged: (BluetoothDevice device) {
                                changeDevices(device, keyIds);
                              },
                              // このmapのあとに、device.idから、駐輪機Noを取得する処理を行う。
                              items: snapshot.data
                                  .map<DropdownMenuItem<BluetoothDevice>>((r) {
                                    // keyName = '';
                                    // print('絞り込み');
                                    // print(r.device.id);
                                    keyIds.asMap().forEach((index, keymap) {
                                      if (keymap.values.toList().indexOf(
                                              r.device.id.toString()) >=
                                          0) {
                                        // if (r.device.id.toString() ==
                                        //     keymap['bd_id']) {
                                        //   print('Stream!');
                                        //   print(r.device.id);
                                        //   print(r.device.name);
                                        //   print(keymap['bd_id']);
                                        // }
                                        keyName = keymap['key_id'];
                                        // openKey = keymap['open_key'];
                                        keyList.add(keyName);
                                        keyDeviceList
                                            .add(r.device.id.toString());
                                      }
                                      // return keyDeviceList.toList();
                                    });
                                    if (r.device.name == 'Renesas-BLE') {
                                      print(r.device.id.id);
                                      print(r.device.name);
                                    }
                                    return DropdownMenuItem<BluetoothDevice>(
                                      value: r.device,
                                      child: Text(
                                        // r.device.name,
                                        keyName,
                                        style: TextStyle(
                                          backgroundColor:
                                              Theme.of(context).canvasColor,
                                          fontSize: 20.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  })
                                  // ToDo: 駐輪機Noを持つ要素のみをDropdownアイテムとして表示する
                                  .where(
                                    (device) {
                                      return keyDeviceList
                                              .toSet()
                                              .toList()
                                              .indexOf(
                                                  device.value.id.toString()) >=
                                          0;
                                    },
                                  )
                                  .toSet()
                                  .toList(),
                            ),
                          ),
                        );
                      }
                      // return Text('OFF');
                      return DropdownButton<String>(
                        value: null,
                        onChanged: handleKeyChange,
                        items: ['0', '1', '2']
                            .map<DropdownMenuItem<String>>((String value) {
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
                      );
                    },
                  ),
                ),
                RaisedButton(
                  child: Text(
                    "更新",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(2.0),
                  ),
                  onPressed: deviceScan,
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
                        TextSpan(text: '解錠してまった場合の'),
                        TextSpan(
                          text: '返金の対応は致しかねます。',
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
            onPressed: () async {
              if (connectedDevice == null) {
                await PlatformAlertDialog(
                  title: '確認！',
                  content: '解錠する駐輪機Noを選択してください。',
                  defaultActionText: 'OK',
                ).show(context);
              } else {
                // 決済画面へ
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return PayOffComfirmPage(
                        device: connectedDevice,
                        openKey: openKey,
                        keyId: selectedKey,
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    ),
  );
}
