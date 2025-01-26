

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:privvy/utils/app_material_navigator.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/app_shared_widgets/others/content_loading_widget.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:http/http.dart' as http;
// import 'package:share_plus/share_plus.dart';

class SingleCollectionImage extends StatefulWidget {
  final String image;
  final String collectionName;
  const SingleCollectionImage({super.key, required this.image, required this.collectionName});

  @override
  State<SingleCollectionImage> createState() => _SingleCollectionImageState();
}

class _SingleCollectionImageState extends State<SingleCollectionImage> {

  final constpad = AppThemeConstants().APP_BASE_CONTENT_PADDING;

  handleShareImage() async {
    launchPopUp(context, const ContentLoadingWidget(), dismissible: false);

    // ! Share Action
    String urlImageToDeviceFilePath = await saveUrlImage(widget.image, widget.collectionName);

    Uint8List imageBytes = await loadDeviceImageAsBytes(urlImageToDeviceFilePath);

    ShareFilesAndScreenshotWidgets().shareFile(
      "Privvy", "${widget.collectionName}.jpg", imageBytes, "image/jpeg",
      text: "Check out my slick privvy generated shoe 😋"
    );

    if(mounted) Navigator.pop(context);
  }

  Future<String> saveUrlImage(String urlImage, String fileName) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    http.Response response = await http.get(Uri.parse(urlImage));

    if (response.statusCode ==  200) {
      File file = File('$tempPath/$fileName');
      await file.writeAsBytes(response.bodyBytes);

      return file.path;
    } else {
      throw Exception('Failed to download image');
    }
  }

  Future<Uint8List> loadDeviceImageAsBytes(String path) async {
    File imageFile = File(path);
    Uint8List bytes = await imageFile.readAsBytes();
    return bytes;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeConstants.APP_BG_DARK,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppThemeConstants.APP_BG_DARK,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Iconsax.arrow_left, color: Colors.white, size: 30,)),
        actions: [
          IconButton(onPressed: () => handleShareImage(), icon: const Icon(Icons.share_outlined, color: Colors.white, size: 28,)),
          const SizedBox(width: 10,)
        ],
      ),

      body: Center(
        child: CachedNetworkImage(imageUrl: widget.image,)
      ),
    );
  }
}