import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wish_list/forms/new-wish-list.dart';
import 'package:wish_list/generated/locale_keys.g.dart';
import 'package:wish_list/models/wish-list.dart';
import 'package:wish_list/screens/wishes.dart';
import 'package:wish_list/services/auth.dart';
import 'package:wish_list/services/database.dart';
import 'package:wish_list/shared/loading.dart';
import 'package:wish_list/shared/slidable-actions.dart';

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return SimpleDialog(
        contentPadding: EdgeInsets.all(24.0),
        title: Text(tr(LocaleKeys.forms_wishList_title)),
        children: [
          NewWishListForm(),
        ],
      );
    },
  );
}

class WishListItem extends StatelessWidget {
  final WishList list;

  final _db = DatabaseService();

  WishListItem({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SlidableActions(
        onDelete: () async {
          await _db.removeWishList(list.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Successfully removed wish list.',
              ),
            ),
          );
        },
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WishesScreen(wishList: list),
            ));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            child: Text(
              list.title,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ),
      ),
    );
  }
}

class WishListScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr(LocaleKeys.screens_wishList_title)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showMyDialog(context),
          child: Icon(Icons.add),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<Query>(
                future: () async {
                  DatabaseService db = DatabaseService();
                  return db.getWishListList();
                }(),
                builder: (context, snapshot) {
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
                        padding: EdgeInsets.all(8.0),
                        itemCount: snapshot.data?.docs?.length,
                        itemBuilder: (BuildContext context, int index) {
                          final doc = snapshot.data?.docs[index];
                          final wishList = WishList.fromDoc(doc);

                          return Container(
                            child: WishListItem(list: wishList),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                            childAspectRatio: 2),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
