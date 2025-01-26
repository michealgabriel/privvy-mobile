import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:iconsax/iconsax.dart';
import 'package:logger/logger.dart';
import 'package:privvy/controllers/auth_service.dart';
import 'package:privvy/providers/music_provider.dart';
import 'package:privvy/providers/profile_provider.dart';
import 'package:privvy/utils/app_logger.dart';
import 'package:privvy/utils/app_material_navigator.dart';
import 'package:privvy/utils/app_shared_pref_handlers.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/authentication/login.dart';
import 'package:privvy/views/profile/avatar_selection.dart';
import 'package:privvy/views/profile/delete_account.dart';
import 'package:privvy/views/profile/username_setup.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileSettingsTiles extends StatefulWidget {
  const ProfileSettingsTiles({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsTiles> createState() => _ProfileSettingsTilesState();
}

class _ProfileSettingsTilesState extends State<ProfileSettingsTiles> {
  bool chillExperienceStatus = true;
  double volumeSliderValue = 0.1;

  @override
  void initState() {
    super.initState();

    (() async {
      chillExperienceStatus = await AppSPHandlers().getBoolSP(AppSPHandlers.CHILL_EXPERIENCE_STATUS) ?? true;
      volumeSliderValue = await AppSPHandlers().getDoubleSP(AppSPHandlers.VOLUME_SLIDER_VALUE) ?? 0.1;

      if(mounted) setState(() {});
    })();
  }

  handleChangeAvatar() {
    // appNavigate(context, const AvatarSelection(isFreshSetup: false,));
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AvatarSelection(isFreshSetup: false,)))
    .then((value) {
      AppLogger().log(Level.info, "Avatar selection result: $value");
      setState(() {});
    });

  }

  handleChangeName() {
    // appNavigate(context, const UsernameSetup(isFreshSetup: false,));
    Navigator.push(context, MaterialPageRoute(builder: (context) => const UsernameSetup(isFreshSetup: false,)))
    .then((value) {
      AppLogger().log(Level.info, "Avatar selection result: $value");
      setState(() {});
    });
  }

  confirmSignout() async {
    await launchPopUp(
      context,
      const Text('Do you want to sign out?', textAlign: TextAlign.start, style: AppThemeConstants.APP_BODY_TEXT_REGULAR,),
      actions: [
        TextButton(
          child: const Text('Cancel', style: AppThemeConstants.APP_BODY_TEXT_MEDIUM,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Sign Out', style: AppThemeConstants.APP_BODY_TEXT_MEDIUM,),
          onPressed: () {
            Navigator.of(context).pop();
            handleSignOut();
          },
        ),
      ],
      dismissible: false
    );
  }

  handleSignOut() async {
    await AppSPHandlers().clearSelectiveSP();
    await AuthService.logout();

    if(mounted) {
      context.read<MusicProvider>().player.pause();
      context.read<ProfileProvider>().resetProfileProvider();
      appNavigate(context, const Login(), isPushReplace: true);
    }
  }

  handleChillExperienceToggle(bool status) {
    chillExperienceStatus = status;
    AppSPHandlers().setBoolSP(AppSPHandlers.CHILL_EXPERIENCE_STATUS, status);
    Provider.of<MusicProvider>(context, listen: false).pauseOrPlayMusic();
    setState(() {});
  }

  handleVolumeSliderUpdate(double value) {
    volumeSliderValue = value;
    AppSPHandlers().setDoubleSP(AppSPHandlers.VOLUME_SLIDER_VALUE, value);
    Provider.of<MusicProvider>(context, listen: false).updateMusicVolume(value);
    setState(() {});
  }

  handleDeleteAccount() {
    appNavigate(context, DeleteAccount());
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

          buildCard(Icons.person_pin, 'Change Avatar', tapAction: () => handleChangeAvatar()),

          buildCard(Icons.how_to_reg_sharp, 'Change Nickname', tapAction: () => handleChangeName()),

          buildCard(Iconsax.headphone5, 'Chill Experience',
            // Icons.headphones_rounded,
            trailWidget: FlutterSwitch(
              value: chillExperienceStatus,
              showOnOff: false,
              toggleSize: 25,
              width: 50,
              height: 30,
              activeColor: const Color(0xff32D74B),
              onToggle: (bool val) => handleChillExperienceToggle(val),
            ),
          ),

          buildVolumeSlider(),

          buildCard(Icons.lock, 'Sign Out', tapAction: () => confirmSignout()),
          
          buildCard(Icons.edit_document, 'App Info', 
            tapAction: () => launchPopUp(context, Column(
              children: [
                Text("Privvy is a free app to generate color variations that compliments each other. The application makes api calls to an OpenCV Python endpoint that does the image generations, no fancy GAN models of some sort for now.", style: Device.screenType == ScreenType.tablet ? AppThemeConstants.APP_BODY_TEXT_LARGE : AppThemeConstants.APP_BODY_TEXT_MEDIUM,),

                const SizedBox(height: 10,),

                Text("Hence, a few glitches in certain colors could be discovered for some product images.", style: Device.screenType == ScreenType.tablet ? AppThemeConstants.APP_BODY_TEXT_LARGE : AppThemeConstants.APP_BODY_TEXT_MEDIUM,),

                const SizedBox(height: 10,),

                Text("You're a dev 🧑‍💻 ?, you can contribute to the generation source code on github 😺", style: Device.screenType == ScreenType.tablet ? AppThemeConstants.APP_BODY_TEXT_LARGE : AppThemeConstants.APP_BODY_TEXT_MEDIUM,),

                const SizedBox(height: 15,),
                
                TextButton(
                  child: Text(
                    "Visit my GitHub repository",
                    style: Device.screenType == ScreenType.tablet ? AppThemeConstants.APP_BODY_TEXT_LARGE : AppThemeConstants.APP_BODY_TEXT_MEDIUM,
                  ),
                  onPressed: () async {
                    const url = 'https://github.com/michealgabriel';
                    await launchUrl(Uri.parse(url));
                  },
                ),
              ],
            ))
          ),
          
          buildCard(Icons.cloud, 'App Updates', tapAction: () async => await launchUrl(Uri.parse('https://github.com/michealgabriel'))),

          buildCard(Icons.cancel_outlined, 'Delete Account', tapAction: () => handleDeleteAccount(), isRedGradient: true),

          const SizedBox(height: 100,),
        
      ],
    );
  }

  Widget buildCard(IconData radiusIcon, String tileText, {Function? tapAction, Widget? trailWidget, bool isRedGradient = false}) {
    return GestureDetector(
      onTap: () {
        if(trailWidget == null) tapAction!();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: isRedGradient ? AppThemeConstants.APP_CARD_GRADIENT_RED : AppThemeConstants.APP_CARD_GRADIENT,
          borderRadius: BorderRadius.circular(38)
        ),
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(radiusIcon, color: Colors.white, size: 28,),
                
                const SizedBox(width: 10,),
                Text(tileText, style: AppThemeConstants.APP_BODY_TEXT_REGULAR,),
    
              ],
            ),
            
            trailWidget ?? const Icon(Icons.arrow_forward_ios, color: Colors.white,),
          ],
        ),
      ),
    );
  }

  Widget buildVolumeSlider() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppThemeConstants.APP_CARD_GRADIENT,
        borderRadius: BorderRadius.circular(38)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      margin: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          const Icon(Icons.volume_up_rounded, color: Colors.white, size: 28,),

          Expanded(
            child: Slider(
              value: volumeSliderValue, 
              activeColor: const Color(0xff32D74B),
              min: 0.1,
              max: 1,
              divisions: 9,
              label: (volumeSliderValue * 100).round().toString(),
              onChanged: (double value) => handleVolumeSliderUpdate(value),
            ),
          ),
        ],
      ),
    );
  }
}