import 'package:flutter/material.dart';
import 'package:wish_list/models/user.dart';
import 'package:wish_list/services/auth.dart';
import 'package:wish_list/shared/constants.dart';
import 'package:wish_list/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  // email state
  String email = '';
  String password = '';

  // error state
  String error = '';

  // Methods
  Future handleSignIn() async {
    if (_formKey.currentState.validate()) {
      setState(() => _loading = true);

      User result =
          await _authService.signInWithEmailAndPassword(email, password);

      if (result == null) {
        setState(() {
          error = "Adresse mail ou mot de passe invalide.";
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Se connecter'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.account_circle),
                  onPressed: () => widget.toggleView(),
                  label: Text(
                    "S'inscrire",
                  ),
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: "Adresse mail"),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() => email = value);
                      },
                      validator: (value) =>
                          value.isEmpty ? "Enter an email" : null,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: "Mot de passe"),
                      obscureText: true,
                      onChanged: (value) {
                        setState(() => password = value);
                      },
                      validator: (value) => value.length < 6
                          ? "Enter a password 6+ chars long"
                          : null,
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      onPressed: handleSignIn,
                      // color: Colors.pink,
                      color: Theme.of(context).primaryColor,
                      child: Text('Sign in'),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      error,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
