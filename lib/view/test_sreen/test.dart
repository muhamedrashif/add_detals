// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class Sample extends StatefulWidget {
//   @override
//   _SampleState createState() => _SampleState();
// }

// class _SampleState extends State<Sample> {
//   ScrollController? _chatScrollController;
//   int loadMoreMsgs = 1; // at first it will load only 25
//   int a =
//      1; // 'loadMoreMsgs' will added by 'a' if we load more msgs in listview.

//   @override
//   void initState() {
//     _chatScrollController = ScrollController()
//       ..addListener(() {
//         if (_chatScrollController!.position.atEdge) {
//           if (_chatScrollController!.position.pixels == 0)
//             print('ListView scrolled to top');
//           else {
//             setState(() {
//               loadMoreMsgs = loadMoreMsgs + a;
//             });
//             print('ListView scrolled to bottom');
//           }
//         }
//       });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('persondetails')
//            . orderBy('dateTime', descending: false )
//             .snapshots(),
//         builder: (context,
//             snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             log(snapshot.data!.docs.length.toString());
//           }
//           return ListView.builder(
//             controller: _chatScrollController,
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.teal[200]),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: NetworkImage(
//                           snapshot.data!.docs[index]['photoUrl']),
//                       radius: 22,
//                     ),
//                     title: Text(snapshot.data!.docs[index]['name'],
//                         style: const TextStyle(fontWeight: FontWeight.bold)),
//                     subtitle: Text(snapshot.data!.docs[index]['age']),
//                   ),
//                 ),
//               );
//               ;
//             },
//           );
//         },
//       ),
//     );
//   }
// }
