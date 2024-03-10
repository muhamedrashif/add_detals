import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:add_detals/otp/otp.dart';
import 'package:add_detals/resources/auth_methods.dart';
import 'package:add_detals/resources/firestore_method.dart';
import 'package:add_detals/util/text_field_input.dart';
import 'package:add_detals/util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  // ignore: unused_field
  bool _isLoading = false;
  Uint8List? _imageFile;
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _ageController.dispose();
  }

  void uploaddetails(
    String name,
    String age,
    String photoUrl,
    // String uid,
  ) async {
    print("inside=========");
    setState(() {
      _isLoading = true;
    });
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      if (_imageFile != null) {
        try {
          showAlertDialog(context);

          String res = await FirestoreMethods().uploaddetails(
            name: _nameController.text,
            age: _ageController.text,
            file: _imageFile!,
          );

          if (res == "success") {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
            setState(() {
              _isLoading = false;
            });
            showSnackBar('Added', context);
            clearImage();
          } else {
            setState(() {
              _isLoading = false;
            });
            showSnackBar(res, context);
          }
        } catch (e) {
          showSnackBar(e.toString(), context);
        }
      } else {
        showSnackBar("Please upload a photo", context);
      }
    }
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _imageFile = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _imageFile = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _imageFile = null;
      _nameController.text;
      _ageController.text;
    });
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            color: Colors.teal,
          ),
          Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(left: 5),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  ScrollController? _chatScrollController;
  int loadMoreMsgs = 10;
  int a = 10;

  @override
  void initState() {
    _chatScrollController = ScrollController()
      ..addListener(() {
        if (_chatScrollController!.position.atEdge) {
          if (_chatScrollController!.position.pixels == 0)
            print('ListView scrolled to top');
          else {
            setState(() {
              loadMoreMsgs = loadMoreMsgs + a;
            });
            print('ListView scrolled to bottom');
          }
        }
      });
    super.initState();
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context, barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit'),
            backgroundColor: Colors.teal[50],
            actions: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  //return false when click on "NO"
                  child: Container(
                      height: 30,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.teal,
                      ),
                      child: const Center(
                          child: Text(
                        'No',
                        style: TextStyle(color: Colors.white),
                      ))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () => exit(0),
                  //return true when click on "Yes"
                  child: Container(
                      height: 30,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.teal,
                      ),
                      child: const Center(
                          child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.white),
                      ))),
                ),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          body: Form(
            key: _formkey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          8.0,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Ender Details",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.quicksand().fontFamily),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () async {
                              // await AuthMethods().signOut();
                              // Navigator.of(context).pushReplacement(MaterialPageRoute(
                              //     builder: (context) =>  OtpLoginScreen()));
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text('Do you want to Logout'),
                                  backgroundColor: Colors.teal[50],
                                  actions: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onTap: () => Navigator.pop(context),
                                        //return false when click on "NO"
                                        child: Container(
                                            height: 30,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.teal,
                                            ),
                                            child: const Center(
                                                child: Text(
                                              'No',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onTap: () async {
                                          await AuthMethods().signOut();
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OtpLoginScreen()));
                                        },
                                        //return false when click on "NO"
                                        child: Container(
                                            height: 30,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.teal,
                                            ),
                                            child: const Center(
                                                child: Text(
                                              'Logout',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.logout,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 8),
                        child: Stack(
                          children: [
                            _imageFile != null
                                ? CircleAvatar(
                                    radius: 40,
                                    backgroundImage: MemoryImage(_imageFile!),
                                    backgroundColor: Colors.transparent,
                                  )
                                : const CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(
                                        'https://i.stack.imgur.com/l60Hf.png'),
                                    backgroundColor: Colors.transparent,
                                  ),
                            Positioned(
                              bottom: -10,
                              left: 40,
                              child: IconButton(
                                onPressed: () => _selectImage(context),
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: TextFieldInput(
                                textEditingController: _nameController,
                                hintText: 'Name',
                                textInputType: TextInputType.name,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: TextFieldInput(
                                textEditingController: _ageController,
                                hintText: 'Age',
                                textInputType: TextInputType.number,
                                maxLength: 3,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter age';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        uploaddetails(_nameController.text, _ageController.text,
                            _imageFile.toString());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            )),
                            color: Colors.teal),
                        child: const Text('Add',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('persondetails')
                          // .limit(10)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Align(
                            alignment: Alignment.bottomCenter,
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          log(snapshot.data!.docs.length.toString());
                        }
                        return ListView.builder(
                          controller: _chatScrollController,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.teal[200]),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        snapshot.data!.docs[index]['photoUrl']),
                                    radius: 22,
                                  ),
                                  title: Text(
                                      snapshot.data!.docs[index]['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle:
                                      Text(snapshot.data!.docs[index]['age']),
                                  trailing: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Delete'),
                                            content: const Text(
                                                'Do you want to Delete'),
                                            backgroundColor: Colors.teal[50],
                                            actions: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    FirestoreMethods()
                                                        .deletePost(snapshot
                                                                .data!
                                                                .docs[index]
                                                            ['postId']);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                      height: 30,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.teal,
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: InkWell(
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                  child: Container(
                                                      height: 30,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.teal,
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        'No',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: const Icon(Icons.delete)),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // InkWell(onTap: () {
                  //    Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(builder: (context) =>  Sample()));
                  // }, child: Text("data"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
