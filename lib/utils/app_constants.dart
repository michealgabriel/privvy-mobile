

class AppConstants {
  // General
  static const String appTitle = "Privvy";
  static const int maxCollectionsCount = 5;

  // Custom Messages
  static const String otpSendError = "Error sending OTP";
  static const String otpCodeWrong = "The verification code from SMS is invalid";
  static const String invalidPhoneNumber = "Invalid phone number";
  static const String otpTimeout = "Mobile verification timeout, try again";
  static const String fieldEmptyError = "Field(s) cannot be empty";
  static const String oauthLoginError = "Provider sign in error";
  static const String noDatabaseResults = "No data available";

  // Exception
  static const String serverException = "An unknown error occured";

  // String keys
  static const String otpSuccessMessageKey = "OTP_SUCCESS";
  static const String otpFailedMessageKey = "OTP_FAILURE";
  static const String oauthSuccessMessageKey = "OAUTH_SUCCESS";
  static const String oauthFailedMessageKey = "OAUTH_FAILURE";
  static const String generalSuccessMessageKey = "SUCCESS";
  static const String generalFailedMessageKey = "FAILURE";

  static const String usersMetadataDBCollectionName = "users";

}
