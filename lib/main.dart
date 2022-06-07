import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_first/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: homepage(),
  ));
}

class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  bool screenstatus = false;
  TextEditingController gmail = TextEditingController();
  TextEditingController password = TextEditingController();

  // bool gmailerrortxt = false;
  // bool passworderrortxt = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      screenstatus = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return screenstatus
        ? Scaffold(
            appBar: AppBar(
              title: Text("Registation"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "User Registration",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      // onChanged: (value) {
                      //   setState(() {
                      //     gmailerrortxt = false;
                      //   });
                      // },
                      controller: gmail,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Username"),
                          hintText: "Enter your Email"),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      // onChanged: (value) {
                      //   setState(() {
                      //     passworderrortxt = false;
                      //   });
                      // },
                      controller: password,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Password"),
                          hintText: "Enter your Password"),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        // String pgmail = gmail.text;
                        // String mailpass = password.text;

                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: gmail.text,
                            password: password.text,
                          );

                          print("Reg Done");
                          // EasyLoading.show(status: "Please wait....")
                          //     .whenComplete(() {
                          //   ScaffoldMessenger.of(context)
                          //       .showSnackBar(SnackBar(
                          //           content:
                          //               Text("Registration Successfully !"),
                          //           duration: Duration(seconds: 3)))
                          //       .closed;
                          // });
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text("Registation")),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have account?"),
                      FlatButton(
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return loginpg();
                              },
                            ));
                          },
                          child: Text("LogIn"))
                    ],
                  )
                ],
              ),
            ),
          )
        : Center(
            child: SpinKitFadingCircle(
              size: 150,
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color:
                        index.isEven ? Colors.yellow : Colors.deepOrangeAccent,
                  ),
                );
              },
            ),
          );
    ;
  }
}
