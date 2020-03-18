import 'package:meta/meta.dart';

class Parking {
  Parking({
    @required this.id,
    @required this.bdId,
    @required this.keyId,
    @required this.openKey,
  });
  final String id; // Bluetooth Id
  final String bdId;
  final String keyId;
  final String openKey;

  factory Parking.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String keyId = data['key_id'];
    final String bdId = data['bd_id'];
    final String openKey = data['open_key'];
    return Parking(
      id: documentId,
      keyId: keyId,
      bdId: bdId,
      openKey: openKey,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key_id': keyId,
    };
  }
}
