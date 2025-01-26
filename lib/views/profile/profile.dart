import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:privvy/providers/profile_provider.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/app_shared_widgets/others/profile_image_avatar.dart';
import 'package:privvy/views/profile/widgets/profile_settings_tiles.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {

    String userNickname = context.watch<ProfileProvider>().userNicknameValue;
    String storedChosenAvatar = context.watch<ProfileProvider>().privvyAvatarValue;

    return Scaffold(
      backgroundColor: AppThemeConstants.APP_BG_DARK,
  
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Device.screenType == ScreenType.tablet ? AppThemeConstants().APP_TABLET_BASE_CONTENT_PADDING : AppThemeConstants().APP_BASE_CONTENT_PADDING),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            
            const SizedBox(height: 80,),
            
            //Profile View Details
            Animate(
              autoPlay: true,
              effects: const [ShimmerEffect(delay: Duration(seconds: 3))],
              onComplete: (controller) => controller.repeat(),
              child: Center(
                child: Column(
                  children: [
                    ProfileImageAvatar(
                      imagePath: "assets/avatars/$storedChosenAvatar.png", 
                      isLocalImage: true, 
                      radius: Device.screenType == ScreenType.tablet ? 110 : 90, 
                      imageSize: Device.screenType == ScreenType.tablet ? 230 : 180, 
                      paintBackground: true
                    ),

                    const SizedBox(height: 20,),
            
                    Text(userNickname, style: AppThemeConstants.APP_HEADING_TEXT_MEDIUM),
                    Text(storedChosenAvatar.toUpperCase(), style: AppThemeConstants.APP_BODY_TEXT_MEDIUM),
                  ],
                ),
              ),
            ),
      
            const SizedBox(height: 60,),
            
            const ProfileSettingsTiles(),
        
          ],
        ),
      ),
      
    );
  }
}