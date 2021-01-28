import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class WishList {
  String title;
  DocumentReference user;
  Timestamp created_at;
  String id;
  DocumentReference ref;

  @override
  toString() => this.title;

  WishList(
      {@required this.title, @required this.user, @required this.created_at, @required this.id});

  WishList.fromDoc(QueryDocumentSnapshot doc) {
    created_at = doc.data()['created_at'];
    title = doc.data()['title'];
    user = doc.data()['user'];
    id = doc.id;
    ref = doc.reference;
  }
}