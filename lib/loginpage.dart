import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_first/firbasestorage.dart';
import 'package:firebase_first/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class loginpg extends StatefulWidget {
  @override
  _loginpgState createState() => _loginpgState();
}

class _loginpgState extends State<loginpg> {
  bool loading = false;
  TextEditingController mailid = TextEditingController();
  TextEditingController upass = TextEditingController();

  // bool mailiderror = false;
  // bool upasserror = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
  }

  @override
  Widget build(BuildContext context) {
    return loading
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
                    width: double.infinity,
                  ),
                  Text(
                    "User LogIn ",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                    width: double.infinity,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      // onChanged: (value) {
                      //   setState(() {
                      //     mailiderror = false;
                      //   });
                      // },
                      controller: mailid,
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
                      //     upasserror = false;
                      //   });
                      // },
                      controller: upass,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Password"),
                          hintText: "Enter your Password"),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    width: double.infinity,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: mailid.text, password: upass.text);
                          print("login Done");

                          EasyLoading.show(status: "Please wait....")
                              .whenComplete(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("LogIn Successfully !"),
                                duration: Duration(seconds: 3)));
                          }).then((value) {
                            EasyLoading.dismiss();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return firebasespage();
                              },
                            ));
                          });
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("User not found"),
                              duration: Duration(seconds: 3),
                            ));

                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Wrong password"),
                              duration: Duration(seconds: 3),
                            ));

                            print('Wrong password provided for that user.');
                          }
                        }
                      },
                      child: Text("LogIn")),
                  SizedBox(
                    height: 30,
                    width: double.infinity,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("New user?"),
                      FlatButton(
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return homepage();
                              },
                            ));
                          },
                          child: Text("SignUp"))
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
  }
}
