import 'dart:io';

import 'package:chatting_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() {
    return _AuthScreen();
  }
}

class _AuthScreen extends State<AuthScreen> {
  var _islogin = true;
  var enteredusername = "";
  var enteredemail = "";
  var enteredpassword = "";
  File? _selectedimage;
  var _isauthicating = false;
  final _formkey = GlobalKey<FormState>();
  void _submit() async {
    final isvalid = _formkey.currentState!.validate();
    if (!isvalid || !_islogin && _selectedimage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please complete all steps")));
      return;
    }
    _formkey.currentState!.save();
    try {
      setState(() {
        _isauthicating = true;
      });
      if (_islogin) {
        //log user in

        await firebase.signInWithEmailAndPassword(
            email: enteredemail, password: enteredpassword);
      } else {
        //create new user
        final _usercredential = await firebase.createUserWithEmailAndPassword(
            email: enteredemail, password: enteredpassword);
        final storageref = FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child("${_usercredential.user!.uid}.jpg");
        await storageref.putFile(_selectedimage!);
        final imageurl = await storageref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_usercredential.user!.uid)
            .set({
          'username': enteredusername,
          'email': enteredemail,
          'image-url': imageurl,
        });
        print(_usercredential);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Authentication failed")));
      setState(() {
        _isauthicating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                child: Image.asset(
                  'assets/images/1.png',
                  width: 150,
                  height: 150,
                ),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_islogin)
                            UserImagePicker(
                              onpickedimage: (pickedimage) {
                                _selectedimage = pickedimage;
                              },
                            ),
                          if (!_islogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "User Name",
                              ),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().length < 4 ||
                                    value.isEmpty) {
                                  return "please at least 4 characters";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                enteredusername = newValue!;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "EmailAddress"),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains("@")) {
                                return "Please enter availd email address";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              enteredemail = newValue!;
                            },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: "Password"),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return "Password must be aleast 6 characters";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              enteredpassword = newValue!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (_isauthicating) const CircularProgressIndicator(),
                          if (!_isauthicating)
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                onPressed: _submit,
                                child: Text(_islogin ? "Login" : "SignUp")),
                          if (!_isauthicating)
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _islogin = !_islogin;
                                  });
                                },
                                child: Text(_islogin
                                    ? "Create an acount"
                                    : "Already have an account"))
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
