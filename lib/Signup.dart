import 'package:flutter/material.dart';
import 'package:flutter_application_1/Homepage.dart';
import 'package:flutter_application_1/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<Signup> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text("SignUp")),
      ),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Center(
            child: Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: Image.asset('assets/images/Logo.png')),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: _emailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter valid email id as abc@gmail.com'),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                hintText: 'Enter valid email id as abc@gmail.com'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 15, bottom: 0),
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter secure password'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 15, bottom: 0),
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
                hintText: 'Enter secure password'),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim())
                    .then((value) async {
                  if (value.user != null) {
                    Map<String, dynamic> userInfoMap = {
                      "uid": FirebaseAuth.instance.currentUser!.uid,
                      "email": _emailController.text.trim(),
                      "username": _usernameController.text.trim(),
                      "Notes": []
                    };
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(userInfoMap['uid'])
                        .set(userInfoMap, SetOptions(merge: true));
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('email', _emailController.text.trim());

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (Route<dynamic> route) => false);
                  }
                });
              } on FirebaseAuthException catch (e) {
                print(e.message);
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(content: Text(e.message.toString()));
                    });
              }
            },
            child: Text('Signup')),
        SizedBox(
          height: 25,
        ),
        TextButton(
          child: Text(
            "Login",
            style: TextStyle(fontSize: 15),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => Login()));
          },
        )
      ])),
    );
  }
}
