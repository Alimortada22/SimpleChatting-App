import 'package:chatting_app/widgets/chatt_message.dart';
import 'package:chatting_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget{
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setrequestmessagepermission()async{
     final fcm=FirebaseMessaging.instance;
    await fcm.requestPermission();
   await fcm.subscribeToTopic('chat');
  }
  @override
  void initState() {
    super.initState();
    setrequestmessagepermission();
   
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("flutter chat"),
          actions: [
            IconButton(onPressed: (){
             FirebaseAuth.instance.signOut();
            }, icon: const Icon(Icons.logout))
          ],
        ),
        body:const Column(
          children: [
            Expanded(child: 
            ChattMessage()),
            NewMessage(),
          ],
        )
      ),
    );
  }
}