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
                          var name = nameController.text.toString();
                          var prefs = await SharedPreferences.getInstance();
                          prefs.setString(KEYNAME, name);

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
        child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                  key: Key(todos[index]),
                  child: Card(
                    margin: EdgeInsets.all(10),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      title: Text(todos[index]),
                    ),
                  ));
            }),
      ),
    );
  }

  void getValue() async {
    var prefs = await SharedPreferences.getInstance();

    var getName = prefs.getString(KEYNAME);
  }
}
