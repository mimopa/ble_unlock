class APIPath {
  static String parking(String parkId, String bdId) => 'parking/$parkId/$bdId';
  // static String parkings(String parkId) => 'parking/$parkId';
  // parkIdは使ってない！
  static String parkings(String parkId) => 'parking/';
  // entry -> userid -> フィールド
  static String entry(String uid) => 'entry/$uid';
}
