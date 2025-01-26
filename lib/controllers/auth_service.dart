import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:privvy/utils/app_logger.dart';
import 'package:privvy/utils/app_constants.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static String verifyId = "";

  // ! Send otp to user
  static Future sendOtp({required String phone, required Function errorStep, required Function nextStep, Function? timeoutStep}) async {
    await _firebaseAuth.verifyPhoneNumber(
      timeout: const Duration(seconds: 30),
      phoneNumber: phone,
      verificationCompleted: (phoneAuthCredential) async {
        return;
      },
      verificationFailed: (error) async {
        AppLogger().log(Level.warning, "AuthService.sendOtp (verificationFailed) ERROR: ${error.toString()}");
        errorStep();
        return;
      },
      codeSent: (verificationId, forceResendingToken) async {
        verifyId = verificationId;
        nextStep();
      },
      codeAutoRetrievalTimeout: (verificationId) {
        // timeoutStep();
        return;
      },
    )
    .onError((error, stackTrace) {
      AppLogger().log(Level.warning, "AuthService.sendOtp (onError): ${error.toString()}");
      errorStep();
    });
  }

  // ! Verify the otp code and login
  static Future loginWithOtp({required String otp}) async {
    final cred = PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

    try {
      final user = await _firebaseAuth.signInWithCredential(cred);

      if (user.user != null) {
        return AppConstants.otpSuccessMessageKey;
      } else {
        return AppConstants.otpFailedMessageKey;
      }
    } 
    on FirebaseAuthException catch (e) {
      AppLogger().log(Level.warning, "AuthService.signInWithCredential (FirebaseAuthException) ERROR: ${e.toString()}");
      return AppConstants.otpFailedMessageKey;
    } 
    catch (e) {
      AppLogger().log(Level.warning, "AuthService.signInWithCredential ERROR: ${e.toString()}");
      return AppConstants.serverException;
    }
  }
  
  // ! Authenticate with google X apple
  static Future loginWithProvider({required bool isGoogle}) async {

    try {
      final user = await _firebaseAuth.signInWithProvider(isGoogle ? GoogleAuthProvider() : AppleAuthProvider());
      AppLogger().log(Level.info, "AUTHENTICATED USER OBJ: $user");

      if (user.user != null) {
        return AppConstants.oauthSuccessMessageKey;
      } else {
        return AppConstants.oauthFailedMessageKey;
      }
    } 
    on FirebaseAuthException catch (e) {
      AppLogger().log(Level.warning, "AuthService.signInWithProvider (FirebaseAuthException) ERROR: ${e.toString()}");
      return AppConstants.oauthFailedMessageKey;
    } 
    catch (e) {
      AppLogger().log(Level.warning, "AuthService.signInWithProvider ERROR: ${e.toString()}");
      return AppConstants.serverException;
    }
  }

  // ! Logout the user
  static Future logout() async {
    await _firebaseAuth.signOut();
  }

  // ! Check user authentication status
  static Future<bool> isLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    return user != null;
  }

  // ! Get authenticated user id
  static Future<String> getLoggedInUserID() async {
    var user = _firebaseAuth.currentUser;
    return user!.uid;
  }

}