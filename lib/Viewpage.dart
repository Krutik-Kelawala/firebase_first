import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_first/firbasestorage.dart';
import 'package:firebase_first/updatepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

class viewpg extends StatefulWidget {
  @override
  State<viewpg> createState() => _viewpgState();
}

class _viewpgState extends State<viewpg> {
  List datalist = [];
  bool screeen_load = false;

  @override
  void initState() {
    super.initState();

    Viewmydata();
  }

  Viewmydata() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("My realtime DB");
    DatabaseEvent dbEvent = await ref.once();
    print("Dataaaaa==${dbEvent.snapshot.value}");

    Map viewmap = dbEvent.snapshot.value as Map;
    viewmap.forEach((key, value) {
      setState(() {
        datalist.add(value);
        screeen_load = true;
      });
    });

    // datalist = map as List;
    print("map==${datalist}");
    print("mmm==${viewmap}");

    print("length == ${datalist.length}");

    // debugPrint('movieTitle: ${dbEvent.snapshot.value}');
  }

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
          title: Text("Realtime data view"),
          centerTitle: true,
        ),
        body: screeen_load
            ? RefreshIndicator(
                color: Colors.orange,
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1)).then((value) {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return viewpg();
                      },
                    ));
                  });
                },
                child: WillPopScope(
                  onWillPop: backpg,
                  child: ListView.builder(
                    itemCount: datalist.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(the_bodyheight * 0.015),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(the_bodyheight * 0.02),
                        height: the_bodyheight * 0.35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)),
                              height: the_bodyheight * 0.25,
                              width: thewidth * 0.35,
                              child: Card(
                                  borderOnForeground: true,
                                  child: Image.network(
                                      "${datalist[index]['imgurl']}",
                                      fit: BoxFit.fill),
                                  color: Colors.cyanAccent,
                                  elevation: 10,
                                  shadowColor: Colors.cyan,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                            // Container(
                            //   height: the_bodyheight * 0.25,
                            //   width: thewidth * 0.35,
                            //   decoration: BoxDecoration(
                            //       border: Border.all(width: 1),
                            //       image: DecorationImage(
                            //           image: NetworkImage(
                            //               "${datalist[index]['imgurl']}"),
                            //           fit: BoxFit.cover)),
                            // ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: thewidth * 0.03,
                                    top: the_bodyheight * 0.1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Id : ",
                                          style: TextStyle(
                                              fontSize: the_bodyheight * 0.025,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${datalist[index]['id']}",
                                            style: TextStyle(
                                                fontSize:
                                                    the_bodyheight * 0.025),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Name : ",
                                          style: TextStyle(
                                              fontSize: the_bodyheight * 0.025,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${datalist[index]['name']}",
                                            style: TextStyle(
                                                fontSize:
                                                    the_bodyheight * 0.025),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Mobile No : ",
                                          style: TextStyle(
                                              fontSize: the_bodyheight * 0.025,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${datalist[index]['mobile']}",
                                            style: TextStyle(
                                                fontSize:
                                                    the_bodyheight * 0.025),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: PopupMenuButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onSelected: (value) {
                                  if (value == 1) {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return updatepg(datalist, index);
                                      },
                                    ));
                                  }
                                },
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                        value: 1, child: Text("Update")),
                                    PopupMenuItem(
                                        onTap: () {
                                          setState(() {
                                            Future<void> ref = FirebaseDatabase
                                                .instance
                                                .ref("My realtime DB")
                                                .child(
                                                    "${datalist[index]['id']}")
                                                .remove();
                                          });
                                        },
                                        child: Text("Delete"))
                                  ];
                                },
                              ),
                            )
                          ],
                        ),
                      );
                    },
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
              ));
  }

  Future<bool> backpg() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return firebasespage();
      },
    ));
    return Future.value(true);
  }
}
