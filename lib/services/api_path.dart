class APIPath {
  static String parking(String parkId, String bdId) => 'parking/$parkId/$bdId';
  // static String parkings(String parkId) => 'parking/$parkId';
  // parkIdは使ってない！
  static String parkings() => 'parking/';
  // entry -> userid -> フィールド
  static String entry(String uid) => 'entry/$uid';

  static String areas() => 'area/';
  static String area(String areaId) => 'area/$areaId';
  // area -> area_id(001) -> parking -> parking_id(001) ->
  static String areaParkings(String areaId) => 'area/$areaId/parking';
  static String areaParking(String areaId, String parkId) =>
      'area/$areaId/parking/$parkId';
  static String areaParkingKeys(String areaId, String parkId) =>
      'area/$areaId/parking/$parkId/keiys';
  static String areaParkingKey(String areaId, String parkId, String keyId) =>
      'area/$areaId/parking/$parkId/keiys/$keyId';
}
