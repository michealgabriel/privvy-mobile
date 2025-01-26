
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:privvy/controllers/api_service.dart';
import 'package:privvy/controllers/auth_service.dart';
import 'package:privvy/controllers/database_service.dart';
import 'package:privvy/providers/privvy_generation_provider.dart';
import 'package:privvy/utils/app_material_navigator.dart';
import 'package:privvy/utils/app_constants.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/app_shared_widgets/others/content_loading_widget.dart';
import 'package:privvy/views/collections/single_collection.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Collections extends StatefulWidget {
  const Collections({super.key});

  @override
  State<Collections> createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {

  final TextEditingController _collectionNameController = TextEditingController();
  List<dynamic> collectionsList = [];
  List<String> collectionsKeyId = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 0), () {
      fetchCollections();
    });
  }

  fetchCollections() async {
    if(mounted) Provider.of<PrivvyGenerationProvider>(context, listen: false).setIsFetchingCollections(true);

    try {
        String authenticatedUserID = await AuthService.getLoggedInUserID();

        dynamic userCollectionsResponse = await DatabaseService.readTargetMultiRecord("${AppConstants.usersMetadataDBCollectionName}/$authenticatedUserID");

        // save and convert collections data to List
        collectionsList = (userCollectionsResponse as Map<String, dynamic>)["collections"].values.toList();

        // save collections key id's
        (userCollectionsResponse["collections"] as Map).forEach((key, _) => collectionsKeyId.add(key.toString()));

        // error response
        if (userCollectionsResponse.toString() == AppConstants.serverException || userCollectionsResponse.toString() == AppConstants.noDatabaseResults) {
          if(mounted) showAppToast(context, userCollectionsResponse.toString(), isError: true);
        }
        
        if(mounted) Provider.of<PrivvyGenerationProvider>(context, listen: false).setIsFetchingCollections(false);
    } 
    catch (_) {
      if(mounted) showAppToast(context, "Unable to fetch collections", isError: true);
    }

    if(mounted) Provider.of<PrivvyGenerationProvider>(context, listen: false).setIsFetchingCollections(false);
  }

  Future<bool> handleConfirmDelete(String collectionId) async {
    bool result = true;
    bool isTablet = Device.screenType == ScreenType.tablet;

    await launchPopUp(
      context, 
      Text('Are you sure you want to delete this collection?', style: isTablet ? AppThemeConstants.APP_BODY_TEXT_LARGE : AppThemeConstants.APP_BODY_TEXT_REGULAR,),
      actions: [
        TextButton(
          child: Text('Cancel', style:  isTablet ? AppThemeConstants.APP_BODY_TEXT_LARGE : AppThemeConstants.APP_BODY_TEXT_MEDIUM,),
          onPressed: () {
            Navigator.of(context).pop();
            result = false;
          },
        ),
        TextButton(
          child: Text('Yes', style:  isTablet ? AppThemeConstants.APP_BODY_TEXT_LARGE : AppThemeConstants.APP_BODY_TEXT_MEDIUM,),
          onPressed: () async {
            Navigator.of(context).pop();
            launchPopUp(context, const ContentLoadingWidget(), dismissible: false);

            String deleteResult = await deleteData(collectionId);
         
            if(deleteResult == AppConstants.generalSuccessMessageKey) {
              if(mounted) showAppToast(context, "Collection deleted");
            }else {
              if(mounted) showAppToast(context, deleteResult, isError: true);
            }

            if(mounted) Navigator.of(context).pop();
          },
        ),
      ],
      dismissible: false
    );

    return result;
  }

  Future<bool> handleConfirmEdit(int index, String collectionId, String collectionName) async {
    bool result = false;
    bool isTablet = Device.screenType == ScreenType.tablet;
    _collectionNameController.text = collectionName;

    await launchPopUp(
      context,
      Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Edit collection Name', textAlign: TextAlign.start, style: AppThemeConstants.APP_BODY_TEXT_REGULAR,),
                const SizedBox(height: 10,),
                TextField(
                  controller: _collectionNameController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: AppThemeConstants.APP_TEXTFIELD_OUTLINE_BORDER,
                    focusedBorder: AppThemeConstants.APP_TEXTFIELD_FOCUSED_BORDER,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
          child: Text('Cancel', style: isTablet ? AppThemeConstants.APP_BODY_TEXT_LARGE : AppThemeConstants.APP_BODY_TEXT_MEDIUM,),
          onPressed: () {
            Navigator.of(context).pop();
            result = false;
          },
        ),
        TextButton(
          child: Text('Save', style: isTablet ? AppThemeConstants.APP_BODY_TEXT_LARGE : AppThemeConstants.APP_BODY_TEXT_MEDIUM,),
          onPressed: () async {

            // launch loader
            launchPopUp(context, const ContentLoadingWidget(), dismissible: true);
            
            if(_collectionNameController.text.isNotEmpty) {
              String authenticatedUserID = await AuthService.getLoggedInUserID();
              Map<String, dynamic> updateData = {"name": _collectionNameController.text};
              await DatabaseService.updateRecord("${AppConstants.usersMetadataDBCollectionName}/$authenticatedUserID/collections/$collectionId", updateData);
              collectionsList[index]["name"] = _collectionNameController.text;
            }

            if(mounted) {
              Navigator.of(context).pop(); // close save modal
              Navigator.of(context).pop(); // close loader
            }
            result = false;
          },
        ),
      ],
      dismissible: false
    );

    if(mounted) setState((){});
    return result;
  }

  deleteData(String collectionId) async {
    String deleteResult = "";
    String authenticatedUserID = await AuthService.getLoggedInUserID();
    bool storageDeleteFlag = await ApiService().callDeleteVariationsApi(collectionId);

    if(storageDeleteFlag) {
      deleteResult = await DatabaseService.deleteRecord("${AppConstants.usersMetadataDBCollectionName}/$authenticatedUserID/collections", collectionId);
    }

    return deleteResult;
  }

  IconData determineCategoryIconData(String category) {
    if(category == "Shoes") return Icons.rocket_launch;
    if(category == "Bags") return Iconsax.shopping_bag5;
    if(category == "Clothes") return Icons.style_rounded;
    return Icons.pending_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeConstants.APP_BG_DARK,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppThemeConstants.APP_BG_DARK,
        shadowColor: AppThemeConstants.APP_BG_DARK,
        title: const Text("Collections", style: AppThemeConstants.APP_HEADING_TEXT_SMALL,),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Iconsax.arrow_left, color: Colors.white, size: 30,)),
      ),

      body: context.watch<PrivvyGenerationProvider>().isFetchingCollections
        // ! --------- LOADER WIDGET
        ? const Center(
          child: ContentLoadingWidget(),
        )
        // ! --------- NO COLLECTIONS WIDGET
        : collectionsList.isEmpty ? Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.only(top: 180),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_stories_rounded, size: 56, color: Colors.white,),
                SizedBox(height: 5,),
                Text("No collections", style: AppThemeConstants.APP_BODY_TEXT_MEDIUM,),
              ],
            ),
          ),
        )
        // ! --------- COLLECTIONS LIST WIDGET
        : SingleChildScrollView(
        padding: EdgeInsets.all(Device.screenType == ScreenType.tablet ? AppThemeConstants().APP_TABLET_BASE_CONTENT_PADDING : AppThemeConstants().APP_BASE_CONTENT_PADDING),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 15,),

            ListView.builder(
              shrinkWrap: true,
              itemCount: collectionsList.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(collectionsKeyId[index]),
                  confirmDismiss: (direction) async {
                    if(direction == DismissDirection.endToStart) return await handleConfirmDelete(collectionsKeyId[index]);
                    if(direction == DismissDirection.startToEnd) return await handleConfirmEdit(index, collectionsKeyId[index], collectionsList[index]["name"].toString());
                    return false;
                  },
                  onDismissed: (direction) {
                    setState(() {
                      collectionsList.removeAt(index);
                      collectionsKeyId.removeAt(index);
                    });
                  },
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Iconsax.trash, color: Colors.white, size: 40,),
                  ),
                  background: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Iconsax.edit_2, color: Colors.white, size: 40,),
                  ),
                  child: GestureDetector(
                    onTap: () => appNavigate(context, SingleCollection(collectionName: collectionsList[index]["name"].toString(), images: collectionsList[index]["images"])),
                    child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: CachedNetworkImage(
                              imageUrl: collectionsList[index]["images"][0], 
                              width: 100, height: 100, 
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const CupertinoActivityIndicator(radius: 12, color: AppThemeConstants.APP_BASE_TEXT_COLOR_DIM_2,),
                            ),
                          ),
                                    
                          const SizedBox(width: 20,),
                                    
                          Wrap(
                            direction: Axis.vertical,
                            spacing: 8,
                            children: [
                              Text(collectionsList[index]["name"].toString(), style: AppThemeConstants.APP_BODY_TEXT_LARGE,),
                              Row(
                                children: [
                                  Icon(determineCategoryIconData(collectionsList[index]["category"].toString()), size: 22, color: AppThemeConstants.APP_BASE_TEXT_COLOR_DIM_2,),
                                  const SizedBox(width: 5,),
                                  Text("${collectionsList[index]["images"].length} (items)", style: AppThemeConstants.APP_BODY_TEXT_REGULAR,),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }, 
            ),

            const SizedBox(height: 120,),

          ],
        ),
      ),
    );
  }
}