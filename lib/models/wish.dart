import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Wish {
  String id;
  String url;
  String title;
  bool taken;
  DocumentReference list;
  bool favorite;
  String description;
  Timestamp created_at;

  Wish({
    @required this.id,
    this.url,
    @required this.title,
    @required this.list,
    this.created_at,
    this.taken,
    this.favorite,
    this.description,
  });

  Wish.fromDoc(QueryDocumentSnapshot doc) {
    id = doc.id;
    url = doc.data()['url'];
    title = doc.data()['title'];
    list = doc.data()['list'];
    created_at = doc.data()['created_at'];
    taken = doc.data()['taken'];
    favorite = doc.data()['favorite'];
    description = doc.data()['description'];
  }

  @override
  String toString() => this.title;

  Map toMap() {
    return Map<String, dynamic>.from({
      'url': this.url,
      'title': this.title,
      'list': this.list,
      'created_at': this.created_at,
      'taken': this.taken,
      'favorite': this.favorite,
      'description': this.description,
    });
  }

  Wish copyWith({
    String id,
    String url,
    String title,
    bool taken,
    DocumentReference list,
    bool favorite,
    String description,
    Timestamp created_at,
  }) => Wish(
    id: this.id,
    created_at: this.created_at,
    title: title ?? this.title,
    list: list ?? this.list,
    description: description ?? this.description,
    favorite: favorite ?? this.favorite,
    taken: taken ?? this.taken,
    url: url ?? this.url,
  );
}
