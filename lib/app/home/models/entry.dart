import 'package:meta/meta.dart';

class Entry {
  Entry({
    this.userId,
    @required this.parkId,
    @required this.keyId,
    @required this.passCode,
  });
  final String userId;
  final String parkId;
  final String keyId;
  final String passCode;

  factory Entry.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String parkId = data['park_id'];
    final String keyId = data['key_id'];
    final String passCode = data['pass_code'];
    return Entry(
      userId: documentId,
      keyId: keyId,
      parkId: parkId,
      passCode: passCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'park_id': parkId,
      'key_id': keyId,
      'padd_code': passCode,
    };
  }
}
