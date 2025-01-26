
// A Main file for whole application's shared prefs identifiers/handlers :: To keep track of all prefs in app


// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class AppSPHandlers {

  static const String SELECTED_PRIVVY_AVATAR = "SELECTED_PRIVVY_AVATAR";
  static const String USER_NICKNAME = "USER_NICKNAME";
  
  static const String CHILL_EXPERIENCE_STATUS = "CHILL_EXPERIENCE_STATUS";
  static const String COMPLETED_ONBOARD = "COMPLETED_ONBOARD";
  static const String VOLUME_SLIDER_VALUE = "VOLUME_SLIDER_VALUE";

  
  //Shared Preferences String Getter & Setter
  setStringSP(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
  getStringSP(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }


  // Shared Preferences Double Getter & Setter
  setDoubleSP(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(key, value);
  }
  getDoubleSP(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  
  //Shared Preferences List String Getter & Setter
  setListStringSP(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(key, value);
  }
  Future<List<String>?> getListStringSP(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }


  //Shared Preferences Bool Getter & Setter
  setBoolSP(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }
  getBoolSP(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getBool(key).toString());
    return prefs.getBool(key);
  }


  //SP Remove & Clear
  removeSP(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
  clearSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
  clearSelectiveSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(SELECTED_PRIVVY_AVATAR);
    prefs.remove(USER_NICKNAME);
  }

}



