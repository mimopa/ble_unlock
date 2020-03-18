import 'dart:async';

import 'package:ble_unlock/app/home/models/parking.dart';
import 'package:ble_unlock/services/api_path.dart';
import 'package:ble_unlock/services/firestore_service.dart';
import 'package:meta/meta.dart';

abstract class Database {
  Future<void> setParking(Parking parking);
  Stream<Parking> parkingStream({@required String bdId});
  Future<Parking> getParking(String parkId, String bdId);
  Future<List<Parking>> getParkings(String parkId);
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
    // TODO: implement setParking
    throw UnimplementedError();
  }

  Future<Parking> getParking(String parkId, String bdId) async {
    Map<String, dynamic> docdata = await _service
        .getData(path: APIPath.parking(parkId, bdId), documentID: parkId)
        .then((doc) {
      return doc.data;
    });
    // Parking parkingInfo = Parking.fromMap(docdata, bdId);
    return Parking.fromMap(docdata, parkId);
  }

  @override
  Future<List<Parking>> getParkings(String parkId) async {
    List keyList = [];
    List<Parking> parkings = [];
    await _service.getList(path: APIPath.parkings(parkId)).then((docs) {
      docs.forEach((doc) {
        // パラメータに該当するドキュメントのみ取得している
        // if (doc.documentID == parkId) {
        //   // print('database!');
        //   // print(doc.data);
        //   // print(doc.documentID);
        //   keyList.add(doc.data['key_id']);
        //   parkings.add(Parking.fromMap(doc.data, parkId));
        // }
        keyList.add(doc.data['key_id']);
        parkings.add(Parking.fromMap(doc.data, parkId));
      });
    });
    return parkings;
  }
}
