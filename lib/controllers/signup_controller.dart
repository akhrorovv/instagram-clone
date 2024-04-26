import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/member_model.dart';
import '../pages/home_page.dart';
import '../pages/signin_page.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import '../services/pref_service.dart';
import '../services/utils_service.dart';

class SignUpController extends GetxController {
  var isLoading = false;
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var cpasswordController = TextEditingController();

  doSignUp() async {
    String fullName = fullNameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String cpassword = cpasswordController.text.toString().trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) return;

    if (cpassword != password) {
      Utils.fireToast("Password and confirm password does not match");
      return;
    }

    isLoading = true;
    update();

    AuthService.signUpUser(fullName, email, password).then((firebaseUser) => {
          getFirebaseUser(firebaseUser, Member(fullName, email)),
        });
  }

  getFirebaseUser(User? firebaseUser, Member member) async {
    isLoading = false;
    update();

    if (firebaseUser != null) {
      saveMemberIdToLocal(firebaseUser);
      saveMemberToCloud(member);

      callHomePage();
    } else {
      Utils.fireToast("Check your information");
    }
  }

  saveMemberIdToLocal(User firebaseUser) async {
    await Prefs.saveUserId(firebaseUser.uid);
  }

  saveMemberToCloud(Member member) async {
    await DBService.storeMember(member);
  }

  callHomePage() {
    Get.toNamed(HomePage.id);
  }

  callSignInPage() {
    // Navigator.pushReplacementNamed(context, SignInPage.id);
    Get.toNamed(SignInPage.id);
  }
}
