import 'dart:typed_data';
import 'package:add_detals/models/posts.dart';
import 'package:add_detals/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        String postId = const Uuid().v1();
        PersonDetails details = PersonDetails(
          photoUrl: photoUrl+"postId",
          name: name,
          age: age,
          postId: postId,
        );

        await _firestore.collection('persondetails').doc(postId).set(
              details.toJson(),
            );
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete post

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('persondetails').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
