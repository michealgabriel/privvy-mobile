

import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {

  String _privvyAvatarValue = "";
  String _userNicknameValue = "";


  String get privvyAvatarValue => _privvyAvatarValue;
  String get userNicknameValue => _userNicknameValue;


  void setPrivvyAvatarValue(String value) {
    _privvyAvatarValue = value;
    notifyListeners();
  }

  void setUserNicknameValue(String value) {
    _userNicknameValue = value;
    notifyListeners();
  }

 
  // !!! --------------- RESET PROFILE PROVIDER --------------- !!! //
  void resetProfileProvider() {
    // print('reset profile prov fields called!');
    // resetting each fields back to it's initial state
    _privvyAvatarValue = "";
    _userNicknameValue = "";

    notifyListeners();
  }  

}