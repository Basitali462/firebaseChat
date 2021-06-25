import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/services/firestore_service.dart';
import 'package:flutter_chat_app/utils/constants/chat_widget.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {
  final String convoId;
  final String currentUser;
  ConversationScreen({this.convoId, this.currentUser});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  final FirestoreDbService dbService = FirestoreDbService();
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  var msgSender = '';

  List<Message> messages;

  Widget chatBottom(){
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textCapitalization: TextCapitalization.sentences,
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Type Your Message',
                hintStyle: TextStyle(
                  color: Colors.black38,
                ),
              ),
              //onChanged: onMsgType,
            ),
          ),
          SizedBox(width: 20,),
          GestureDetector(
            onTap: sendMessage,
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget userChat() {
    return StreamBuilder(
      stream: dbService.getMessages(widget.convoId),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator(),);
          default:
            if(snapshot.hasError){
              return Text('Error Fetching User');
            }else{
              messages = snapshot.data.docs
                  .map((doc) => Message.fromJson(doc.data())).toList();
              if(messages.isEmpty){
                return Center(child: Text(
                  'Say Hi...!!!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ));
              }
              return chatBuilder(messages);
            }
        }
      },
    );
  }

  animateListToBottom(){
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,);
  }

  Widget chatBuilder(List<Message> userMessages){
    List<Message> displayMessageList = [];
    displayMessageList = userMessages;

    return new ListView.builder(
      padding: new EdgeInsets.all(0.0),
      controller: scrollController,
      itemCount: displayMessageList.length,
      itemBuilder: (BuildContext context, index) {
        //return Text(displayMessageList[index].message);
        return UserMessages(
          message: displayMessageList[index],
          isMe: displayMessageList[index].username == msgSender,
        );
      });
  }

  void sendMessage() async{
    if(controller.text.isNotEmpty){
      FocusScope.of(context).unfocus();

      Map<String, dynamic> data = Message(
        username: msgSender,
        message: controller.text,
        createdAt: DateTime.now(),
      ).toJson();
      await dbService.sendMessage(widget.convoId, data);
      controller.clear();
      animateListToBottom();
    }else{
      print('empty text');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    msgSender = widget.currentUser;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Conversation',
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(child: userChat()),
          chatBottom(),
        ],
      ),
    );
  }
}
