import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:privvy/utils/app_material_navigator.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/collections/single_collection_image.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SingleCollection extends StatefulWidget {
  final String collectionName;
  final List<dynamic> images;
  const SingleCollection(
      {super.key, required this.images, required this.collectionName});

  @override
  State<SingleCollection> createState() => _SingleCollectionState();
}

class _SingleCollectionState extends State<SingleCollection> {
  final constpad = AppThemeConstants().APP_BASE_CONTENT_PADDING;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeConstants.APP_BG_DARK,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppThemeConstants.APP_BG_DARK,
        title: Text(
          widget.collectionName,
          style: AppThemeConstants.APP_HEADING_TEXT_SMALL,
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Iconsax.arrow_left,
              color: Colors.white,
              size: 30,
            )),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(constpad - 5),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
                shrinkWrap: true,
                mainAxisSpacing: constpad,
                padding: const EdgeInsets.symmetric(vertical: 20),
                crossAxisSpacing: constpad - 5,
                crossAxisCount: Device.screenType == ScreenType.tablet ? 3 : 2,
                childAspectRatio: 0.8,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(widget.images.length, (index) {
                  return GestureDetector(
                    onTap: () => appNavigate(
                        context,
                        SingleCollectionImage(
                          image: widget.images[index],
                          collectionName: widget.collectionName,
                        )),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: CachedNetworkImage(
                        imageUrl: widget.images[index].toString(),
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CupertinoActivityIndicator(
                          radius: 12,
                          color: AppThemeConstants.APP_BASE_TEXT_COLOR_DIM_2,
                        ),
                      ),
                    ),
                  );
                })),
            const SizedBox(
              height: 120,
            ),
          ],
        ),
      ),
    );
  }
}
