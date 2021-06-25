import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/models/user.dart';

class AuthService{
  final FirebaseAuth auth = FirebaseAuth.instance;

  UserModel userFromFirebase(User user){
    return user != null
        ? UserModel(userId: user.uid, email: user.email)
        : null;
  }

  Stream<UserModel> get user{
    return auth.authStateChanges().map(userFromFirebase);
  }

  //Anonymous Sign in
  Future signInAnon() async{
    try{
      UserCredential result = await auth.signInAnonymously();
      User user = result.user;
      return userFromFirebase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //Register with mail
  Future registerWithMail(String email, String password) async{
    try{
      UserCredential user = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return userFromFirebase(user.user);
    }catch(e){
      print('Register error ${e.toString()}');
      return null;
    }
  }

  //Login with email
  Future loginWithMail(String email, String password) async{
    try{
      UserCredential user = await auth.signInWithEmailAndPassword(email: email, password: password);
      return userFromFirebase(user.user);
    }catch(e){
      print('Log in error ${e.toString()}');
      return null;
    }
  }

  //Sign out
  Future logOut() async{
    try{
      return await auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}