import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:privvy/controllers/api_service.dart';
import 'package:privvy/controllers/auth_service.dart';
import 'package:privvy/controllers/database_service.dart';
import 'package:privvy/models/generation_response_model.dart';
import 'package:privvy/providers/privvy_generation_provider.dart';
import 'package:privvy/providers/timer_countdown_provider.dart';
import 'package:privvy/utils/app_logger.dart';
import 'package:privvy/utils/app_material_navigator.dart';
import 'package:privvy/utils/app_constants.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/app_shared_widgets/others/content_loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrivvyScreen extends StatefulWidget {
  final String autoID;
  final String imageName;
  final String category;
  const PrivvyScreen(
      {super.key,
      required this.autoID,
      required this.imageName,
      required this.category});

  @override
  State<PrivvyScreen> createState() => _PrivvyScreenState();
}

class _PrivvyScreenState extends State<PrivvyScreen> {
  final constpad = AppThemeConstants().APP_BASE_CONTENT_PADDING;
  final TextEditingController _collectionNameController =
      TextEditingController();

  int? selectedColorIndex;
  double privvyImageRadius = 180;
  double tabletPrivvyImageRadius = 250;
  double containerPreviewSize = 110;
  double tabletContainerPreviewSize = 160;
  GenerationResponseModel generationResponse = GenerationResponseModel(
      message: '', colors: [], images: [], imageUrls: []);

