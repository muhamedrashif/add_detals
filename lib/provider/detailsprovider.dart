import 'dart:typed_data';
import 'package:add_detals/models/posts.dart';
import 'package:add_detals/provider/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Details extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // upload details

  Future<String> uploaddetails({
    required String name,
    required String age,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      // ignore: unnecessary_null_comparison
      if (name.isNotEmpty || age.isNotEmpty || file != null) {
        String photoUrl = await
            StorageMethods().uploadImageToStorage('posts', file, true);
        String postId = const Uuid().v1();
        DateTime dateTime = DateTime.now();

        PersonDetails details = PersonDetails(
          photoUrl: photoUrl,
          name: name,
          age: age,
          postId: postId,
          dateTime: dateTime.toString(),
        );

        await _firestore.collection('persondetails').doc(postId).set(
              details.toJson(),
            );
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    notifyListeners();
    return res;
  }

  // Delete post

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('persondetails').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  // signout

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
