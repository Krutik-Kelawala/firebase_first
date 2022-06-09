import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class viewpg extends StatefulWidget {
  @override
  State<viewpg> createState() => _viewpgState();
}

class _viewpgState extends State<viewpg> {

  var datalist = [];
  var map = {};
  @override
  void initState() {
    super.initState();

    Viewmydata();
  }

  Viewmydata() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("My realtime DB");
    DatabaseEvent dbEvent = await ref.once();
    print("Data==${dbEvent.snapshot.value}");
    map.forEach((key, value) { datalist.add()});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Realtime data view"),
        centerTitle: true,
      ),
    );
  }
}
