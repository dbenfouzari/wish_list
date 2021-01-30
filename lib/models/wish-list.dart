import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:wish_list/utils.dart';

class WishList {
  String title;
  DocumentReference user;
  Timestamp createdAt;
  String id;
  DocumentReference ref;

  @override
  toString() => this.title;

  WishList(
      {@required this.title, @required this.user, @required this.createdAt, this.id});

  WishList.fromDoc(QueryDocumentSnapshot doc) {
    createdAt = doc.data()['created_at'];
    title = doc.data()['title'];
    user = doc.data()['user'];
    id = doc.id;
    ref = doc.reference;
  }

  Map<String, dynamic> toMap() {
    return removeNulls(
      {
        'created_at': createdAt,
        'title': title,
        'user': user,
        'id': id,
        'ref': ref,
      },
    );
  }
}
