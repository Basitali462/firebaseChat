import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';
import 'package:flutter_chat_app/screens/chat_screens/chat_room.dart';
import 'package:flutter_chat_app/screens/login_signup/signup_screen.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/firestore_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginFormKey = GlobalKey<FormState>();

  AuthService authService = AuthService();

  TextEditingController emailText = TextEditingController();
  TextEditingController passText = TextEditingController();
  String error = '';

  onEditEmail(String val){
    //print('email val $val');
  }

  onEditPass(String val){
    //print('Password val $val');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Login",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                    SizedBox(height: 20,),
                    Text("Login to your account",
                      style: TextStyle(
                          fontSize: 15,
                          color:Colors.grey[700]),)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        inputFile(label: "Email",
                          controller: emailText,
                          onChange: onEditEmail,
                          validate: validateEmail,
                        ),
                        inputFile(label: "Password",
                          controller: passText,
                          obscureText: true,
                          onChange: onEditPass,
                          validate: validatePassword,
                        ),
                        SizedBox(height: 20,),
                        Text(
                          error,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(padding:
                EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
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
                        if(loginFormKey.currentState.validate()){
                          await authService.loginWithMail(emailText.text, passText.text)
                              .then((value){
                                if(value == null){
                                  setState(() {
                                    error = 'Invalid Username or Password';
                                  });
                                }else{
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChatRoom()),
                                  );
                                }
                          });
                        }
                      },
                      color: Color(0xff0095FF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),

                      ),
                      child: Text(
                        "Login", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account?"),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupPage()));
                      },
                      child: Text(" Sign up", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),),
                    )
                  ],
                ),
                /*Container(
                  padding: EdgeInsets.only(top: 100),
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/background.png"),
                        fit: BoxFit.fitHeight
                    ),
                  ),
                )*/
              ],
            ))
          ],
        ),
      ),
    );
  }
}


// we will be creating a widget for text field
Widget inputFile({label,
  TextEditingController controller,
  Function(String val) onChange,
  Function(String val) validate,
  obscureText = false,})
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
        obscureText: obscureText,
        controller: controller,
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