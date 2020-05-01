import 'dart:async';

import 'package:ble_unlock/app/home/models/entry.dart';
import 'package:ble_unlock/app/home/models/parking.dart';
import 'package:ble_unlock/services/api_path.dart';
import 'package:ble_unlock/services/firestore_service.dart';
import 'package:meta/meta.dart';

abstract class Database {
  Future<void> setParking(Parking parking);
  Stream<Parking> parkingStream({@required String bdId});
  Future<Parking> getParking(String parkId, String bdId);
  Future<List<Parking>> getParkings(String parkId);
  Future<void> setEntry(Entry entry);
  Future<Entry> getEntry();
  Future<void> deleteEntry(Entry entry);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Stream<Parking> parkingStream(
          {@required String parkId, @required String bdId}) =>
      _service.documentStream(
        path: APIPath.parking(parkId, bdId),
        builder: (data, documentId) => Parking.fromMap(data, documentId),
      );

  @override
  Future<void> setParking(Parking parking) {
    throw UnimplementedError();
  }

  Future<Parking> getParking(String parkId, String bdId) async {
    Map<String, dynamic> docdata = await _service
        .getData(path: APIPath.parking(parkId, bdId), documentID: parkId)
        .then((doc) {
      return doc.data;
    });
    return Parking.fromMap(docdata, parkId);
  }

  @override
  Future<List<Parking>> getParkings(String parkId) async {
    List keyList = [];
    List<Parking> parkings = [];
    // parkIdは不要
    await _service.getList(path: APIPath.parkings(parkId)).then((docs) {
      docs.forEach((doc) {
        keyList.add(doc.data['key_id']);
        parkings.add(Parking.fromMap(doc.data, parkId));
      });
    });
    return parkings;
  }

  @override
  Future<void> setEntry(Entry entry) async =>
      await _service.setData(path: APIPath.entry(uid), data: entry.toMap());

  // 利用エントリーの削除：簡易的にユーザー単位で削除か
  @override
  Future<void> deleteEntry(Entry entry) async =>
      await _service.deleteData(path: APIPath.entry(uid));

  // 利用エントリーの取得：既に利用しているエントリーの存在チェック用
  @override
  Future<Entry> getEntry() async {
    print(uid);
    Map<String, dynamic> docdata = await _service
        .getData(path: APIPath.entry(uid), documentID: uid)
        .then((doc) {
      return doc.data;
    });
    return Entry.fromMap(docdata, uid);
  }
}
