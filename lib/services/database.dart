import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  /// =====
  /// Users
  /// =====
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot> getUser() async {
    return await _usersCollection.doc(uid).get();
  }

  Future createUser() async {
    return await _usersCollection.doc(uid).set({'id': uid, 'created_at': new DateTime.now()});
  }

  Future<DocumentSnapshot> findOrCreateUser() async {
    final user = await getUser();
    if (user.exists) return user;

    await createUser();
    return await getUser();
  }

  /// ==========
  /// Wish lists
  /// ==========
  CollectionReference wishListsCollection =
      FirebaseFirestore.instance.collection('wish_lists');

  Future<Query> getWishListList() async {
    DocumentSnapshot user = await getUser();

    return wishListsCollection
        .orderBy('created_at', descending: true)
        .where('user', isEqualTo: user.reference);
  }
}
