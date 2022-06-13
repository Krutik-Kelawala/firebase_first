import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_first/firbasestorage.dart';
import 'package:firebase_first/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: homepage(),
    builder: EasyLoading.init(),
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
  TextEditingController mobileno = TextEditingController();
  TextEditingController otp = TextEditingController();
  String verifyid = "";

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
                    width: double.infinity,
                  ),
                  Text(
                    "User Registration",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  // SizedBox(
                  //   height: 30,
                  //   width: double.infinity,
                  // ),
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
                  // SizedBox(
                  //   height: 30,
                  //   width: double.infinity,
                  // ),
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
                          EasyLoading.show(status: "Please wait....")
                              .whenComplete(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Registration Successfully !"),
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
                          if (e.code == 'weak-password') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Weak Passord"),
                              duration: Duration(seconds: 3),
                            ));

                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "The account already exists for that email."),
                              duration: Duration(seconds: 3),
                            ));

                            print('The account already exists for that email.');
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text("Registation")),
                  // SizedBox(
                  //   height: 30,
                  //   width: double.infinity,
                  // ),
                  ElevatedButton(
                      onPressed: () {
                        signInWithGoogle().then((value) {
                          print("google done == ${value}");
                        });
                      },
                      child: Text("SignUp with Google")),
                  SizedBox(
                    height: 30,
                    width: double.infinity,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      controller: mobileno,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          label: Text("Phone number"),
                          hintText: "Enter mobile no",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        print(mobileno.text.length);

                        if (mobileno.text.length < 10) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please enter 10 digit number.."),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: '+91 ${mobileno.text}',
                            verificationCompleted:
                                (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent:
                                (String verificationId, int? resendToken) {
                              setState(() {
                                verifyid = verificationId;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("OTP send successfully !"),
                                duration: Duration(seconds: 3),
                              ));
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                        }
                      },
                      child: Text("Send OTP")),
                  SizedBox(
                    height: 30,
                    width: double.infinity,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      controller: otp,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          label: Text("OTP"),
                          hintText: "Enter OTP",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        FirebaseAuth auth = FirebaseAuth.instance;

                        String smsCode = '${otp.text}';

                        // Create a PhoneAuthCredential with the code
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verifyid, smsCode: smsCode);

                        // Sign the user in (or link) with the credential
                        await auth
                            .signInWithCredential(credential)
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("OTP submit successfully !"),
                            duration: Duration(seconds: 3),
                          ));
                        }).then((value) {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return firebasespage();
                            },
                          ));
                        });
                      },
                      child: Text("Submit OTP")),
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

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
