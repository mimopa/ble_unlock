// import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  User(
      {@required this.uid,
      @required this.idToken,
      @required this.photoUrl,
      @required this.displayName});
  final String uid;
  final String idToken;
  final String photoUrl;
  final String displayName;
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  // Future<User> signInWithApple();
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    print(user.uid);
    print(user.email);
    print(user.getIdToken());
    return User(
      uid: user.uid,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
      idToken: user.getIdToken().toString(),
    );
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    // final result = await facebookLogin.loginWithPublishPermissions(
    //   ['public_profile'],
    // );
    final result = await facebookLogin.logIn(
      ['email'],
    );
    if (result.accessToken != null) {
      final authResult = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        ),
      );
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  // Future<User> signInWithApple({List<Scope> scopes = const []}) async {
  //   // 1. perform the sign-in request
  //   final result = await AppleSignIn.performRequests(
  //       [AppleIdRequest(requestedScopes: scopes)]);
  //   // 2. check the result
  //   switch (result.status) {
  //     case AuthorizationStatus.authorized:
  //       final appleIdCredential = result.credential;
  //       final oAuthProvider = OAuthProvider(providerId: 'apple.com');
  //       final credential = oAuthProvider.getCredential(
  //         idToken: String.fromCharCodes(appleIdCredential.identityToken),
  //         accessToken:
  //             String.fromCharCodes(appleIdCredential.authorizationCode),
  //       );
  //       final authResult = await _firebaseAuth.signInWithCredential(credential);
  //       final firebaseUser = authResult.user;
  //       if (scopes.contains(Scope.fullName)) {
  //         final updateUser = UserUpdateInfo();
  //         updateUser.displayName =
  //             '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
  //         await firebaseUser.updateProfile(updateUser);
  //       }
  //       return _userFromFirebase(firebaseUser);
  //     case AuthorizationStatus.error:
  //       print(result.error.toString());
  //       throw PlatformException(
  //         code: 'ERROR_AUTHORIZATION_DENIED',
  //         message: result.error.toString(),
  //       );

  //     case AuthorizationStatus.cancelled:
  //       throw PlatformException(
  //         code: 'ERROR_ABORTED_BY_USER',
  //         message: 'Sign in aborted by user',
  //       );
  //   }
  //   return null;
  // }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    // final app
    await _firebaseAuth.signOut();
  }
}
