

import 'package:flutter/material.dart';

class PrivvyGenerationProvider extends ChangeNotifier {

  bool _isCallingGenerateAPI = false;
  bool _isFetchingCollections = true;


  bool get isCallingGenerateAPI => _isCallingGenerateAPI;
  bool get isFetchingCollections => _isFetchingCollections;


  void setIsCallingGenerateAPI(bool flag) {
    _isCallingGenerateAPI = flag;
    notifyListeners();
  }

  void setIsFetchingCollections(bool flag) {
    _isFetchingCollections = flag;
    notifyListeners();
  }
 

 
  // !!! --------------- RESET Privvy Generation PROVIDER --------------- !!! //
  void resetPrivvyGenerationProvider() {
    // resetting each fields back to it's initial state
    _isCallingGenerateAPI = false;
    _isFetchingCollections = true;

    notifyListeners();
  }  

}