 
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:privvy/controllers/auth_service.dart';
import 'package:privvy/models/generation_response_model.dart';
import 'package:privvy/utils/app_logger.dart';
import 'package:privvy/utils/app_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  String baseUrl = "";

  ApiService() {
    baseUrl = dotenv.env['SERVER_URL'].toString();
  }

  Future<GenerationResponseModel> callGenerateVariationsApi(String autoID, String imageName) async {
    try {
      String authUID = await AuthService.getLoggedInUserID();

      final response = await http.post(
        Uri.parse("$baseUrl/generateColorVariations"),
        headers: {
          // 'authorization': 'Bearer ${dotenv.env['GCLOUD_TOKEN']}',
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode({
          "uid": authUID,
          "auto_id": autoID,
          "target_path": "$authUID/$autoID/$imageName"
        })
      );

      AppLogger().log(Level.warning, "Response status code: ${response.statusCode}");
      AppLogger().log(Level.warning, "Response body: ${response.body}");

      final jsonResponse = jsonDecode(response.body);
      return GenerationResponseModel.fromJson(jsonResponse);
    } catch (e) {
      throw Exception(AppConstants.serverException);
    }
  }

  Future<bool> callDeleteVariationsApi(String autoID) async {
    try {
      String authUID = await AuthService.getLoggedInUserID();

      final response = await http.delete(
        Uri.parse("$baseUrl/deleteVariations"),
        headers: {
          // 'authorization': 'Bearer ${dotenv.env['GCLOUD_TOKEN']}',
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode({
          "uid": authUID,
          "auto_id": autoID,
          "target_path": "$authUID/$autoID/"
        })
      );

      AppLogger().log(Level.warning, "Response status code: ${response.statusCode}");
      AppLogger().log(Level.warning, "Response body: ${response.body}");

      if(response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      throw Exception(AppConstants.serverException);
    }
  }

}