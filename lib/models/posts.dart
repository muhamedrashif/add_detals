import 'package:cloud_firestore/cloud_firestore.dart';

class PersonDetails {
  final String name;
  final String age;
  final String photoUrl;
  final String postId;
  final String dateTime;

  const PersonDetails(
      {required this.name,
      required this.age,
      required this.photoUrl,
      required this.postId,
      required this.dateTime});

  Map<String, dynamic> toJson() => {
        "name": name,
        "age": age,
        "photoUrl": photoUrl,
        "postId": postId,
        "dateTime": dateTime
      };

  static PersonDetails fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PersonDetails(
        name: snapshot['name'],
        age: snapshot['age'],
        photoUrl: snapshot['photoUrl'],
        postId: snapshot['postId'],
        dateTime: snapshot['dateTime']);
  }
}
