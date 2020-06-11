import 'dart:async';

import 'package:ble_unlock/app/home/models/area.dart';
import 'package:ble_unlock/app/home/models/area_parking.dart';
import 'package:ble_unlock/app/home/models/area_parking_key.dart';
import 'package:ble_unlock/app/home/models/entry.dart';
import 'package:ble_unlock/app/home/models/parking.dart';
import 'package:ble_unlock/services/api_path.dart';
import 'package:ble_unlock/services/firestore_service.dart';
import 'package:meta/meta.dart';

abstract class Database {
  Future<void> setParking(Parking parking);
  Future<Parking> getParking(String parkId, String bdId);
  Future<List<Parking>> getParkings(String parkId);
  Future<List<AreaParkingKey>> getAreaParkingKeys(String areaId, String parkId);
  Stream<Area> areaStream({@required String areaId});
  Stream<AreaParking> areaParkingStream(
      {@required String areaId, @required String parkId});
  Stream<AreaParkingKey> areaParkingKeyStream(
      {@required String areaId,
      @required String parkId,
      @required String keyId});
  Stream<List<Area>> areasStream();
  Stream<List<AreaParking>> areaParkingsStream({@required String areaId});
  Stream<List<AreaParkingKey>> areaParkingKeysStream(
      {@required String areaId, @required String parkId});
  Stream<Parking> parkingStream({@required String bdId});
  Future<void> setEntry(Entry entry);
  Future<Entry> getEntry();
  Future<void> deleteEntry(Entry entry);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  // Stream

  @override
  Stream<Parking> parkingStream(
          {@required String parkId, @required String bdId}) =>
      _service.documentStream(
        path: APIPath.parking(parkId, bdId),
        builder: (data, documentId) => Parking.fromMap(data, documentId),
      );

  @override
  Stream<Area> areaStream({@required String areaId}) => _service.documentStream(
        path: APIPath.area(areaId),
        builder: (data, documentId) => Area.fromMap(data, documentId),
      );

  @override
  Stream<List<Area>> areasStream() => _service.collectionStream(
        path: APIPath.areas(),
        builder: (data, documentId) => Area.fromMap(data, documentId),
      );

  @override
  Stream<AreaParking> areaParkingStream({String areaId, String parkId}) =>
      _service.documentStream(
        path: APIPath.areaParking(areaId, parkId),
        builder: (data, documentId) => AreaParking.fromMap(data, documentId),
      );

  @override
  Stream<List<AreaParking>> areaParkingsStream({String areaId}) =>
      _service.collectionStream(
        path: APIPath.areaParkings(areaId),
        builder: (data, documentId) => AreaParking.fromMap(data, documentId),
      );

  @override
  Stream<AreaParkingKey> areaParkingKeyStream(
          {String areaId, String parkId, String keyId}) =>
      _service.documentStream(
        path: APIPath.areaParkingKey(areaId, parkId, keyId),
        builder: (data, documentId) => AreaParkingKey.fromMap(data, documentId),
      );

  @override
  Stream<List<AreaParkingKey>> areaParkingKeysStream(
          {String areaId, String parkId}) =>
      _service.collectionStream(
        path: APIPath.areaParkingKeys(areaId, parkId),
        builder: (data, documentId) => AreaParkingKey.fromMap(data, documentId),
      );

  // Future

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
    await _service.getList(path: APIPath.parkings()).then((docs) {
      docs.forEach((doc) {
        keyList.add(doc.data['key_id']);
        parkings.add(Parking.fromMap(doc.data, parkId));
      });
    });
    return parkings;
  }

  @override
  Future<List<AreaParkingKey>> getAreaParkingKeys(
      String areaId, String parkId) async {
    List keyList = [];
    List<AreaParkingKey> parkings = [];
    await _service
        .getList(path: APIPath.areaParkingKeys(areaId, parkId))
        .then((docs) {
      docs.forEach((doc) {
        // keyList.add(doc.data['key_id']);
        keyList.add(doc.documentID);
        parkings.add(AreaParkingKey.fromMap(doc.data, doc.documentID));
        print('getAreaParkingKes');
        print(keyList);
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
