
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:privvy/controllers/auth_service.dart';
import 'package:privvy/controllers/database_service.dart';
import 'package:privvy/controllers/storage_service.dart';
import 'package:privvy/providers/music_provider.dart';
import 'package:privvy/providers/privvy_generation_provider.dart';
import 'package:privvy/providers/profile_provider.dart';
import 'package:privvy/utils/app_material_navigator.dart';
import 'package:privvy/utils/app_shared_pref_handlers.dart';
import 'package:privvy/utils/app_constants.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/app_shared_widgets/others/content_loading_widget.dart';
import 'package:privvy/views/app_shared_widgets/others/profile_image_avatar.dart';
import 'package:privvy/views/authentication/login.dart';
import 'package:privvy/views/collections/collections.dart';
import 'package:privvy/views/home/widgets/privvy_collections_stack.dart';
import 'package:privvy/views/home/widgets/privvy_item_stack.dart';
import 'package:privvy/views/privvy_screen/privvy_screen.dart';
import 'package:privvy/views/profile/profile.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final EdgeInsetsGeometry cardPaddings = const EdgeInsets.symmetric(vertical: 25, horizontal: 12);
  final Duration imagesFadeInDuration = const Duration(milliseconds: 170);
  bool chillExperienceStatus = true;
  double volumeStatus = 0.1;
  
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    (() async {
      if(await AuthService.isLoggedIn() == false) {
        if(mounted) appNavigate(context, const Login(), isPushReplace: true);
      }
      
      chillExperienceStatus = await AppSPHandlers().getBoolSP(AppSPHandlers.CHILL_EXPERIENCE_STATUS) ?? true;
      volumeStatus = await AppSPHandlers().getDoubleSP(AppSPHandlers.VOLUME_SLIDER_VALUE) ?? 0.1;

      if(mounted) {
        Provider.of<MusicProvider>(context, listen: false).initializeMusics(initVolume: volumeStatus);
        if(chillExperienceStatus) Provider.of<MusicProvider>(context, listen: false).pauseOrPlayMusic();
      }
    })();
  }

  handleCollectionsNavigate() async {
    appNavigate(context, const Collections());
  }

  handleMusicPauseOrPlay() {
    context.read<MusicProvider>().pauseOrPlayMusic();

    Navigator.pop(context);
    launchMusicSheet();
  }

  launchMusicSheet() {
    final playlistMetaData = context.read<MusicProvider>().playlistMetaData;
    final player = context.read<MusicProvider>().player;

    launchBottomSheet(context, 
      Animate(
        autoPlay: true,
        onComplete: (controller) => controller.repeat(),
        effects: [
          ShimmerEffect(
            size: 0.5, 
            color: Colors.white.withAlpha(45), 
            curve: Curves.slowMiddle, 
            duration: const Duration(seconds: 1), 
            delay: const Duration(seconds: 2)
          )
        ],
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/gifs/musicplaygif.gif'),
              fit: BoxFit.fitWidth,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset("assets/thumbnails/${playlistMetaData[player.currentIndex!][0]}", width: 85, height: 85,)
                  ),
      
                  const SizedBox(width: 15,),
                  
                  Wrap(
                    direction: Axis.vertical,
                    children: [
                      Text(playlistMetaData[player.currentIndex!][1], style: AppThemeConstants.APP_BODY_TEXT_LARGE,),
                      Text(playlistMetaData[player.currentIndex!][2], style: AppThemeConstants.APP_BODY_TEXT_REGULAR,)
                    ],
                  )
                ],
              ),
      
              GestureDetector(
                onTap: () => handleMusicPauseOrPlay(),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  // padding: const EdgeInsets.all(2),
                  child: Icon(player.playing ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded, size: 54, color: Colors.black,)
                ),
              )
            ],
          ),
        ),
      ), 
      false, displayNotch: false, fixedHeight: 130
    );
  }
  
  Future<bool> _onWillPop() async {
    bool result = false;
    bool isTablet = Device.screenType == ScreenType.tablet;

    await launchPopUp(
      context,
      Text('You sure you wanna exit privvy?', textAlign: TextAlign.start, style: isTablet ? AppThemeConstants.APP_BODY_TEXT_LARGE : AppThemeConstants.APP_BODY_TEXT_REGULAR,),
      actions: [
        TextButton(
          child: Text('No', style: isTablet ? AppThemeConstants.APP_BODY_TEXT_LARGE : AppThemeConstants.APP_BODY_TEXT_MEDIUM,),
          onPressed: () {
            Navigator.of(context).pop();
            result = false;
          },
        ),
        TextButton(
          child: Text('Hmnn, yea', style: isTablet ? AppThemeConstants.APP_BODY_TEXT_LARGE : AppThemeConstants.APP_BODY_TEXT_MEDIUM,),
          onPressed: () {
            // Perform your action here
            Platform.isIOS ? FlutterExitApp.exitApp(iosForceExit: true) : FlutterExitApp.exitApp();
            
            // Navigator.of(context).pop();
            // result = true;
          },
        ),
      ],
      dismissible: false
    );

    return result;
  }

  handleImageChooseOrCapture(String type, String category) async {
    String authenticatedUserID = await AuthService.getLoggedInUserID();
    XFile? image = await picker.pickImage(source: type == 'camera' ? ImageSource.camera : ImageSource.gallery);

    if(image != null) {
      File imageFile = File(image.path);
      int maxSizeBytes =  1 * 1024 * 1024; //  1MB in bytes

      // ! check image size
      if (await imageFile.length() > maxSizeBytes) {
        if(mounted) {
          Navigator.pop(context);  // close sheet
          showAppToast(context, "Image size exceeds 1MB. Choose a smaller image", isError: true);
        }
        return; // Exit the method early if the image is too large
      }

      // ! >>> continue with process
      if(mounted) {
        Navigator.pop(context);  // close sheet
        launchPopUp(context, const ContentLoadingWidget(), dismissible: true);
      }

      // ! check collections count
      dynamic result = await DatabaseService.readSingleRecord(AppConstants.usersMetadataDBCollectionName, authenticatedUserID);
      final resultMap = result as Map;
      if(resultMap["collections"] != null && resultMap["collections"].length > (AppConstants.maxCollectionsCount - 1)) {
        if(mounted) {
          Navigator.pop(context);  // close sheet
          showAppToast(context, "Cannot have more than ${AppConstants.maxCollectionsCount} collections. Delete some", isError: true);
        }
        return; // Exit the method early if collections count is more than 5
      }

      // ! upload init image to storage
      String response = await StorageService().uploadInitPrivvyImage(image);
      if(response != AppConstants.serverException)
      {
        List<String> responseStringSplit = response.split("/");

        // ! immediately update collection category and name
        Map<String, dynamic> updateData = {"category": category};
        await DatabaseService.updateRecord("${AppConstants.usersMetadataDBCollectionName}/$authenticatedUserID/collections/${responseStringSplit[0]}", updateData);

        // ! navigate to privvy screen
        if(mounted) {
          Navigator.pop(context);
        
          context.read<PrivvyGenerationProvider>().setIsCallingGenerateAPI(true);
          appNavigate(context, PrivvyScreen(autoID: responseStringSplit[0], imageName: responseStringSplit[1], category: category,));
        } 
      }
    }
  }

  launchSourceSelectionSheet({required String category}) {
    launchBottomSheet(context, Column(
      children: [

        ListTile(
          onTap: () => handleImageChooseOrCapture('camera', category),
          leading: const Icon(Icons.camera_alt_rounded, size: 30,),
          title: const Text("Camera", style: AppThemeConstants.APP_BODY_TEXT_REGULAR,),
        ),

        const SizedBox(height: 5,),

        ListTile(
          onTap: () => handleImageChooseOrCapture('gallery', category),
          leading: const Icon(Icons.collections_rounded, size: 30,),
          title: const Text("Gallery", style: AppThemeConstants.APP_BODY_TEXT_REGULAR,),
        ),
      ],
    ), false, fixedHeight: 220);
  }


  @override
  Widget build(BuildContext context) {

    String userNickname = context.watch<ProfileProvider>().userNicknameValue;
    String storedChosenAvatar = context.watch<ProfileProvider>().privvyAvatarValue;

    final List<Widget> privvyCardItems = [
      PrivvyItemStack(
        title: "Privvi-fy Shoes", 
        subtitle: "Reccommend shoe variations", 
        iconData: Icons.rocket_launch_rounded, 
        imagePath: "assets/images/nikeadapt1.png", 
        imageWH: 410, 
        imagePositionedTopValue: -155, 
        imagePositionedLeftValue: Device.screenType == ScreenType.tablet ? -15 : -35, 
        imageRotatedAngle: -0.08, 
        cardAnimationDelay: 2,
        imageAnimationDelay: 3, 
        callback: () => launchSourceSelectionSheet(category: "Shoes"), 
        inConstruction: false,
      ),
      PrivvyItemStack(
        title: "Privvi-fy Bags", 
        subtitle: "Reccommend bag variations", 
        iconData: Iconsax.shopping_bag5, 
        imagePath: "assets/images/bag.png", 
        imageWH: 250, 
        imagePositionedTopValue: -85, 
        imagePositionedLeftValue: Device.screenType == ScreenType.tablet ? 60 : 40, 
        imageRotatedAngle: -0.01, 
        cardAnimationDelay: 4,
        imageAnimationDelay: 4, 
        callback: () => launchSourceSelectionSheet(category: "Bags"), 
        inConstruction: false,
      ),
      PrivvyItemStack(
        title: "Privvi-fy Clothes", 
        subtitle: "Reccommend clothing variations", 
        iconData: Icons.style_rounded, 
        imagePath: "assets/images/cloth.png", 
        imageWH: 270, 
        imagePositionedTopValue: -110, 
        imagePositionedLeftValue: Device.screenType == ScreenType.tablet ? 60 : 40, 
        imageRotatedAngle: -0.01, 
        cardAnimationDelay: 4,
        imageAnimationDelay: 5, 
        callback: () => launchSourceSelectionSheet(category: "Clothes"), 
        inConstruction: false,
      ),
      PrivvyItemStack(
        title: "Privvy Anything", 
        subtitle: "Reccommend anything",
        iconData: Icons.search_rounded, 
        imagePath: "assets/images/anything.png", 
        imageWH: 285, 
        imagePositionedTopValue: -110, 
        imagePositionedLeftValue: Device.screenType == ScreenType.tablet ? 40 : 20, 
        imageRotatedAngle: -0.01, 
        cardAnimationDelay: 4,
        imageAnimationDelay: 6, 
        callback: () => launchSourceSelectionSheet(category: ""), 
        inConstruction: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppThemeConstants.APP_BG_DARK,

      floatingActionButton: Transform.translate(
        offset: const Offset(-15, -10),
        child: Animate(
          autoPlay: true,
          delay: const Duration(seconds: 5),
          effects: const [FadeEffect(duration: Duration(seconds: 1)), ShakeEffect()],
          child: Container(     // effect dark container
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppThemeConstants.APP_CARD_BG_DARK
            ),
            padding: const EdgeInsets.all(12),
            child: Animate(     // effect widget
              autoPlay: true,
              effects: const [
                ShimmerEffect(),
                ScaleEffect(begin: Offset(1.1, 1.1), end: Offset(1.3, 1.3), duration: Duration(seconds: 1)),
              ],
              onComplete: (controller) => controller.repeat(reverse: true),
              child: GestureDetector(
                onTap: () => launchMusicSheet(),
                child: Container(
                  width: Device.screenType == ScreenType.tablet ? 95 : 65,
                  height: Device.screenType == ScreenType.tablet ? 95 : 65,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/gifs/beatgif.gif'),
                      fit: BoxFit.fitWidth,
                    ),
                    shape: BoxShape.circle
                  ),
                  // child: const Icon(Iconsax.headphone5, color: Colors.white, size: 52,)
                ),
              ),
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppThemeConstants().APP_BASE_CONTENT_PADDING - 5),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
      
              const SizedBox(height: 50,),
      
              // ! -------------- Header ----------------- //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => appNavigate(context, const Profile()),
                        child: ProfileImageAvatar(
                          imagePath: "assets/avatars/$storedChosenAvatar.png", 
                          isLocalImage: true, 
                          radius: Device.screenType == ScreenType.tablet ? 50 : 30, 
                          paintBackground: true,
                        )
                      ),
                      
                      const SizedBox(width: 15,),
      
                      Wrap(
                        direction: Axis.vertical,
                        children: [
                          const Text("Welcome", style: AppThemeConstants.APP_BODY_TEXT_REGULAR,),
                          Text(userNickname, style: AppThemeConstants.APP_BODY_TEXT_LARGE,),
                        ],
                      ),
                    ],
                  ),
              
                  IconButton(
                    icon: Icon(Icons.bookmarks_rounded, color: Colors.white, size: Device.screenType == ScreenType.tablet ? 40 : 30,),
                    onPressed: () => handleCollectionsNavigate(), 
                  )
                ],
              ),
      
      
              const SizedBox(height: 50,),
      
      
              // ! -------------- Header Card ----------------- //
              
              Device.screenType == ScreenType.tablet ?
              Column(
                children: [
                  Container(
                    width: 500,
                    margin: const EdgeInsets.only(bottom: 120),
                    child: const PrivvyCollectionsStack()
                  ),

                  GridView.count(
                    shrinkWrap: true,
                    mainAxisSpacing: 10,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    crossAxisSpacing: 15,
                    crossAxisCount: 2,
                    childAspectRatio: 1,  
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(4, (index) { 
                        return Container(
                          child: privvyCardItems[index]
                        );
                      }
                    )
                  ),
                ],
              )
              :
              Column(
                children: [
                  Container(
                    width: 500,
                    margin: const EdgeInsets.only(bottom: 120),
                    child: const PrivvyCollectionsStack()
                  ),

                  // shoes
                  Container(
                    margin: const EdgeInsets.only(bottom: 120),
                    child: privvyCardItems[0]
                  ),
                  // bags
                  Container(
                    margin: const EdgeInsets.only(bottom: 160),
                    child: privvyCardItems[1]
                  ),
                  // clothes
                  Container(
                    margin: const EdgeInsets.only(bottom: 100),
                    child: privvyCardItems[2]
                  ),
                  // anything
                  Container(
                    margin: const EdgeInsets.only(bottom: 160),
                    child: privvyCardItems[3]
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}