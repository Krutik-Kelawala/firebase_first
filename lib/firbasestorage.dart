import 'dart:io';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_first/Viewpage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class firebasespage extends StatefulWidget {
  @override
  State<firebasespage> createState() => _firebasespageState();
}

class _firebasespageState extends State<firebasespage> {
  final ImagePicker _picker = ImagePicker();
  TextEditingController uname = TextEditingController();
  TextEditingController phno = TextEditingController();
  String imagestore = ""; //for get image path
  String urlimage = ""; // for store image url
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("cloud storage"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () async {
                // Pick an image
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  imagestore = image!.path;
                });
                // if (image == null) {
                //   setState(() {
                //     imagestore = image!.path;
                //   });
                // } else {
                //   FileImage(File(""));
                // }
              },
              child: Container(
                height: 150,
                width: 150,
                child: imagestore == ""
                    ? Icon(
                        Icons.camera_alt_outlined,
                        size: 50,
                      )
                    : CircleAvatar(
                        maxRadius: 300,
                        backgroundImage: FileImage(File("${imagestore}")),
                      ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                  controller: uname,
                  decoration: InputDecoration(
                      label: Text("Name"),
                      hintText: "Enter name here",
                      border: OutlineInputBorder())),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                  keyboardType: TextInputType.number,
                  controller: phno,
                  decoration: InputDecoration(
                      label: Text("Mobile no"),
                      hintText: "Enter contact",
                      border: OutlineInputBorder())),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  final storageRef = FirebaseStorage.instance.ref();
                  String dt =
                      "${date.day}-${date.month}-${date.year}-${date.hour}:${date.minute}";

                  String imagename = "uploadeimg${dt}.jpg";
                  final spaceRef =
                      storageRef.child("Uploadeimgfolder/$imagename");
                  await spaceRef.putFile(File(imagestore));
                  spaceRef.getDownloadURL().then((value) async {
                    print("img==${value}");

                    setState(() {
                      urlimage = value;
                    });
                    DatabaseReference ref =
                        FirebaseDatabase.instance.ref("My realtime DB").push();
                    String? id = ref.key;
                    await ref.set({
                      "name": uname.text,
                      "mobile": phno.text,
                      "imgurl": urlimage,
                      "id": id
                    });
                    // EasyLoading.instance.indicatorType =
                    //     EasyLoadingIndicatorType.spinningCircle;
                    EasyLoading.show(
                      status: "Uploading....",
                    ).whenComplete(() {
                      EasyLoading.dismiss();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Uplode Successfully !"),
                        duration: Duration(seconds: 3),
                      ));
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return viewpg();
                        },
                      ));
                    });
                  });
                },
                child: Text("Submit")),
            SizedBox(
              height: 20,
            ),
            FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return viewpg();
                    },
                  ));
                },
                child: Text("Skip & show viewpage"))
          ],
        ),
      ),
    );
  }
}
