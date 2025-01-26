import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:privvy/controllers/auth_service.dart';
import 'package:privvy/controllers/database_service.dart';
import 'package:privvy/utils/app_constants.dart';
import 'package:privvy/utils/app_material_navigator.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/app_shared_widgets/buttons/app_button_wide.dart';
import 'package:privvy/views/app_shared_widgets/others/content_loading_widget.dart';


class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key,});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {

  final TextEditingController _reasonController = TextEditingController();

  handleDeleteAccount() async {
    if(_reasonController.text.isEmpty) {
      showAppToast(context, "Please enter a reason for deletion", isError: true);
      return;
    }

    try {
      // launch loader
      launchPopUp(context, const ContentLoadingWidget(), dismissible: true);
      
      if(_reasonController.text.isNotEmpty) {
        String authenticatedUserID = await AuthService.getLoggedInUserID();
        Map<String, dynamic> updateData = {
          "deleteAccountRequested": true, 
          "deleteAccountReason": _reasonController.text
        };
        await DatabaseService.updateRecord("${AppConstants.usersMetadataDBCollectionName}/$authenticatedUserID", updateData);

        Navigator.pop(context); // close loader
        showAppToast(context, "your delete request has been received.");
      }
    } catch (e) {
        Navigator.pop(context); // close loader
        showAppToast(context, AppConstants.generalFailedMessageKey, isError: true);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeConstants.APP_PRIMARY_COLOR,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppThemeConstants.APP_PRIMARY_COLOR,
        shadowColor: AppThemeConstants.APP_PRIMARY_COLOR,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Iconsax.arrow_left, color: Colors.white, size: 30,)),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 120,),
      
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppThemeConstants().APP_BASE_CONTENT_PADDING),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text("Delete account", overflow: TextOverflow.clip, style: AppThemeConstants.APP_HEADING_TEXT),
                ),
                // SizedBox(height: 6,),
                Text("Please state your reason for account deletion.", overflow: TextOverflow.clip,
                  style: AppThemeConstants.APP_BODY_TEXT_SMALL
                ),
              ],
            ),
          ), 
      
          const SizedBox(height: 24,),
      
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppThemeConstants().APP_BASE_CONTENT_PADDING),
              decoration: const BoxDecoration(
                color: AppThemeConstants.APP_BG_DARK,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
      
                    const SizedBox(height: 35,),
          
                    TextField(
                      controller: _reasonController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.name,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: AppThemeConstants.APP_TEXTFIELD_OUTLINE_BORDER,
                        focusedBorder: AppThemeConstants.APP_TEXTFIELD_FOCUSED_BORDER,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        hintText: 'Type in your message here',
                        hintStyle: AppThemeConstants().APP_TEXTFIELD_HINT,
                      ),
                      cursorColor: AppThemeConstants.APP_PRIMARY_COLOR,
                      style: AppThemeConstants.APP_BODY_TEXT_REGULAR,
                    ),
      
                    const SizedBox(height: 30,),
      
                    AppButtonWide(buttonText: "Confirm", disabled: false, callback: () => handleDeleteAccount()),
      
                    const SizedBox(height: 60,),
                    
      
                  ],
                ),
              ),
            ),
          ),
      
        ],
      ),
    );
  }
}