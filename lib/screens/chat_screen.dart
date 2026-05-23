import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends State<ChatScreen> {

  final TextEditingController
  messageController =
  TextEditingController();

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth auth =
      FirebaseAuth.instance;

  void sendMessage() async {

    if(messageController.text.trim().isEmpty) {
      return;
    }

    await firestore.collection("messages").add({

      "text":
      messageController.text.trim(),

      "sender":
      auth.currentUser!.email,

      "time":
      FieldValue.serverTimestamp(),
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Group Chat"),
        centerTitle: true,
      ),

      body: Column(

        children: [

          Expanded(

            child: StreamBuilder(

              stream: firestore
                  .collection("messages")
                  .orderBy("time")
                  .snapshots(),

              builder: (context, snapshot) {

                if(snapshot.connectionState ==
                    ConnectionState.waiting) {

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if(!snapshot.hasData) {

                  return const Center(
                    child: Text("No Messages"),
                  );
                }

                var messages =
                    snapshot.data!.docs;

                return ListView.builder(

                  itemCount: messages.length,

                  itemBuilder: (context, index) {

                    var message =
                    messages[index];

                    bool isMe =
                        message['sender'] ==
                            auth.currentUser!
                                .email;

                    return Container(

                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,

                      padding:
                      const EdgeInsets.all(10),

                      child: Container(

                        padding:
                        const EdgeInsets.all(12),

                        decoration: BoxDecoration(

                          color: isMe
                              ? Colors.blue
                              : Colors.grey[300],

                          borderRadius:
                          BorderRadius.circular(
                              12),
                        ),

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Text(

                              message['sender'],

                              style:
                              TextStyle(

                                fontWeight:
                                FontWeight.bold,

                                color: isMe
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            Text(

                              message['text'],

                              style: TextStyle(

                                color: isMe
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Padding(

            padding: const EdgeInsets.all(10),

            child: Row(

              children: [

                Expanded(

                  child: TextField(

                    controller:
                    messageController,

                    decoration:
                    InputDecoration(

                      hintText:
                      "Type message...",

                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(
                            12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                IconButton(

                  onPressed: sendMessage,

                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}