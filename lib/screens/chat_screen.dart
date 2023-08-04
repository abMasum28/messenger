import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
final firestore= FirebaseFirestore.instance;
User? loggedinUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth? auth;
  TextEditingController? textEditingController;
  @override
  void initState() {
    super.initState();
    textEditingController=TextEditingController();
    auth= FirebaseAuth.instance;
    getCurrentUser();
  }
  void getCurrentUser() {
    try{
      loggedinUser=auth!.currentUser;

    }
    catch(error){
      Alert(
        context: context,
        type: AlertType.error,
        title: "User Not Found",
        desc: error.toString(),
      ).show();

    }
  }
  void saveMessage(){
    firestore.collection("meassages").add(
        {
          "sender":loggedinUser!.email,
          "text":textEditingController!.text,
          "time":DateTime.now().microsecondsSinceEpoch,
        }
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {

          },
        ),
        title: Text("Messenger"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {

            },
          ),
        ],
        
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStream(),
            Row(
              children: [
                SizedBox(
                  width: 260,
                  child: TextField(
                    controller: textEditingController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type message here',
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    saveMessage();
                    textEditingController!.clear();
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


}
class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection("meassages").orderBy('time',descending: true)
      .snapshots(),
      builder: (_,snapshot){
        if(snapshot.hasData)
          {
            List<MessageBubble> messagewidgets=[];
            for(var message in snapshot.data!.docs){
              final mymessage=message.get('text');
              final mysender=message.get('sender');
              final msgbubble=MessageBubble(
                msgtext: mymessage,
                msgsender: mysender,
                user: mysender==loggedinUser!.email?true:false,
              );
              messagewidgets.add(msgbubble);

            }
            return Expanded(child: ListView(
              reverse: true,
              children: messagewidgets,
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),

            ),
            );

          }
        else{
          return Container();

        }
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  final String? msgtext;
  final String? msgsender;
  final bool? user;
  MessageBubble({this.msgtext,this.msgsender,this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(10),
    child: Column(
        crossAxisAlignment: user==true?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(msgsender!,style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
          ),
          Material(
            color: user==true?Colors.white:Colors.blue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topLeft: user==true?Radius.circular(50):Radius.circular(0),
              bottomRight: Radius.circular(50),
              topRight: user==true?Radius.circular(0):Radius.circular(50),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              child: Text(
                msgtext!,style: TextStyle(
                fontSize: 15,
                color: user==true?Colors.blue:Colors.white,
              ),
              ),

            ),
          ),

      ],
    ),
    );
  }
}
