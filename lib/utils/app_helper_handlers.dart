

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:privvy/controllers/auth_service.dart';
import 'package:privvy/controllers/database_service.dart';
import 'package:privvy/providers/profile_provider.dart';
import 'package:privvy/utils/app_material_navigator.dart';
import 'package:privvy/utils/app_shared_pref_handlers.dart';
import 'package:privvy/utils/app_constants.dart';
import 'package:privvy/views/home/home.dart';
import 'package:privvy/views/profile/avatar_selection.dart';
import 'package:provider/provider.dart';


handleAppInitAutoLogin(BuildContext context, bool mounted) async {
  if(await AuthService.isLoggedIn() == true) {  // if logged in -> route direct to home
    String storedAvatar = await AppSPHandlers().getStringSP(AppSPHandlers.SELECTED_PRIVVY_AVATAR);
    String storedNickname = await AppSPHandlers().getStringSP(AppSPHandlers.USER_NICKNAME);

    if(mounted) {
      context.read<ProfileProvider>().setPrivvyAvatarValue(storedAvatar);
      context.read<ProfileProvider>().setUserNicknameValue(storedNickname);

      appNavigate(context, const Home(), isPushReplace: true);
    }
  }else {
    if(mounted) Navigator.pushReplacementNamed(context, '/login');
  }
}


handleAfterAuthDecisionRoute(BuildContext context, bool mounted) async {
  // ! should fetch using userid, their avatar and nickname. If they are null or no record,
  // ! route - AvatarSelection(isFreshSetup: true)  --->  else - route - Home() skipping the avatar selection

  String authenticatedUserID = await AuthService.getLoggedInUserID();
  dynamic result = await DatabaseService.readSingleRecord(AppConstants.usersMetadataDBCollectionName, authenticatedUserID);

  if (result == AppConstants.noDatabaseResults || result == AppConstants.serverException) 
  {
    if(mounted) {
      Navigator.pop(context); // to close popup loader
      appNavigate(context, const AvatarSelection(isFreshSetup: true,));
    }
  }
  else {
    if(mounted) {
      AppSPHandlers().setStringSP(AppSPHandlers.SELECTED_PRIVVY_AVATAR, result["avatarString"]);
      AppSPHandlers().setStringSP(AppSPHandlers.USER_NICKNAME, result["nickname"]);
      context.read<ProfileProvider>().setPrivvyAvatarValue(result["avatarString"]);
      context.read<ProfileProvider>().setUserNicknameValue(result["nickname"]);

      Navigator.pop(context); // to close popup loader
      appNavigate(context, const Home());
    }
  }
}


String generateRandomID() {
  var rng = Random();
  int min = 10000000; // Minimum 8 digit number
  int max = 99999999; // Maximum 8 digit number
  int randomNumber = min + rng.nextInt(max - min);
  return randomNumber.toString();
}