import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:privvy/controllers/auth_service.dart';
import 'package:privvy/controllers/database_service.dart';
import 'package:privvy/utils/app_helper_handlers.dart';
import 'package:privvy/utils/app_logger.dart';
import 'package:privvy/utils/app_constants.dart';

class StorageService {
  
  // ! Upload init image to storage
  Future<String> uploadInitPrivvyImage(XFile imageFile) async {
    try {
      String authenticatedUserId = await AuthService.getLoggedInUserID();
      String autoID = generateRandomID();
      final firebaseStorageRef = FirebaseStorage.instance.ref("$authenticatedUserId/$autoID/${imageFile.name}");
   
      await firebaseStorageRef.putFile(File(imageFile.path), SettableMetadata(contentType: "image/jpg"));

      return "$autoID/${imageFile.name}";
    } 
    on FirebaseException catch (e) {
      AppLogger().log(Level.warning, "StorageService.uploadInitPrivvyImage (FirebaseException) ERROR: ${e.toString()}");
      return AppConstants.serverException;
    } 
    catch (e) {
      AppLogger().log(Level.warning, "StorageService.uploadInitPrivvyImage ERROR: ${e.toString()}");
      return AppConstants.serverException;
    }
  }

  // ! Fetch collection images from storage and return urls
  @Deprecated("Logic is moved to backend")
  Future<List<String>> processPrivvyImagesAndReturnUrls(List<String> refPaths, String autoID) async {
    final firebaseStorageRef = FirebaseStorage.instance.ref();
    List<String> processedImageUrls = [];

    for (String path in refPaths) {
      var urlRef = firebaseStorageRef.child(path);
      var imgUrl = await urlRef.getDownloadURL();
      processedImageUrls.add(imgUrl);
    }

    Map<String,dynamic> dataPrep = {
      "name": autoID,
      "images": processedImageUrls
    };

    String authenticatedUserId = await AuthService.getLoggedInUserID();

    String updateRecordFeedback = await DatabaseService.updateRecord("${AppConstants.usersMetadataDBCollectionName}/$authenticatedUserId/collections/$autoID", dataPrep);

    if(updateRecordFeedback != AppConstants.generalSuccessMessageKey) {
      throw Exception(AppConstants.serverException);
    }

    return processedImageUrls;
  }

}