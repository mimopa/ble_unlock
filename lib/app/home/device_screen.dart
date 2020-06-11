import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

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
  final String keyId;

  const CharacteristicTile({
    Key key,
    this.characteristic,
    this.descriptorTiles,
    this.onReadPressed,
    this.onWritePressed,
    this.onNotificationPressed,
    this.openKey,
    this.keyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      // デバイスとの送受信データ（変更があれば反映される）
      // 受信データは<List<int>>
      // 支払い後のBLEデータ送受信UIを変更するならば、ここ
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (c, snapshot) {
        final value = snapshot.data;
        value.asMap().forEach((key, value) {
          print(value);
        });
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
              ],
            ),
            // デバイスからの受信データがここに表示される。asciiをデコードして文字列表示
            // subtitleに10進の「65」（16進：0x41、文字：A）が表示されれば解錠成功
            subtitle: Text(value.toList().toString()),
            contentPadding: EdgeInsets.all(0.0),
          ),
          // Listの後ろ
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Read用のボタン
              // Readいらないので、解錠コード作成ボタンにする
              // ATE用のボタン
              IconButton(
                icon: Icon(
                  Icons.vpn_key,
                  color: Theme.of(context).iconTheme.color.withRed(10),
                ),
                // onPressed: onReadPressed,
                onPressed: () async {
                  // 「ATE」(テスト用コマンド)を送信して鍵生成
                  // A:0x41,T:0x54,E:0x45
                  List<int> writeData = [];
                  writeData.add(0x41);
                  writeData.add(0x54);
                  writeData.add(0x45);
                  print('ATE');
                  print(writeData);
                  await characteristic.write(writeData, withoutResponse: false);
                },
              ),
              // ATK用のボタン
              IconButton(
                icon: Icon(
                  Icons.vpn_key,
                  color: Theme.of(context).iconTheme.color.withRed(10),
                ),
                // onPressed: onReadPressed,
                onPressed: () async {
                  // 「ATK」(テスト用コマンド)を送信して鍵受け取り
                  // A:0x41,T:0x54,K:0x4b
                  List<int> writeData = [];
                  writeData.add(0x41);
                  writeData.add(0x54);
                  writeData.add(0x4B);
                  print('ATK');
                  print(writeData);
                  await characteristic.write(writeData, withoutResponse: false);
                },
              ),
              // 書き込み用のボタン
              IconButton(
                icon: Icon(Icons.lock_open,
                    color: Theme.of(context).iconTheme.color.withRed(10)),
                // onPressed: onWritePressed,
                onPressed: () async {
                  List<int> writeData = [];
                  print('openKey');
                  print(openKey);
                  // String param1 = int.parse('0x${openKey.substring(0, 2)}')
                  //     .toRadixString(16);
                  String param1 = openKey.substring(0, 2);
                  // String param2 = int.parse('0x${openKey.substring(2, 4)}')
                  //     .toRadixString(16);
                  // String param2 =
                  //     int.parse('0x${openKey.substring(2)}').toRadixString(16);
                  String param2 = openKey.substring(2);
                  // String param3 = int.parse('0x${openKey.substring(4, 6)}')
                  //     .toRadixString(16);
                  // String param4 =
                  //     int.parse('0x${openKey.substring(6)}').toRadixString(16);
                  print('解錠データ');
                  print(int.parse('0x$param1'));
                  print(int.parse('0x$param2'));

                  // Hexで送る:30 -> 0
                  // 81 - 2C
                  // 41 04 04 04 04 04 04 51
                  // 0x41:Start,0x51:End これは固定
                  writeData.add(0x41);
                  writeData.add(int.parse('0x$param1'));
                  writeData.add(int.parse('0x$param2'));
                  // writeData.add(0x26);
                  // writeData.add(0x3d);
                  writeData.add(0x51);

                  print(writeData);
                  await characteristic.write(writeData, withoutResponse: false);
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
