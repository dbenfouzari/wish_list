import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wish_list/models/wish.dart';

class DatabaseService {
  final String uid = FirebaseAuth.instance.currentUser.uid;

  //#region Users
  //=============
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot> getUser() async {
    return await _usersCollection.doc(uid).get();
  }

  Future createUser() async {
    return await _usersCollection
        .doc(uid)
        .set({'id': uid, 'created_at': new DateTime.now()});
  }

  Future<DocumentSnapshot> findOrCreateUser() async {
    if (uid != null) {
      final user = await getUser();
      if (user.exists) return user;

      await createUser();
      return await getUser();
    }

    return null;
  }
  //=============
  //#endregion

  //#region Wish lists
  //==================
  CollectionReference wishListsCollection =
      FirebaseFirestore.instance.collection('wish_lists');

  Future<Query> getWishListList() async {
    DocumentSnapshot user = await getUser();

    return wishListsCollection
        .orderBy('created_at', descending: true)
        .where('user', isEqualTo: user.reference);
  }

  Future<DocumentSnapshot> getWishList(String id) async {
    return await wishListsCollection.doc(id).get();
  }

  //==================
  //#endregion

  //#region Wishes
  //==============
  CollectionReference wishesCollection =
      FirebaseFirestore.instance.collection('wishes');

  Future<Query> getWishes(String wishListId) async {
    DocumentSnapshot wishList = await getWishList(wishListId);

    return wishesCollection.where('list', isEqualTo: wishList.reference);
  }

  Future<void> updateWish(Wish wish) async {
    return wishesCollection.doc(wish.id).update(wish.toMap());
  }
  //==============
  //#endregion
}
