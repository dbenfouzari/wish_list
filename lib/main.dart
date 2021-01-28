import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list/models/user.dart';
import 'package:wish_list/screens/wrapper.dart';
import 'package:wish_list/services/auth.dart';
import 'package:wish_list/shared/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

ThemeData _darkTheme = ThemeData(
  accentColor: Colors.pinkAccent,
  brightness: Brightness.dark,
  primaryColor: Colors.pink,
);

ThemeData _lightTheme = ThemeData(
  accentColor: Colors.blueAccent,
  brightness: Brightness.light,
  primaryColor: Colors.blue,
);

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wish List',
      theme: _lightTheme,
      // darkTheme: _darkTheme,
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Something went wrong.");
            print(snapshot.error.toString());
            return Center(
              child: Text(
                '${snapshot.error} occurred.',
                style: TextStyle(fontSize: 18.0),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return StreamProvider<User>.value(
              value: AuthService().user,
              child: Wrapper(),
            );
          }

          return Loading();
        },
      ),
    );
  }
}
