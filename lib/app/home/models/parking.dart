import 'package:meta/meta.dart';

class Parking {
  Parking({
    @required this.id,
    @required this.bdId,
    @required this.iosBdId,
    @required this.androidBdId,
    @required this.keyId,
    @required this.openKey,
  });
  final String id; // Bluetooth Id
  final String bdId;
  final String iosBdId;
  final String androidBdId;
  final String keyId;
  final String openKey;

  factory Parking.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String keyId = data['key_id'];
    final String bdId = data['bd_id'];
    final String iosBdId = data['bd_id1'];
    final String androidBdId = data['bd_id2'];
    final String openKey = data['open_key'];
    return Parking(
      id: documentId,
      keyId: keyId,
      bdId: bdId,
      iosBdId: iosBdId,
      androidBdId: androidBdId,
      openKey: openKey,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key_id': keyId,
    };
  }
}
