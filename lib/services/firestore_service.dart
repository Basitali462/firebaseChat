import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_app/models/message_model.dart';

class FirestoreDbService{
  Future addDoc(String docId, Map data) async{
    return await FirebaseFirestore.instance
        .collection('user')
        .doc(docId).set(data);
  }

  Future getUserByName(String query) async{
    return await FirebaseFirestore.instance.collection('user')
        .where('searchQuery', arrayContains: query).get();
  }

  Future getUserEmail(String query) async{
    return await FirebaseFirestore.instance.collection('user')
        .where('email', isEqualTo: query).get();
  }

  Future createChat(String docId, Map data) async{
    return await FirebaseFirestore.instance
        .collection('chat')
        .doc(docId).set(data);
  }

  Stream<QuerySnapshot> getChats(String userId) {
    return FirebaseFirestore.instance.collection('chat')
        .where('chatUser', arrayContains: userId).snapshots();
  }

  Future sendMessage(String convoId, Map data) async{
    return await FirebaseFirestore.instance.collection('chat')
        .doc(convoId)
        .collection('conversation')
        .add(data);
  }

  Stream<QuerySnapshot> getMessages(String id) {
    return FirebaseFirestore.instance.collection('chat')
        .doc(id)
        .collection('conversation')
        .orderBy(MessageField.createdAt, descending: false)
        .snapshots();
  }
}