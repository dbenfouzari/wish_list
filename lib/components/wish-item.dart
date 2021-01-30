import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wish_list/models/wish.dart';
import 'package:wish_list/services/database.dart';
import 'package:wish_list/shared/slidable-actions.dart';

class WishItem extends StatelessWidget {
  final Wish wish;
  final Function onTap;
  final DatabaseService _db = DatabaseService();

  WishItem({Key key, this.wish, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 32,
      shadowColor: Color.fromARGB(80, 0, 0, 0),
      child: SlidableActions(
        onDelete: () async {
          await _db.removeWish(wish.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully removed wish.'),
            ),
          );
        },
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    padding: EdgeInsets.only(
                      top: 4.0,
                      left: 4.0,
                      right: 8.0,
                      bottom: 8.0,
                    ),
                    constraints: BoxConstraints(),
                    icon: Icon(
                      wish.favorite ?? false ? Icons.favorite : Icons.favorite_border,
                      color: wish.favorite ?? false ? Colors.pinkAccent : Colors.grey[400],
                    ),
                    onPressed: () async {
                      final Wish nextWish = wish.copyWith(favorite: !(wish.favorite ?? false));

                      _db.updateWish(nextWish);
                    },
                  ),
                ],
              ),
              Expanded(
                child: CachedNetworkImage(
                  imageUrl:
                      "https://images-na.ssl-images-amazon.com/images/I/71k47LPEkuL._AC_SL1500_.jpg",
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn),
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        wish.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
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
                      color: (wish.taken ?? false) ? Colors.green : Colors.grey[400],
                      icon:
                          Icon((wish.taken ?? false) ? Icons.check : Icons.check_box_outline_blank),
                      onPressed: () async {
                        final Wish nextWish = wish.copyWith(taken: !(wish.taken ?? false));

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
      ),
    );
  }
}
