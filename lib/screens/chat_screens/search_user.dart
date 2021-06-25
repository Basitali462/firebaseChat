import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/chat_room_model.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/screens/chat_screens/conversation_screen.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/firestore_service.dart';
import 'package:provider/provider.dart';

class SearchFriend extends StatefulWidget {
  @override
  _SearchFriendState createState() => _SearchFriendState();
}

class _SearchFriendState extends State<SearchFriend> {
  final FirestoreDbService dbService = FirestoreDbService();
  final AuthService authService = AuthService();

  TextEditingController searchController = TextEditingController();
  QuerySnapshot searchData;
  QuerySnapshot currentUser;

  onUserSearch(String val) async{
    if(val.isNotEmpty || val != null){
      dbService.getUserByName(val)
          .then((value) {
            print(value);
            setState(() {
              searchData = value;
            });
      });
    }
  }

  setConversationId(String a, String b){
    if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)){
      return '$b\_$a';
    }else{
      return '$a\_$b';
    }
  }

  getCurrentUser(String val, ChatUser user) async{
    dbService.getUserEmail(val).then((value) {
      if(value != null){
        setState(() {
          print("Cur user $value");
          currentUser = value;
          startConversation(currentUser, user);
        });
      }
    });
    return ;
  }

  startConversation(QuerySnapshot curUser, ChatUser user) async{
    //await getCurrentUser(curUser);
    var curUserName = ChatUser.fromJson(curUser.docs[0].data());
    print("Cur user ${curUserName.username}");
    String chatId = setConversationId(curUserName.username, user.username);

    Map<String, dynamic> chatData = ChatRoomModel(
      chatId: chatId,
      chatUser: [
        curUserName.username,
        user.username,],
    ).toJson();

    dbService.createChat(chatId, chatData);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ConversationScreen(
      convoId: chatId,
      currentUser: curUserName.username,
    )));
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserModel>(context);
    //getCurrentUser(currentUser.email);
    print('Search data' );
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Search',
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.blue[300],
            child:Row(
              children: [
                Expanded(child: TextField(
                  controller: searchController,
                  onChanged: onUserSearch,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search Friend...!!!',
                    hintStyle: TextStyle(
                      color: Colors.white60,
                    ),
                    border: InputBorder.none,
                  ),
                ),),
                /*Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Icon(Icons.search),
                ),*/
              ],
            ),
          ),
          searchData != null ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchData.docs.length,
            itemBuilder: (BuildContext context, index){
              var user = ChatUser.fromJson(searchData.docs[index].data());
              if(user.email == currentUser.email){
                return Container();
              }
              return Container(
                padding: EdgeInsets.symmetric(vertical:18, horizontal: 18),
                child: Row(
                  children: [
                    Text(
                      user.username,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async{
                        await getCurrentUser(currentUser.email, user);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          'Message',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ) : Center(child: Text('no user found'),),
        ],
      ),
    );
  }
}
