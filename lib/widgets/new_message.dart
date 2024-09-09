import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});
  @override
  State<NewMessage> createState() {
    return _NewMessage();
  }
}

class _NewMessage extends State<NewMessage> {
  final _enterdmessage = TextEditingController();
  @override
  void dispose() {
    _enterdmessage.dispose();
    super.dispose();
  }

  void submitmsg() async {
    final enteredmessage = _enterdmessage.text;
    if (enteredmessage.trim().isEmpty) {
      return;
    }
    final user = FirebaseAuth.instance.currentUser!;
    final userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredmessage,
      'createdat': Timestamp.now(),
      'userid': user.uid,
      'username': userdata.data()!['username'],
      'userimage': userdata.data()!['image-url']
    });
    _enterdmessage.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 1, right: 15, bottom: 15),
      child: Row(
        children: [
          IconButton(
            onPressed: submitmsg,
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
          ),
          Expanded(
            child: TextField(
              controller: _enterdmessage,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: "send amessage ..."),
            ),
          ),
        ],
      ),
    );
  }
}
