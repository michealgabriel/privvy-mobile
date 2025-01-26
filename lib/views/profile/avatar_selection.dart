
import 'package:flutter/material.dart';
import 'package:privvy/controllers/auth_service.dart';
import 'package:privvy/controllers/database_service.dart';
import 'package:privvy/providers/profile_provider.dart';
import 'package:privvy/utils/app_material_navigator.dart';
import 'package:privvy/utils/app_shared_pref_handlers.dart';
import 'package:privvy/utils/app_constants.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/app_shared_widgets/buttons/app_button_wide.dart';
import 'package:privvy/views/app_shared_widgets/others/content_loading_widget.dart';
import 'package:privvy/views/app_shared_widgets/others/profile_image_avatar.dart';
import 'package:privvy/views/profile/username_setup.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AvatarSelection extends StatefulWidget {
  final bool isFreshSetup;
  const AvatarSelection({super.key, required this.isFreshSetup});

  @override
  State<AvatarSelection> createState() => _AvatarSelectionState();
}

class _AvatarSelectionState extends State<AvatarSelection> {

  String avatarTitle = "AVATAR";
  int? selectedAvatarIndex;
  final List<String> selectableAvatars = ["charming", "icy", "vibeer", "beanie", "dread", "explorer", "wizz", "collector", "og", "detective"];
  double avatarRadius = Device.screenType == ScreenType.tablet ? 70 : 50;
  double avatarRadius2 = Device.screenType == ScreenType.tablet ? 77 : 47;

  handleSelectAvatar(int index) {
    selectedAvatarIndex = index;
    avatarTitle = selectableAvatars[selectedAvatarIndex!].toUpperCase();
    setState(() {});
  }

  handleContinueTap() async {
    if(selectedAvatarIndex != null) {

      AppSPHandlers().setStringSP(AppSPHandlers.SELECTED_PRIVVY_AVATAR, selectableAvatars[selectedAvatarIndex!]);
      context.read<ProfileProvider>().setPrivvyAvatarValue(selectableAvatars[selectedAvatarIndex!]);
      
      if(widget.isFreshSetup)
      {
        // save to database too
        await handleUserMetadataStoreOperation();
      }else {
        // update in database also -> and close screen for refresh
        await handleUserMetadataUpdateOperation();
      }
    }
  }

  handleUserMetadataStoreOperation() async {
    launchPopUp(context, ContentLoadingWidget(), dismissible: false);

    String authenticatedUserID = await AuthService.getLoggedInUserID();
    Map<String, dynamic> newRecord = {
      "avatarString": selectableAvatars[selectedAvatarIndex!]
    };
    String result = await DatabaseService.addRecord(AppConstants.usersMetadataDBCollectionName, newRecord, id: authenticatedUserID);

    if(mounted) Navigator.pop(context); // close loader

    if (result == AppConstants.generalSuccessMessageKey) {
      // navigate
      if(mounted) appNavigate(context, const UsernameSetup(isFreshSetup: true));
    } 
    else if (result == AppConstants.serverException) {
      if(mounted) showAppToast(context, AppConstants.serverException, isError: true);
    }
  }

  handleUserMetadataUpdateOperation() async {
    launchPopUp(context, ContentLoadingWidget(), dismissible: false);

    String authenticatedUserID = await AuthService.getLoggedInUserID();
    Map<String, dynamic> updateRecord = {
      "avatarString": selectableAvatars[selectedAvatarIndex!]
    };
    String result = await DatabaseService.updateRecord(AppConstants.usersMetadataDBCollectionName, updateRecord, documentId: authenticatedUserID);

    if(mounted) Navigator.pop(context); // close loader

    if (result == AppConstants.generalSuccessMessageKey) 
    {
      if(mounted) Navigator.pop(context, 'refresh');
    } 
    else if (result == AppConstants.serverException) {
      if(mounted) showAppToast(context, AppConstants.serverException, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeConstants.APP_BG_DARK,

      body: SingleChildScrollView(
        padding: EdgeInsets.all(Device.screenType == ScreenType.tablet ? 100 : AppThemeConstants().APP_BASE_CONTENT_PADDING),
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 60,),

              const Text("Choose your Privvy", textAlign: TextAlign.center, style: AppThemeConstants.APP_BODY_TEXT_REGULAR,),
              Text(avatarTitle, textAlign: TextAlign.center, style: AppThemeConstants.APP_HEADING_TEXT_2,),
              
              const SizedBox(height: 25,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSelectableAvatar(selectableAvatars[0], 0, avatarRadius2),
                  _buildSelectableAvatar(selectableAvatars[1], 1, avatarRadius2),
                ],
              ),

              const SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSelectableAvatar(selectableAvatars[2], 2, avatarRadius),
                  _buildSelectableAvatar(selectableAvatars[3], 3, avatarRadius),
                  _buildSelectableAvatar(selectableAvatars[4], 4, avatarRadius),
                ],
              ),

              const SizedBox(height: 24,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSelectableAvatar(selectableAvatars[5], 5, avatarRadius),
                  _buildSelectableAvatar(selectableAvatars[6], 6, avatarRadius),
                  _buildSelectableAvatar(selectableAvatars[7], 7, avatarRadius),
                ],
              ),

              const SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSelectableAvatar(selectableAvatars[8], 8, avatarRadius),
                  _buildSelectableAvatar(selectableAvatars[9], 9, avatarRadius),
                ],
              ),
      
              const SizedBox(height: 50,),
      
              AppButtonWide(buttonText: 'CONTINUE', disabled: selectedAvatarIndex == null, callback: () => handleContinueTap()),
              
              const SizedBox(height: 120,),
      
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableAvatar(String imageName, int index, double avatarRadius) {
    return GestureDetector(
      onTap: () => handleSelectAvatar(index),
      child: Stack(
        children: [
          ProfileImageAvatar(
            imagePath: "assets/avatars/$imageName.png", 
            isLocalImage: true, 
            radius: avatarRadius, 
            paintBackground: selectedAvatarIndex == index,
            imageSize: Device.screenType == ScreenType.tablet ? 140 : 100,
          ),
          Visibility(
            visible: selectedAvatarIndex == index,
            child: Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
                ),
                child: const Icon(Icons.check_circle, color: Colors.green, size: 24,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}