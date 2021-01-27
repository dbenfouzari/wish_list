import 'package:firebase_auth/firebase_auth.dart' as FBAuth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wish_list/models/user.dart';

class AuthService {
  final FBAuth.FirebaseAuth _auth = FBAuth.FirebaseAuth.instance;

  // create User object based on Firebase user
  User _userFromFirebaseUser(FBAuth.User user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth changes stream
  Stream<User> get user {
    return _auth.authStateChanges().map((user) {
      return _userFromFirebaseUser(user);
    });
  }

  // works well with Firebase
  User get currentUser {
    return _userFromFirebaseUser(_auth.currentUser);
  }

  // sign in anonymously
  Future signInAnonymously() async {
    try {
      FBAuth.UserCredential result = await _auth.signInAnonymously();
      FBAuth.User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign in with email/password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      // FBAuth.
      FBAuth.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FBAuth.User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email/password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      // FBAuth.
      FBAuth.UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FBAuth.User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign in with Google
  Future<FBAuth.UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final FBAuth.GoogleAuthCredential credential =
          FBAuth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FBAuth.FirebaseAuth.instance
          .signInWithCredential(credential);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
