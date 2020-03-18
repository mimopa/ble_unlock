// import 'package:apple_sign_in/scope.dart';
// import 'package:ble_unlock/app/sign_in/apple_sign_in_available.dart';
import 'package:ble_unlock/app/sign_in/email_sign_in_page.dart';
import 'package:ble_unlock/app/sign_in/sign_in_button.dart';
import 'package:ble_unlock/app/sign_in/sign_in_manager.dart';
import 'package:ble_unlock/app/sign_in/social_sign_in_button.dart';
import 'package:ble_unlock/common_widgets/platform_exception_alert_dialog.dart';
import 'package:ble_unlock/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({
    Key key,
    @required this.manager,
    @required this.isLoading,
  }) : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      // builder: (_) => ValueNotifier<bool>(false),
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          // builder: (_) => SignInManager(auth: auth, isLoading: isLoading),
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  // Future<void> _signInWithApple(BuildContext context) async {
  //   try {
  //     await manager.signInWithApple(scopes: [Scope.email, Scope.fullName]);
  //   } on PlatformException catch (e) {
  //     if (e.code != 'ERROR_ABORTED_BY_USER') {
  //       _showSignInError(context, e);
  //     }
  //   }
  // }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('BLE Unlock'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildContent(BuildContext context) {
    // final appleSignInAvailable =
    //     Provider.of<AppleSignInAvailable>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 250.0,
            child: _buildHeader(),
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in しない',
            textColor: Colors.black,
            color: Colors.amber[200],
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
          SizedBox(height: 8.0),
          Text(
            'もしくは',
            style: TextStyle(fontSize: 14.0, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.0),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          SizedBox(height: 8.0),
          // if (appleSignInAvailable.isAvailable)
          //   SocialSignInButton(
          //     assetName: 'images/apple-logo.png',
          //     text: 'Sign in with Apple',
          //     textColor: Colors.white,
          //     color: Colors.black,
          //     onPressed: isLoading ? null : () => _signInWithApple(context),
          //   ),
          // if (appleSignInAvailable.isAvailable) SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
        child: Hero(
      tag: 'tick',
      child: new Image.asset(
        'images/logo.png',
        width: 200.0,
        height: 200.0,
        scale: 1.0,
        colorBlendMode: BlendMode.modulate,
      ),
    ));
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Column(
        children: <Widget>[
          _buildLogo(),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
    }
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildLogo(),
      ],
    );
  }
}
