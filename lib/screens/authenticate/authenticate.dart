import 'package:flutter/material.dart';
import 'package:wish_list/screens/authenticate/register.dart';
import 'package:wish_list/screens/authenticate/sign_in_credentials.dart';

// class AuthenticateScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: SignIn(),
//     );
//   }
// }

class AuthenticateScreen extends StatefulWidget {
  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  bool _showSignIn = true;

  void toggleView() {
    setState(() => _showSignIn = !_showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (_showSignIn) {
      return SignInCredentials(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