  Color _walkBoxColor = Colors.transparent;
  double _containerBoxHeight = 100;
  Color _containerBoxColor = Colors.transparent;
  int waitSeconds = 80;
  bool showTimer = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 0), () {
      initializeTimer();
      callGenerateVariationsApi();
    });

    Future.delayed(const Duration(seconds: 3), () {
      _containerBoxColor = AppThemeConstants.APP_PRIMARY_COLOR;
      setState(() {});
    });

    Future.delayed(const Duration(seconds: 5), () {
      _containerBoxHeight = 200;
      setState(() {});
    });
  }

  void initializeTimer() {
    context.read<TimerCountdownProvider>().resetTimer();
    context.read<TimerCountdownProvider>().setTotalTimerSeconds(waitSeconds);
    context
        .read<TimerCountdownProvider>()
        .setTimerEndCallback(onTimerEndCallback);
    context.read<TimerCountdownProvider>().invokeCountdownTimer();
  }

  void onTimerEndCallback() {
    AppLogger().log(Level.warning, "Timer ended");
    _walkBoxColor = Colors.red;
    showTimer = false;
    if (mounted) setState(() {});
  }

  callGenerateVariationsApi() async {
    try {
      generationResponse = await ApiService()
          .callGenerateVariationsApi(widget.autoID, widget.imageName);

      if (mounted) {
        selectedColorIndex = 0;
        Provider.of<PrivvyGenerationProvider>(context, listen: false)
            .setIsCallingGenerateAPI(false);
        Provider.of<TimerCountdownProvider>(context, listen: false).stopTimer();
      }
    } catch (e) {
      if (mounted) {
        showAppToast(context, e.toString(), isError: true);
        Navigator.pop(context); // close screen
      }
    }
  }

  Future<bool> _onLoadingWillPop() async {
    bool result = false;
    bool isTablet = Device.screenType == ScreenType.tablet;

    await launchPopUp(
        context,
        const Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exit screen and move task to background?',
                  textAlign: TextAlign.start,
                  style: AppThemeConstants.APP_BODY_TEXT_REGULAR,
                ),
                // SizedBox(height: 10,),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: isTablet
                  ? AppThemeConstants.APP_BODY_TEXT_LARGE
                  : AppThemeConstants.APP_BODY_TEXT_MEDIUM,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              result = false;
            },
          ),
          TextButton(
            child: Text(
              'Exit',
              style: isTablet
                  ? AppThemeConstants.APP_BODY_TEXT_LARGE
                  : AppThemeConstants.APP_BODY_TEXT_MEDIUM,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              showAppToast(context, "Generation running in background...");
              result = true;
            },
          ),
        ],
        dismissible: true);

    return result;
  }

  Future<bool> _onWillPop() async {
    bool result = false;
    bool isTablet = Device.screenType == ScreenType.tablet;

    await launchPopUp(
        context,
        Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Collection Name',
                    textAlign: TextAlign.start,
                    style: AppThemeConstants.APP_BODY_TEXT_REGULAR,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _collectionNameController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: AppThemeConstants.APP_TEXTFIELD_OUTLINE_BORDER,
                      focusedBorder:
                          AppThemeConstants.APP_TEXTFIELD_FOCUSED_BORDER,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 20),
                      hintText: 'My Jordans 👟🏀',
                      hintStyle: AppThemeConstants().APP_TEXTFIELD_HINT,
                    ),
                    cursorColor: AppThemeConstants.APP_PRIMARY_COLOR,
                    style: AppThemeConstants.APP_BODY_TEXT_REGULAR,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: isTablet
                  ? AppThemeConstants.APP_BODY_TEXT_LARGE
                  : AppThemeConstants.APP_BODY_TEXT_MEDIUM,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              result = false;
            },
          ),
          TextButton(
            child: Text(
              'Save & Exit',
              style: isTablet
                  ? AppThemeConstants.APP_BODY_TEXT_LARGE
                  : AppThemeConstants.APP_BODY_TEXT_MEDIUM,
            ),
            onPressed: () async {
              // launch loader
              launchPopUp(context, const ContentLoadingWidget(),
                  dismissible: true);

              if (_collectionNameController.text.isNotEmpty) {
                String authenticatedUserID =
                    await AuthService.getLoggedInUserID();
                Map<String, dynamic> updateData = {
                  "name": _collectionNameController.text,
                  "category": widget.category
                };
                await DatabaseService.updateRecord(
                    "${AppConstants.usersMetadataDBCollectionName}/$authenticatedUserID/collections/${widget.autoID}",
                    updateData);
              }

              if (mounted) {
                Navigator.of(context).pop(); // close save modal
                Navigator.of(context).pop(); // close loader
              }
              result = true;
            },
          ),
        ],
        dismissible: true);

    return result;
  }

  handleColorPrivvy(int index) async {
    if (selectedColorIndex != index) {
      selectedColorIndex = index;

      privvyImageRadius = 0;
      setState(() {});

      await Future.delayed(const Duration(milliseconds: 300));

      privvyImageRadius = 180;
      setState(() {});
    }
  }

  Color hexTransform(int indexPosition) {
    return Color(int.parse(
        generationResponse.colors[indexPosition].replaceAll('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(context.select<TimerCountdownProvider, int>(
        (provider) => provider.myDuration.inMinutes.remainder(60)));
    final seconds = strDigits(context.select<TimerCountdownProvider, int>(
        (provider) => provider.myDuration.inSeconds.remainder(60)));

    return WillPopScope(
      onWillPop: () {
        if (context.read<PrivvyGenerationProvider>().isCallingGenerateAPI)
          return _onLoadingWillPop();
        return _onWillPop();
      },
      // onWillPop: () async => true,

      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppThemeConstants.APP_BG_DARK,
        body: context.watch<PrivvyGenerationProvider>().isCallingGenerateAPI
            // ! --------- LOADER WIDGET
            ? Center(
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: double.infinity,
                    height: _containerBoxHeight,
                    color: _containerBoxColor,
                    margin: const EdgeInsets.only(bottom: 120),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            color: _walkBoxColor,
                            child: Lottie.asset('assets/lotties/walk.json',
                                animate: true)),
                        showTimer
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$minutes : $seconds',
                                    style: AppThemeConstants.APP_HEADING_TEXT_2,
                                  ),
                                  const Text(
                                    "Estimated Time",
                                    style:
                                        AppThemeConstants.APP_BODY_TEXT_SMALL,
                                  ),
                                ],
                              )
                            : const Flexible(
                                child: Text(
                                "🤔 Taking longer than expected...",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                style: AppThemeConstants.APP_BODY_TEXT_LARGE,
                              )),
                      ],
                    )),
              )
            // ! --------- MAIN CONTENT WIDGET
            : Container(
                padding: EdgeInsets.all(Device.screenType == ScreenType.tablet
                    ? AppThemeConstants().APP_TABLET_BASE_CONTENT_PADDING
                    : 0),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: const [0.0, 0.45],
                  colors: [
                    selectedColorIndex == null
                        ? AppThemeConstants.APP_BG_DARK
                        : hexTransform(selectedColorIndex!),
                    AppThemeConstants.APP_BG_DARK,
                  ],
                )),
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      child: Center(
                        child: CircleAvatar(
                          radius: Device.screenType == ScreenType.tablet
                              ? tabletPrivvyImageRadius
                              : privvyImageRadius,
                          backgroundColor: AppThemeConstants.APP_CARD_BG_DARK,
                          backgroundImage: NetworkImage(generationResponse
                              .imageUrls[selectedColorIndex ?? 0]),
                        ),
                      ),
                    ),
                    Container(
                      height: Device.screenType == ScreenType.tablet
                          ? tabletContainerPreviewSize
                          : containerPreviewSize,
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(bottom: 70),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: generationResponse.colors.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => handleColorPrivvy(index),
                            child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: selectedColorIndex == index
                                        ? AppThemeConstants.APP_PRIMARY_COLOR
                                        : Colors.transparent),
                                padding: const EdgeInsets.all(6),
                                margin: index == 0
                                    ? const EdgeInsets.only(left: 30)
                                    : index == generationResponse.colors.length
                                        ? const EdgeInsets.only(right: 30)
                                        : null,
                                child: Container(
                                  width: Device.screenType == ScreenType.tablet
                                      ? tabletContainerPreviewSize
                                      : containerPreviewSize,
                                  height: Device.screenType == ScreenType.tablet
                                      ? tabletContainerPreviewSize
                                      : containerPreviewSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        generationResponse.imageUrls[index],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    color: hexTransform(index),
                                  ),
                                )),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
