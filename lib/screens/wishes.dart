import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wish_list/components/wish-bottom-sheet.dart';
import 'package:wish_list/models/wish-list.dart';
import 'package:wish_list/models/wish.dart';
import 'package:wish_list/services/database.dart';
import 'package:wish_list/shared/loading.dart';

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
        onPressed: () {},
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
                      padding: EdgeInsets.all(8.0),
                      itemCount: snapshot.data?.docs?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final doc = snapshot.data?.docs[index];
                        final wish = Wish.fromDoc(doc);

                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
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
                            child: Column(
                              children: [
                                Image.network(
                                    'https://images-na.ssl-images-amazon.com/images/I/71k47LPEkuL._AC_SL1500_.jpg'),
                                Container(
                                  margin: EdgeInsets.only(top: 12.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: Text(
                                            wish.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.bodyText1,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: IconButton(
                                          padding: EdgeInsets.only(
                                            top: 4.0,
                                            left: 4.0,
                                            right: 8.0,
                                            bottom: 8.0,
                                          ),
                                          constraints: BoxConstraints(),
                                          icon: Icon(
                                            Icons.favorite,
                                            color: wish.favorite ?? false
                                                ? Colors.pinkAccent
                                                : Colors.grey,
                                          ),
                                          onPressed: () async {
                                            final Wish nextWish =
                                                wish.copyWith(favorite: !(wish.favorite ?? false));

                                            _db.updateWish(nextWish);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Text(
                                          wish.description ?? '',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                color: Colors.grey[600],
                                                fontSize: 12.0,
                                              ),
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                        bottom: 8.0,
                                      ),
                                      child: IconButton(
                                        color: (wish.taken ?? false) ? Colors.green : Colors.grey,
                                        icon: Icon((wish.taken ?? false)
                                            ? Icons.check
                                            : Icons.check_box_outline_blank),
                                        onPressed: () async {
                                          final Wish nextWish =
                                              wish.copyWith(taken: !(wish.taken ?? false));

                                          _db.updateWish(nextWish);
                                        },
                                        padding: EdgeInsets.all(4.0),
                                        constraints: BoxConstraints(),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                          childAspectRatio: 0.9),
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
