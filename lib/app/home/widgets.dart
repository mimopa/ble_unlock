import 'package:ble_unlock/common_widgets/platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  // 与えられたメソッドをコールバックする
  final VoidCallback onTap;

  // リスト表示するデバイス一覧を構築している（ここはタイトル表記を振り分けるだけ）
  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.id.id,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            result.rssi.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.caption),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  // デバイスリストに表示されるリスト
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: _buildTitle(context),
      // leading: Text(result.rssi.toString()),
      leading: Text(result.device.name.toString()),
      trailing: RaisedButton(
        child: Text('CONNECT'),
        color: Colors.black,
        textColor: Colors.white,
        onPressed: (result.advertisementData.connectable) ? onTap : null,
      ),
      children: <Widget>[
        _buildAdvRow(
            context, 'Complete Local Name', result.advertisementData.localName),
        _buildAdvRow(context, 'Tx Power Level',
            '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
        _buildAdvRow(
            context,
            'Manufacturer Data',
            getNiceManufacturerData(
                    result.advertisementData.manufacturerData) ??
                'N/A'),
        _buildAdvRow(
            context,
            'Service UUIDs',
            (result.advertisementData.serviceUuids.isNotEmpty)
                ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
                : 'N/A'),
        _buildAdvRow(context, 'Service Data',
            getNiceServiceData(result.advertisementData.serviceData) ?? 'N/A'),
      ],
    );
  }
}

class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile({Key key, this.service, this.characteristicTiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characteristicTiles.length > 0) {
      return ExpansionTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Service'),
            Text(service.uuid.toString(),
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(color: Theme.of(context).textTheme.caption.color))
          ],
        ),
        children: characteristicTiles,
      );
    } else {
      return ListTile(
        title: Text('Service'),
        subtitle: Text('0x${service.deviceId.toString()}'),
      );
    }
  }
}

// Service配下に表示されるCharacteristicTileのWidgetを定義している
class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;
  final VoidCallback onNotificationPressed;
  final String openKey;

  const CharacteristicTile({
    Key key,
    this.characteristic,
    this.descriptorTiles,
    this.onReadPressed,
    this.onWritePressed,
    this.onNotificationPressed,
    this.openKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      // デバイスとの送受信データ（変更があれば反映される）
      // 解錠完了通知がきた場合、こちらでポップアップ画面を表示させたいが、
      // 状態を管理（監視）したい場合は、どうしたらよいか？
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (c, snapshot) {
        final value = snapshot.data;
        if (snapshot.data.length > 0) {
          if (ascii.decode(value.toList()).toString() == 'U') {
            print('解錠したよ！');
          }
        }
        return ExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Characteristic'),
                Text(
                    '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
                    style: Theme.of(context).textTheme.body1.copyWith(
                        color: Theme.of(context).textTheme.caption.color)),
                Text((ascii.decode(value.toList()).toString() == 'U')
                    ? '解錠したよ！'
                    : ''),
              ],
            ),
            // デバイスからの受信データがここに表示される。asciiをデコードして文字列表示
            subtitle: Text(ascii.decode(value.toList()).toString()),
            contentPadding: EdgeInsets.all(0.0),
          ),
          // Listの後ろ
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Read用のボタン
              IconButton(
                icon: Icon(
                  Icons.file_download,
                  color: Theme.of(context).iconTheme.color.withRed(10),
                ),
                onPressed: onReadPressed,
              ),
              // 書き込み用のボタン
              IconButton(
                icon: Icon(Icons.file_upload,
                    color: Theme.of(context).iconTheme.color.withRed(10)),
                // onPressed: onWritePressed,
                onPressed: () async {
                  const AsciiCodec ascii = AsciiCodec();

                  List<int> writeData = [];
                  // 解錠コードをここで作成して送る！
                  // var encoded = ascii.encode("AQ");
                  var encoded = ascii.encode(openKey);
                  print(encoded);
                  encoded.asMap().forEach((index, value) {
                    print('0x${value.toRadixString(16)}, $index');
                    // writeData[index] =
                    //     int.parse('0x${value.toRadixString(16)}');
                    writeData.add(int.parse('0x${value.toRadixString(16)}'));
                  });

                  print(writeData);
                  // print(openKey);
                  await characteristic.write(writeData, withoutResponse: true);
                },
              ),
              // 更新（Notify用のボタン）
              IconButton(
                icon: Icon(
                    characteristic.isNotifying
                        ? Icons.sync_disabled
                        : Icons.sync,
                    color: Theme.of(context).iconTheme.color.withRed(10)),
                onPressed: onNotificationPressed,
              )
            ],
          ),
          // descriptorは不要かも
          // children: descriptorTiles,
        );
      },
    );
  }
}

class DescriptorTile extends StatelessWidget {
  final BluetoothDescriptor descriptor;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;

  const DescriptorTile(
      {Key key, this.descriptor, this.onReadPressed, this.onWritePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Descriptor'),
          Text('0x${descriptor.uuid.toString().toUpperCase().substring(4, 8)}',
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: Theme.of(context).textTheme.caption.color))
        ],
      ),
      subtitle: StreamBuilder<List<int>>(
        stream: descriptor.value,
        initialData: descriptor.lastValue,
        builder: (c, snapshot) => Text(snapshot.data.toString()),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_download,
              color: Theme.of(context).iconTheme.color.withRed(10),
            ),
            onPressed: onReadPressed,
          ),
          IconButton(
            icon: Icon(
              Icons.file_upload,
              color: Theme.of(context).iconTheme.color.withRed(10),
            ),
            onPressed: onWritePressed,
          )
        ],
      ),
    );
  }
}

class AdapterStateTile extends StatelessWidget {
  const AdapterStateTile({Key key, @required this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: ListTile(
        title: Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subhead,
        ),
        trailing: Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subhead.color,
        ),
      ),
    );
  }
}

class ChangeForm extends StatefulWidget {
  @override
  _ChangeFormState createState() => _ChangeFormState();
}

class _ChangeFormState extends State<ChangeForm> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';

  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: <Widget>[
                new TextFormField(
                  enabled: true,
                  maxLength: 1,
                  maxLengthEnforced: false,
                  obscureText: false,
                  autovalidate: false,
                  decoration: const InputDecoration(
                    hintText: 'お名前を教えてください',
                    labelText: '名前 *',
                  ),
                  validator: (String value) {
                    return value.isEmpty ? '必須入力です' : null;
                  },
                  onSaved: (String value) {
                    this._name = value;
                  },
                ),
                new TextFormField(
                  maxLength: 100,
                  autovalidate: true,
                  decoration: const InputDecoration(
                    hintText: '連絡先を教えてください。',
                    labelText: 'メールアドレス *',
                  ),
                  validator: (String value) {
                    return !value.contains('@') ? 'アットマーク「＠」がありません。' : null;
                  },
                  onSaved: (String value) {
                    this._email = value;
                  },
                ),
                RaisedButton(
                  onPressed: _submission,
                  child: Text('保存'),
                )
              ],
            )));
  }

  void _submission() {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Processing Data')));
      print(this._name);
      print(this._email);
    }
  }
}
