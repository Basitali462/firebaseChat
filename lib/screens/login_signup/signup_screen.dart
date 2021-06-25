import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';
import 'package:flutter_chat_app/screens/login_signup/login_screen.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/firestore_service.dart';

class SignupPage extends StatelessWidget {
  final signUpForm = GlobalKey<FormState>();

  final FirestoreDbService dbService = FirestoreDbService();
  AuthService authService = AuthService();

  TextEditingController userNameText = TextEditingController();
  TextEditingController emailText = TextEditingController();
  TextEditingController passText = TextEditingController();
  TextEditingController conformPassText = TextEditingController();

  //Text methods
  onEditUsername(String val){
    //print('User Name val $val');
  }

  onEditEmail(String val){
    //print('email val $val');
  }

  onEditPass(String val){
    //print('Password val $val');
  }

  onEditConformPass(String val){
    //print('Conform Password val $val');
  }

  //validator methods
  validateUserName(String val){
    if(val.isEmpty || val == null){
      return 'Please Enter User Name';
    }else{
      return null;
    }
  }

  validateEmail(String val){
    if(val.isNotEmpty){
      return EmailValidator.validate(val) ? null : 'Please Enter valid Email';
    }else{
      return 'Please Enter valid Email';
    }
  }

  validatePassword(String val){
    if(val.isEmpty || val.length < 6){
      return 'Password Must be 6 characters Long';
    }else{
      return null;
    }
  }

  validateConformPassword(String val){
    if(val.isEmpty || val.length < 6){
      return 'Password Must be 6 characters Long';
    }else if(val != passText.text){
      return 'Password Must be Same';
    }else{
      return null;
    }
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = [];
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Sign up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),),
                  SizedBox(height: 20,),
                  Text("Create an account, It's free ",
                    style: TextStyle(
                        fontSize: 15,
                        color:Colors.grey[700]),)
                ],
              ),
              Form(
                key: signUpForm,
                child: Column(
                  children: <Widget>[
                    inputFile(label: "Username",
                      controller: userNameText,
                      onChange: onEditUsername,
                      validate: validateUserName,
                    ),
                    inputFile(
                      label: "Email",
                      controller: emailText,
                      onChange: onEditEmail,
                      validate: validateEmail,
                    ),
                    inputFile(
                      label: "Password",
                      obscureText: true,
                      controller: passText,
                      onChange: onEditPass,
                      validate: validatePassword,
                    ),
                    inputFile(
                      label: "Confirm Password ",
                      obscureText: true,
                      controller: conformPassText,
                      onChange: onEditConformPass,
                      validate: validateConformPassword,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration:
                BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    ),
                ),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () async{
                    if(signUpForm.currentState.validate()){
                      print('sign up');
                      print(emailText.text);
                      print(passText.text);
                      await authService.registerWithMail(
                        emailText.text,
                        passText.text,)
                          .then((value) {
                            if(value != null){
                              Map<String, dynamic> data = ChatUser(
                                email: emailText.text,
                                username: userNameText.text,
                                searchQuery: setSearchParam(userNameText.text),
                              ).toJson();
                              dbService.addDoc(emailText.text, data);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            }
                      });
                    }else{
                      print('Error validating form');
                    }
                  },
                  color: Color(0xff0095FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Sign up", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have an account?"),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                    },
                    child: Text(" Login", style:TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// we will be creating a widget for text field
Widget inputFile({
  label,
  obscureText = false,
  Function(String val) onChange,
  Function(String val) validate,
  TextEditingController controller,})
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color:Colors.black87
        ),

      ),
      SizedBox(
        height: 5,
      ),
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0,
                horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey[400]
              ),

            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])
            )
        ),
        onChanged: onChange,
        validator: (val){
          return validate(val);
        },
      ),
      SizedBox(height: 10,)
    ],
  );
}