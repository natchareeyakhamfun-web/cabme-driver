import 'dart:async';
import 'dart:convert';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/page/auth_screens/signup_screen.dart';
import 'package:cabme_driver/page/dashboard_screen.dart';
import 'package:cabme_driver/page/owner_dashboard_screen.dart';
import 'package:cabme_driver/page/subscription_plan_screen/subscription_plan_screen.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;

  RxBool isPasswordShow = true.obs;

  Future<UserModel?> loginAPI(Map<String, String> bodyParams) async {
    print(bodyParams);
    UserModel? userModel;
    await API
        .handleApiRequest(
            request: () => http.post(Uri.parse(API.userLogin), headers: API.authheader, body: jsonEncode(bodyParams)), showLoader: true)
        .then(
      (value) {
        if (value != null) {
          if (value['success'] == "Failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            userModel = UserModel.fromJson(value);
          }
        }
      },
    );
    return userModel;
  }

  Future<bool?> phoneNumberIsExit(Map<String, String> bodyParams) async {
    bool? isExits;
    await API
        .handleApiRequest(
            request: () => http.post(Uri.parse(API.getExistingUserOrNot), headers: API.authheader, body: jsonEncode(bodyParams)),
            showLoader: true)
        .then(
      (value) {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            if (value['data'] == true) {
              isExits = true;
            } else {
              isExits = false;
            }
          }

        }
      },
    );
    return isExits;
  }

  Future<UserModel?> getDataByPhoneNumber(Map<String, String> bodyParams) async {
    UserModel? userModel;
    await API
        .handleApiRequest(
            request: () => http.post(Uri.parse(API.getProfileByPhone), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true)
        .then(
      (value) {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          }
          userModel = UserModel.fromJson(value);
        }
      },
    );
    return userModel;
  }

  Future<void> loginWithGoogle() async {
    ShowToastDialog.showLoader("please wait...".tr);
    await signInWithGoogle().then((googleUser) async {
      ShowToastDialog.closeLoader();
      if (googleUser != null) {
        Map<String, String> bodyParams = {
          'user_cat': "driver",
          'email': googleUser.user!.email.toString(),
          'login_type': "google",
        };
        print("==>$bodyParams");
        await phoneNumberIsExit(bodyParams).then((value) async {
          if(value != null){
            if (value == true) {
              Map<String, String> bodyParams = {
                'email': googleUser.user!.email.toString(),
                'user_cat': "driver",
                'login_type': "google",
              };
              await getDataByPhoneNumber(bodyParams).then((value) {
                if (value != null) {
                  if (value.success == "success") {
                    ShowToastDialog.closeLoader();

                    Preferences.setInt(Preferences.userId, int.parse(value.userData!.id.toString()));
                    Preferences.setString(Preferences.user, jsonEncode(value));
                    Preferences.setString(Preferences.accesstoken, value.userData!.accesstoken.toString());
                    API.headers['accesstoken'] = value.userData!.accesstoken.toString();
                    Preferences.setBoolean(Preferences.isLogin, true);

                    UserData userData = value.userData!;
                    bool isPlanExpired = false;

                    /// Case 1: Admin Commission = 'no' and Subscription model = false
                    if (Constant.adminCommission?.statut == "no" && Constant.subscriptionModel == false) {
                      if (userData.isOwner == "true") {
                        Get.offAll(() => OwnerDashboardScreen(), transition: Transition.rightToLeft);
                      } else {
                        Get.offAll(() => DashboardScreen(), transition: Transition.rightToLeft);
                      }
                      return;
                    }

                    /// Case 3: Owner’s Driver (driver under an owner)
                    bool isOwnerDriver = userData.isOwner == "false" && userData.ownerId != null && userData.ownerId!.isNotEmpty;
                    if (isOwnerDriver) {
                      Get.offAll(() => DashboardScreen(), transition: Transition.rightToLeft);
                      return;
                    }

                    /// Case 2: Individual Driver (no ownerId) → Check subscription
                    bool isIndividualDriver = userData.isOwner == "false" && (userData.ownerId == null || userData.ownerId!.isEmpty);

                    if (isIndividualDriver || userData.isOwner == "true") {
                      // Check subscription for Owner OR Individual Driver
                      if (userData.subscriptionPlanId != null) {
                        if (userData.subscriptionExpiryDate == null) {
                          isPlanExpired = userData.subscriptionPlan?.expiryDay != '-1';
                        } else {
                          final expiryDate = DateTime.tryParse(userData.subscriptionExpiryDate!);
                          isPlanExpired = expiryDate != null && expiryDate.isBefore(DateTime.now());
                        }
                      } else {
                        isPlanExpired = true;
                      }

                      if (userData.subscriptionPlanId == null || isPlanExpired) {
                        Get.to(() => SubscriptionPlanScreen(), arguments: {'isSplashScreen': true});
                      } else {
                        if (userData.isOwner == "true") {
                          Get.offAll(() => OwnerDashboardScreen(), transition: Transition.rightToLeft);
                        } else {
                          Get.offAll(() => DashboardScreen(), transition: Transition.rightToLeft);
                        }
                      }
                    }
                  }
                }
              });
            }
            else if (value == false) {
              ShowToastDialog.closeLoader();
              Get.to(() => SignupScreen(), arguments: {
                'email': googleUser.user!.email,
                'firstName': googleUser.user!.displayName,
                'login_type': "google",
              });
            }
          }

        });
      }
    });
  }

  Future<void> loginWithApple() async {
    ShowToastDialog.showLoader("please wait...".tr);
    await signInWithApple().then((value) async {
      ShowToastDialog.closeLoader();
      if (value != null) {
        Map<String, dynamic> map = value;
        AuthorizationCredentialAppleID appleCredential = map['appleCredential'];
        UserCredential userCredential = map['userCredential'];
        Map<String, String> bodyParams = {
          'user_cat': "driver",
          'email': userCredential.user!.email.toString(),
          'login_type': "apple",
        };
        await phoneNumberIsExit(bodyParams).then((value) async {
          if(value != null){
            if (value == true) {
              Map<String, String> bodyParams = {
                'email': userCredential.user!.email.toString(),
                'user_cat': "driver",
                'login_type': "apple",
              };
              await getDataByPhoneNumber(bodyParams).then((value) {
                if (value != null) {
                  if (value.success == "success") {
                    ShowToastDialog.closeLoader();

                    Preferences.setInt(Preferences.userId, int.parse(value.userData!.id.toString()));
                    Preferences.setString(Preferences.user, jsonEncode(value));
                    Preferences.setString(Preferences.accesstoken, value.userData!.accesstoken.toString());
                    API.headers['accesstoken'] = value.userData!.accesstoken.toString();
                    Preferences.setBoolean(Preferences.isLogin, true);

                    UserData userData = value.userData!;
                    bool isPlanExpired = false;

                    /// Case 1: Admin Commission = 'no' and Subscription model = false
                    if (Constant.adminCommission?.statut == "no" && Constant.subscriptionModel == false) {
                      if (userData.isOwner == "true") {
                        Get.offAll(() => OwnerDashboardScreen(), transition: Transition.rightToLeft);
                      } else {
                        Get.offAll(() => DashboardScreen(), transition: Transition.rightToLeft);
                      }
                      return;
                    }

                    /// Case 3: Owner’s Driver (driver under an owner)
                    bool isOwnerDriver = userData.isOwner == "false" && userData.ownerId != null && userData.ownerId!.isNotEmpty;
                    if (isOwnerDriver) {
                      Get.offAll(() => DashboardScreen(), transition: Transition.rightToLeft);
                      return;
                    }

                    /// Case 2: Individual Driver (no ownerId) → Check subscription
                    bool isIndividualDriver = userData.isOwner == "false" && (userData.ownerId == null || userData.ownerId!.isEmpty);

                    if (isIndividualDriver || userData.isOwner == "true") {
                      // Check subscription for Owner OR Individual Driver
                      if (userData.subscriptionPlanId != null) {
                        if (userData.subscriptionExpiryDate == null) {
                          isPlanExpired = userData.subscriptionPlan?.expiryDay != '-1';
                        } else {
                          final expiryDate = DateTime.tryParse(userData.subscriptionExpiryDate!);
                          isPlanExpired = expiryDate != null && expiryDate.isBefore(DateTime.now());
                        }
                      } else {
                        isPlanExpired = true;
                      }

                      if (userData.subscriptionPlanId == null || isPlanExpired) {
                        Get.to(() => SubscriptionPlanScreen(), arguments: {'isSplashScreen': true});
                      } else {
                        if (userData.isOwner == "true") {
                          Get.offAll(() => OwnerDashboardScreen(), transition: Transition.rightToLeft);
                        } else {
                          Get.offAll(() => DashboardScreen(), transition: Transition.rightToLeft);
                        }
                      }
                    }
                  }
                }
              });
            } else if (value == false) {
              ShowToastDialog.closeLoader();
              Get.to(() => SignupScreen(), arguments: {
                'email': userCredential.user!.email,
                'firstName': appleCredential.givenName,
                'lastname': appleCredential.familyName,
                'login_type': "apple",
              });
            }
          }
        });
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Google Sign-In error: $e');
      return null;
    }
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
        // webAuthenticationOptions: WebAuthenticationOptions(clientId: clientID, redirectUri: Uri.parse(redirectURL)),
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return {"appleCredential": appleCredential, "userCredential": userCredential};
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
