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
import 'package:privvy/views/home/home.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UsernameSetup extends StatefulWidget {
  final bool isFreshSetup;
  const UsernameSetup({super.key, required this.isFreshSetup});

  @override
  State<UsernameSetup> createState() => _UsernameSetupState();
}

class _UsernameSetupState extends State<UsernameSetup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final FocusNode _nicknameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nicknameController.text =
        context.read<ProfileProvider>().userNicknameValue;
  }

  handleFreshTap() async {
    _nicknameFocusNode.unfocus();

    if (_formKey.currentState!.validate()) {
      AppSPHandlers().setStringSP(
          AppSPHandlers.USER_NICKNAME, _nicknameController.text.trim());
      context
          .read<ProfileProvider>()
          .setUserNicknameValue(_nicknameController.text.trim());
      bool updateResult = await handleUserMetadataUpdateOperation();

      if (widget.isFreshSetup && updateResult) {
        if (mounted) appNavigate(context, const Home());
      } else {
        if (mounted) Navigator.pop(context, 'refresh');
      }
    }
  }

  Future<bool> handleUserMetadataUpdateOperation() async {
    launchPopUp(context, ContentLoadingWidget(), dismissible: false);

    String authenticatedUserID = await AuthService.getLoggedInUserID();
    Map<String, dynamic> updateRecord = {"nickname": _nicknameController.text};
    String result = await DatabaseService.updateRecord(
        AppConstants.usersMetadataDBCollectionName, updateRecord,
        documentId: authenticatedUserID);

    Navigator.pop(context); // close loader

    if (result == AppConstants.generalSuccessMessageKey) {
      return true;
    } else if (result == AppConstants.serverException) {
      if (mounted)
        showAppToast(context, AppConstants.serverException, isError: true);
    }

    return false;
  }

  handleNameValidation(String value) {
    if (value.length < 2) {
      return "name should contain two or more characters";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeConstants.APP_BG_DARK,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Device.screenType == ScreenType.tablet
            ? AppThemeConstants().APP_TABLET_BASE_CONTENT_PADDING
            : AppThemeConstants().APP_BASE_CONTENT_PADDING),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.isFreshSetup
                      ? "One Last Thing!"
                      : "Something Really Cool...",
                  style: AppThemeConstants.APP_HEADING_TEXT,
                ),
              ),
            ),
            const Text('What should privvy call you?',
                style: AppThemeConstants.APP_BODY_TEXT_REGULAR),
            const SizedBox(
              height: 8,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _nicknameController,
                focusNode: _nicknameFocusNode,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: AppThemeConstants.APP_TEXTFIELD_OUTLINE_BORDER,
                  focusedBorder: AppThemeConstants.APP_TEXTFIELD_FOCUSED_BORDER,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  hintText: 'The Goat 🔥',
                  hintStyle: AppThemeConstants().APP_TEXTFIELD_HINT,
                ),
                cursorColor: AppThemeConstants.APP_PRIMARY_COLOR,
                style: AppThemeConstants.APP_BODY_TEXT_REGULAR,
                validator: (value) => handleNameValidation(value.toString()),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            AppButtonWide(
                buttonText: 'FRESH',
                disabled: false,
                callback: () => handleFreshTap()),
            const SizedBox(
              height: 120,
            ),
          ],
        ),
      ),
    );
  }
}
