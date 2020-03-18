import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

// スキャンしたデバイスをリストで受け取る。デバイスID（BDID）をリスト化する。
class ScanResultList extends StatelessWidget {
  const ScanResultList({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    print(result.device.id);
    var _deviceList;

    return DropdownButton<String>(
      value: null,
      onChanged: (String value) {},
      items: ['0', '1', '2']
          .map(
            (String value) {
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
            },
          )
          .where((value) => value.toString().contains('2'))
          .toList(),
    );
  }
}
