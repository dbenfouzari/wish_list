import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wish_list/components/wish-bottom-sheet.dart';
import 'package:wish_list/components/wish-item.dart';
import 'package:wish_list/forms/new-wish.dart';
import 'package:wish_list/generated/locale_keys.g.dart';
import 'package:wish_list/models/wish-list.dart';
import 'package:wish_list/models/wish.dart';
import 'package:wish_list/services/database.dart';
import 'package:wish_list/shared/loading.dart';
import 'package:wish_list/shared/slidable-actions.dart';

Future<void> _shownNewWishForm(BuildContext context, WishList wishList) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        contentPadding: EdgeInsets.all(24.0),
        title: Text(tr(LocaleKeys.forms_wish_title)),
        children: [
          NewWishForm(wishList: wishList),
        ],
      );
    },
  );
}

class WishesScreen extends StatefulWidget {
  final WishList wishList;

  WishesScreen({Key key, this.wishList}) : super(key: key);

  @override
  _WishesScreenState createState() => _WishesScreenState();
}

class _WishesScreenState extends State<WishesScreen> {
  final _db = DatabaseService();

  Wish selectedWish;

  @override
  Widget build(BuildContext context) {
    final wishNotifier = ValueNotifier(selectedWish);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wishList.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _shownNewWishForm(context, widget.wishList);
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Query>(
              future: () async {
                return _db.getWishes(widget.wishList.id);
              }(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Text('Woops');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                }

                return StreamBuilder<QuerySnapshot>(
                  stream: snapshot.data?.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return Text('Something went wrong.');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Loading();
                    }

                    return GridView.builder(
                      padding: EdgeInsets.all(12.0),
                      itemCount: snapshot.data?.docs?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final doc = snapshot.data?.docs[index];
                        final wish = Wish.fromDoc(doc);

                        return WishItem(
                          wish: wish,
                          onTap: () {
                            setState(() {
                              selectedWish = wish;
                            });

                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ValueListenableBuilder(
                                valueListenable: wishNotifier,
                                builder: (context, value, child) {
                                  return WishBottomSheet(
                                    wishId: selectedWish.id,
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          childAspectRatio: 0.88),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
