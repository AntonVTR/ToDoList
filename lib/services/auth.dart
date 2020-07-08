import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/services/DB.dart';
import 'package:todo/services/push_notification.dart';

class AuthService {
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign with email and password
  Future signInWithEmailAndPassword(String email, password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      (await currentUserClaims)['admin'] = true;
      await setToken(user);
      //Create a new document for user with the uid

      return user;
    } catch (e) {
      print("Error ${e.toString()}");
      return null;
    }
  }

  Future setToken(FirebaseUser user) async {
    String token = await PushNotificationsService().fcmT;
    if (token != null) DataBaseService(user: user).updateDeviceToken(token);
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await DataBaseService(user: user).updateUserData();
      await setToken(user);

      return user;
    } catch (e) {
      print("Error ${e.toString()}");
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("Error ${e.toString()}");
      return null;
    }
  }

  Future<Map<dynamic, dynamic>> get currentUserClaims async {
    final user = await FirebaseAuth.instance.currentUser();

    // If refresh is set to true, a refresh of the id token is forced.
    final idToken = await user.getIdToken(refresh: true);

    return idToken.claims;
  }
}
