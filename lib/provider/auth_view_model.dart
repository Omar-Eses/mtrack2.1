import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mtrack/helper/ui_helper.dart';
import 'package:mtrack/utils/enums.dart';
import '../helper/cache_helper.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLoading = false;
  TextEditingController registerEmail = TextEditingController();
  TextEditingController registerPassword = TextEditingController();
  TextEditingController registerConfirmPassword = TextEditingController();
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  String? uid;

  // register User
  Future<void> registerUser(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: registerEmail.text, password: registerPassword.text)
          .then((value) {
        uid = value.user!.email;
        createUser();
        CacheHelper.saveData(key: 'uid', value: uid);
        Navigator.pushReplacementNamed(context, '/home');
      });
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        UiMethods.showSnackBar(
            text: "weak-password", status: SnakeBarStatus.error);
      } else if (ex.code == 'email-already-in-use') {
        UiMethods.showSnackBar(
            text: "email-already-in-use", status: SnakeBarStatus.error);
      }
    } catch (ex) {
      UiMethods.showSnackBar(
          text: "There was an error", status: SnakeBarStatus.error);
    }

    isLoading = false;
    notifyListeners();
  }

  // Create User
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  createUser() {
    UserModel user = UserModel(
      email: registerEmail.text,
      uid: uid,
      fName: fName.text,
      lName: lName.text,
      image: 'assets/images/profilemale.png',
      myTeams: [],
    );
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(registerEmail.text).set(user.toMap()).then((value) {
      notifyListeners();
      print('user added');
    }).catchError((error) {
      notifyListeners();
    });
  }

  Future login(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text);

      uid = user.user!.email;
      await CacheHelper.saveData(key: 'uid', value: uid);
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        debugPrint('not found');
        UiMethods.showSnackBar(
            text: "user-not-found", status: SnakeBarStatus.error);
      } else if (ex.code == 'wrong-password') {
        UiMethods.showSnackBar(
            text: "Wrong password", status: SnakeBarStatus.error);
      }
    } catch (ex) {
      UiMethods.showSnackBar(
          text: "There was an error", status: SnakeBarStatus.error);
    }
    isLoading = false;
    notifyListeners();
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      // Handle sign-in errors
      print(e.toString());
      return null;
    }
  }

  // delete user from firebase firestore as well as firebase auth
  Future<void> deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    user!.delete().then((value) {
      print('user deleted');
    }).catchError((error) {
      print('error');
    });
  }

  // Change Password
  Future<void> changePassword(String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.updatePassword(newPassword).then((value) {
          print('Password changed');
        }).catchError((error) {
          print('Error changing password: $error');
        });
      }
    } catch (e) {
      print('Error changing password: $e');
    }
  }

  // Combined Method for Editing Information and Uploading Image
  // Future<void> editInformationAndUploadImage({
  //   String? firstName,
  //   String? lastName,
  //   File? imageFile,
  // }) async {
  //   try {
  //     String? imagePath;
  //     if (imageFile != null) {
  //       imagePath = await uploadImage(imageFile);
  //     }
  //     await editUserInformation(
  //       firstName: firstName,
  //       lastName: lastName,
  //       imagePath: imagePath,
  //     );
  //     print('User information and image updated');
  //   } catch (e) {
  //     print('Error editing user information and uploading image: $e');
  //   }
  // }
}
