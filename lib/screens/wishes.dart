import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wish_list/services/database.dart';
import 'package:wish_list/shared/loading.dart';

class WishesScreen extends StatelessWidget {
  final String wishListId;

  WishesScreen({Key key, this.wishListId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toto'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Query>(
              future: () async {
                DatabaseService db = DatabaseService();
                return db.getWishes(wishListId);
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
                        final title = docs != null ? docs[index]['title'] : '';

                        return Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(title),
                          ),
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
