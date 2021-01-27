import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wish_list/screens/wishes.dart';
import 'package:wish_list/services/auth.dart';
import 'package:wish_list/services/database.dart';
import 'package:wish_list/shared/loading.dart';

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'This is a demo alert dialog.',
                style: TextStyle(color: Colors.red),
              ),
              Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Approve'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton.icon(
            icon: Icon(Icons.add),
            label: Text('Toto'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

class WishListItem extends StatelessWidget {
  final String id;
  final String title;

  WishListItem({Key key, this.id, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WishesScreen(wishListId: id),
          ));
        },
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste de voeux'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.account_circle),
            onPressed: () async {
              await _auth.signOut();
            },
            label: Text('Logout'),
          )
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
                        final docs = snapshot.data?.docs;
                        final id = docs != null ? docs[index].id : '';
                        final title = docs != null ? docs[index]['title'] : '';

                        return Container(
                          child: WishListItem(id: id, title: title),
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
    );
  }
}
