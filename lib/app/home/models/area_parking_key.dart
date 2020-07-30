import 'package:meta/meta.dart';

class AreaParkingKey {
  AreaParkingKey({
    @required this.id,
    @required this.areaParkingKeyName,
    @required this.areaParkingKeyAbbreviationName,
    @required this.status,
    @required this.openKey,
    @required this.blutoothId,
    @required this.iosBluetoothId,
    @required this.androidBluetoothId,
    @required this.battery,
  });
  final String id; // Key Id
  final String areaParkingKeyName;
  final String areaParkingKeyAbbreviationName;
  final String status;
  final String openKey;
  final String blutoothId;
  final String iosBluetoothId;
  final String androidBluetoothId;
  final String battery;

  factory AreaParkingKey.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String areaParkingKeyName = data['key_name'];
    final String areaParkingKeyAbbreviationName = data['key_abbreviation_name'];
    final String status = data['status'];
    final String openKey = data['open_key'];
    final String blutoothId = data['bd_id'];
    final String iosBluetoothId = data['bd_id1'];
    final String androidBluetoothId = data['bd_id2'];
    final String battery = data['battery'];
    return AreaParkingKey(
      id: documentId,
      areaParkingKeyName: areaParkingKeyName,
      areaParkingKeyAbbreviationName: areaParkingKeyAbbreviationName,
      status: status,
      openKey: openKey,
      blutoothId: blutoothId,
      iosBluetoothId: iosBluetoothId,
      androidBluetoothId: androidBluetoothId,
      battery: battery,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key_id': id,
    };
  }
}
