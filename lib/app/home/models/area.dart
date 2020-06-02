import 'package:meta/meta.dart';

class Area {
  Area({
    @required this.id,
    @required this.areaName,
    @required this.areaAbbreviationName,
  });
  final String id; // Area Id
  final String areaName;
  final String areaAbbreviationName;

  factory Area.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String areaName = data['area_name'];
    final String areaAbbreviationName = data['area_abbreviation_name'];
    return Area(
      id: documentId,
      areaName: areaName,
      areaAbbreviationName: areaAbbreviationName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key_id': id,
    };
  }
}
