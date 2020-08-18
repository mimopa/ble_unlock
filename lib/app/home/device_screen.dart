import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

// Serviceを表示するWidget
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
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;
  final VoidCallback onNotificationPressed;
  final String openKey;
  final String keyId;

  const CharacteristicTile({
    Key key,
    this.characteristic,
    this.onReadPressed,
    this.onWritePressed,
    this.onNotificationPressed,
    this.openKey,
    this.keyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      // デバイスとの送受信データ（変更があればStreamに流れてくる）
      // 受信データは<List<int>>
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (c, snapshot) {
        final value = snapshot.data;
        value.asMap().forEach((key, value) {
          print(value);
        });
        print('Characteristic Value!');
        print(value.toList().toString());
        print(snapshot.connectionState);
        print(snapshot.hasData);
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
              // 鍵の作成と取得（LoRaなしでのデバック用途）はRENESASの公開アプリでやる
              // // ATE用のボタン
              // IconButton(
              //   icon: Icon(
              //     Icons.vpn_key,
              //     color: Theme.of(context).iconTheme.color.withRed(10),
              //   ),
              //   // onPressed: onReadPressed,
              //   onPressed: () async {
              //     // 「ATE」(テスト用コマンド)を送信して鍵生成
              //     // A:0x41,T:0x54,E:0x45
              //     List<int> writeData = [];
              //     writeData.add(0x41);
              //     writeData.add(0x54);
              //     writeData.add(0x45);
              //     print('ATE');
              //     print(writeData);
              //     await characteristic.write(writeData, withoutResponse: false);
              //   },
              // ),
              // // ATK用のボタン
              // IconButton(
              //   icon: Icon(
              //     Icons.vpn_key,
              //     color: Theme.of(context).iconTheme.color.withRed(10),
              //   ),
              //   // onPressed: onReadPressed,
              //   onPressed: () async {
              //     // 「ATK」(テスト用コマンド)を送信して鍵受け取り
              //     // A:0x41,T:0x54,K:0x4b
              //     List<int> writeData = [];
              //     writeData.add(0x41);
              //     writeData.add(0x54);
              //     writeData.add(0x4B);
              //     print('ATK');
              //     print(writeData);
              //     await characteristic.write(writeData, withoutResponse: false);
              //   },
              // ),
              // 書き込み用のボタン
              IconButton(
                icon: Icon(Icons.lock_open,
                    color: Theme.of(context).iconTheme.color.withRed(10)),
                // onPressed: onWritePressed,
                onPressed: () async {
                  List<int> writeData = [];
                  String param1 = openKey.substring(0, 2);
                  String param2 = openKey.substring(2);
                  print('解錠データ');
                  print(int.parse('0x$param1'));
                  print(int.parse('0x$param2'));

                  // 0x41:Start,0x51:End これは固定
                  writeData.add(0x41);
                  writeData.add(int.parse('0x$param1'));
                  writeData.add(int.parse('0x$param2'));
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
                // onPressed: onNotificationPressed,
                onPressed: () async {
                  characteristic.setNotifyValue(!characteristic.isNotifying);
                  characteristic.value.listen((value) {
                    print('notify value');
                    print(value);
                  });
                },
              )
            ],
          ),
        );
      },
    );
  }
}
