
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:privvy/utils/app_logger.dart';
import 'package:privvy/utils/app_constants.dart';

class DatabaseService {

  // ! Add data to db
  static Future<String> addRecord(String targetCollection, Map<String, dynamic> addData, {String? id}) async {
    final databaseReference = FirebaseDatabase.instance.ref(targetCollection);

    try {
      final autoID = DateTime.now().microsecond.toString();

      await databaseReference.child(id ?? autoID).set(addData);

      return AppConstants.generalSuccessMessageKey;
    }
    catch (e) {
      AppLogger().log(Level.warning, "DatabaseService.addRecord ERROR: ${e.toString()}");
      return AppConstants.serverException;
    }
  }

  // ! Update data in db
  static Future<String> updateRecord(String targetCollection, Map<String, dynamic> updateData, {String? documentId}) async {
    final databaseReference = FirebaseDatabase.instance.ref(targetCollection);

    try {
      if(documentId != null) {
        await databaseReference.child(documentId).update(updateData);
      }else {
        await databaseReference.update(updateData);
      }

      return AppConstants.generalSuccessMessageKey;
    }
    catch (e) {
      AppLogger().log(Level.warning, "DatabaseService.updateRecord ERROR: ${e.toString()}");
      return AppConstants.serverException;
    }
  }

  // ! Read single data from db
  static Future<dynamic> readSingleRecord(String targetCollection, String documentId) async {
    final databaseReference = FirebaseDatabase.instance.ref(targetCollection);

    try {
      final data = await databaseReference.child(documentId).once(DatabaseEventType.value);

      if(data.snapshot.exists) return data.snapshot.value;

      return AppConstants.noDatabaseResults;
    }
    catch (e) {
      AppLogger().log(Level.warning, "DatabaseService.readSingleRecord ERROR: ${e.toString()}");
      return AppConstants.serverException;
    }
  }

  // ! Read target multiple data from db
  static Future<dynamic> readTargetMultiRecord(String targetCollection) async {
    final databaseReference = FirebaseDatabase.instance.ref(targetCollection);

    try {
      final data = await databaseReference.once(DatabaseEventType.value);

      if(data.snapshot.exists) {
        Map<String, dynamic> valueAsMap = {};
        
        (data.snapshot.value as Map).forEach((key, value) {
          valueAsMap[key.toString()] = value;
        });

        return valueAsMap;
      }

      return AppConstants.noDatabaseResults;
    }
    catch (e) {
      AppLogger().log(Level.warning, "DatabaseService.readTargetMultiRecord ERROR: ${e.toString()}");
      return AppConstants.serverException;
    }
  }

  // ! Delete record from db
  static Future<String> deleteRecord(String targetCollection, String recordKeyOrId) async {
    final databaseReference = FirebaseDatabase.instance.ref();

    try {
      await databaseReference.child(targetCollection).child(recordKeyOrId).remove();

      return AppConstants.generalSuccessMessageKey;
    }
    catch (e) {
      AppLogger().log(Level.warning, "DatabaseService.deleteRecord ERROR: ${e.toString()}");
      return AppConstants.serverException;
    }
  }

}