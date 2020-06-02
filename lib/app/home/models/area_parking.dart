import 'package:meta/meta.dart';

class AreaParking {
  AreaParking({
    @required this.id,
    @required this.areaParkingName,
    @required this.areaParkingAbbreviationName,
  });
  final String id; // Area Id
  final String areaParkingName;
  final String areaParkingAbbreviationName;

  factory AreaParking.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String areaParkingName = data['parking_name'];
    final String areaParkingAbbreviationName =
        data['parking_abbreviation_name'];
    return AreaParking(
      id: documentId,
      areaParkingName: areaParkingName,
      areaParkingAbbreviationName: areaParkingAbbreviationName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key_id': id,
    };
  }
}
