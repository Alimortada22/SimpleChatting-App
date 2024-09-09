import 'package:chatting_app/widgets/messagebubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChattMessage extends StatelessWidget {
  const ChattMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentuser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdat', descending: false)
            .snapshots(),
        builder: (ctx, chatsnapshots) {
          if (chatsnapshots.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (!chatsnapshots.hasData || chatsnapshots.data!.docs.isEmpty) {
            return const Center(child: Text("No message!"));
          }
          if (chatsnapshots.hasError) {
            return const Center(child: Text("Something went wrong...!"));
          }
          final loadedmessage = chatsnapshots.data!.docs;
          return ListView.builder(
              itemCount: loadedmessage.length,
              reverse: true,
              itemBuilder: (ctx, index) {
                final chatmessage = loadedmessage[index].data();
                final nextxchattmessage = index + 1 < loadedmessage.length
                    ? loadedmessage[index + 1].data()
                    : null;
                final currentmessageuserid = chatmessage['userid'];
                final nextmessageuserid = nextxchattmessage != null
                    ? nextxchattmessage['userid']
                    : null;
                if (currentmessageuserid == nextmessageuserid) {
                  return MessageBubble.next(
                      message: chatmessage['text'],
                      isme: currentuser.uid == chatmessage['userid']);
                }
                return MessageBubble.first(
                    userimage: chatmessage['userimage'],
                    username: chatmessage['username'],
                    message: chatmessage['text'],
                    isme: currentuser.uid == chatmessage['userid']);
              });
        });
  }
}
