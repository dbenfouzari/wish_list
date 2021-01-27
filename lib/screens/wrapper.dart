import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list/models/user.dart';
import 'package:wish_list/screens/authenticate/authenticate.dart';
import 'package:wish_list/screens/wish-list.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // Return either WishListScreen or Authenticate widget
    if (user == null) {
      return AuthenticateScreen();
    } else {
      return WishListScreen();
    }
  }
}
