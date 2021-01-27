import 'package:flutter/material.dart';

class WishesScreen extends StatelessWidget {
  final String wishListTitle;

  WishesScreen({Key key, this.wishListTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.wishListTitle),
      ),
      body: Container(
        child: Text('Wish list ${this.wishListTitle}'),
      ),
    );
  }
}
