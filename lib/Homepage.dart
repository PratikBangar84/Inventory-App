import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  var nameController = TextEditingController();

  static const String KEYNAME = 'name';
  // ignore: deprecated_member_use
  List todos = ['hey'];
  String input = "";

  @override
  void initState() {
    super.initState();
    getValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 118, 192, 253),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 2, 140, 252),
        title: Text(
          "Inventory",
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Add Inventory packages"),
                  content: TextField(
                    controller: nameController,
                    onChanged: (String value) {
                      input = value;
                    },
                  ),
                  actions: [
                    // ignore: deprecated_member_use
                    ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            'Notes':
                                FieldValue.arrayUnion([nameController.text])
                          });

                          Navigator.of(context).pop();
                        },
                        child: Text("ADD"))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!['Notes'].isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Text(
                      'No Notes to Display',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!['Notes'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: EdgeInsets.all(10),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        title: Text(snapshot.data!['Notes'][index]),
                      ),
                    );
                  });
            }),
      ),
    );
  }

  void getValue() async {
    var prefs = await SharedPreferences.getInstance();

    var getName = prefs.getString(KEYNAME);
  }
}
