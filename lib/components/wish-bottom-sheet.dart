import 'package:flutter/material.dart';
import 'package:wish_list/models/wish.dart';
import 'package:wish_list/services/database.dart';
import 'package:wish_list/shared/loading.dart';

class WishBottomSheet extends StatelessWidget {
  final String wishId;

  WishBottomSheet({Key key, @required this.wishId});

  final DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.getWish(wishId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("An error occurred");
          print(snapshot.error);
          return Text(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        Wish wish = Wish.fromDocumentSnapshot(snapshot.data);

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          wish.title,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            wish.description,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton.icon(
                            color: wish.taken ? Colors.grey : Colors.blue,
                            onPressed: () {
                              final nextWish = wish.copyWith(taken: !wish.taken);
                              db.updateWish(nextWish);
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Je l'ai pris !",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
