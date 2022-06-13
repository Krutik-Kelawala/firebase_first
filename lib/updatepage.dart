import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import 'Viewpage.dart';

class updatepg extends StatefulWidget {
  List<dynamic> datalist;
  int index;

  updatepg(this.datalist, this.index);

  @override
  State<updatepg> createState() => _updatepgState();
}

class _updatepgState extends State<updatepg> {
  TextEditingController uname = TextEditingController();
  TextEditingController phno = TextEditingController();

  bool appload = false;

  @override
  void initState() {
    super.initState();
    mychangedata();
    appload = true;
  }

  mychangedata() {
    String mname = widget.datalist[widget.index]['name'];
    uname.text = mname;
    String mphone = widget.datalist[widget.index]['mobile'];
    phno.text = mphone;
  }

  final ImagePicker _picker = ImagePicker();
  DateTime date = DateTime.now();
  String imgblank = "";
  String urlimage = ""; // for store image url

  @override
  Widget build(BuildContext context) {
    double theheight = MediaQuery.of(context).size.height;
    double thewidth = MediaQuery.of(context).size.width;
    double thestatusbar = MediaQuery.of(context).padding.top;
    double theappbar = kToolbarHeight;
    double thenavigatorheight = MediaQuery.of(context).padding.bottom;
    double the_bodyheight =
        theheight - thestatusbar - theappbar - thenavigatorheight;
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Page"),
        centerTitle: true,
      ),
      body: appload
          ? WillPopScope(
              onWillPop: backview,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () async {
                        // Pick an image
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);

                        setState(() {
                          imgblank = image!.path;
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
                          child: imgblank != ""
                              ? CircleAvatar(
                                  radius: 200,
                                  backgroundImage: FileImage(File(imgblank)),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "${widget.datalist[widget.index]['imgurl']}"))),
                                )),
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
                          await spaceRef.putFile(File(imgblank));
                          spaceRef.getDownloadURL().then((value) async {
                            print("img==${value}");

                            setState(() {
                              urlimage = value;
                            });
                            DatabaseReference ref = FirebaseDatabase.instance
                                .ref("My realtime DB")
                                .child(
                                    "${widget.datalist[widget.index]["id"]}");
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
                              status: "Updating........",
                            ).whenComplete(() {
                              EasyLoading.dismiss();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Update Successfully !"),
                                duration: Duration(seconds: 3),
                              ));
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return viewpg();
                                },
                              ));
                            });
                          });
                        },
                        child: Text("Update"))
                  ],
                ),
              ),
            )
          : Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.orange,
              ),
              SizedBox(
                height: the_bodyheight * 0.05,
              ),
              Text(
                "Please wait.....",
                style: TextStyle(fontSize: the_bodyheight * 0.025),
              )
            ]),
      ),
    );
  }

  Future<bool> backview() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return viewpg();
      },
    ));
    return Future.value(true);
  }
}
