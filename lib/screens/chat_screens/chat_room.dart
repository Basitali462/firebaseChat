import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/chat_room_model.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/screens/chat_screens/conversation_screen.dart';
import 'package:flutter_chat_app/screens/chat_screens/search_user.dart';
import 'package:flutter_chat_app/screens/login_signup/home_screen.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/firestore_service.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final AuthService authService = AuthService();
  final FirestoreDbService dbService = FirestoreDbService();

  List<ChatRoomModel> friends;
  QuerySnapshot currentUser;
  String user = '';

  Widget chatBuilder(List<ChatRoomModel> userChats){
    List<ChatRoomModel> displayChatList = [];
    displayChatList = userChats;

    return new ListView.builder(
        padding: new EdgeInsets.all(0.0),
        itemCount: displayChatList.length,
        itemBuilder: (BuildContext context, index) {
          //return Text(displayMessageList[index].message);
          return GestureDetector(
            onTap: (){
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context){
                    return ConversationScreen(
                      currentUser: user,
                      convoId: displayChatList[index].chatId,
                    );
              }));
            },
            child: Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Container(
                padding: EdgeInsets.symmetric(vertical:18, horizontal: 18),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Text(
                        displayChatList[index].chatId.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(
                      //displayChatList[index].chatId,
                      getFriendName(displayChatList[index].chatUser),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  getFriendName(List names){
    for(int i = 0; i < names.length; i++){
      if(names[i] != user){
        return names[i];
      }
    }
  }

  getCurUserName(String val){
    dbService.getUserEmail(val).then((value) {
      if(value != null){
        setState(() {
          currentUser = value;
          var curUserName = ChatUser.fromJson(currentUser.docs[0].data());
          user = curUserName.username;
        });
      }
    });
    return ;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final currentUser = Provider.of<UserModel>(context);
    getCurUserName(currentUser.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          user,
        ),
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: TextButton.icon(
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              label: Text(
                '',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () async{
                await authService.logOut().then((value){
                  if(value != null){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> HomePage()));
                  }
                });
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder(
          stream: dbService.getChats(user),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator(),);
              default:
                if(snapshot.hasError){
                  return Text('Error Fetching User');
                }else{
                  friends = snapshot.data.docs
                      .map((doc) => ChatRoomModel.fromJson(doc.data())).toList();
                  if(friends.isEmpty){
                    return Center(child: Text(
                      'Add Friends...!!!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ));
                  }
                  return chatBuilder(friends);
                }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        onPressed: (){
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SearchFriend()));
        },
        icon: Icon(Icons.search),
        label: Text('Add Friend'),
      ),
    );
  }
}
