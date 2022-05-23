import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key ? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {


  //-----------------------------------------//

  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;

  //-------------------------------------------//

  startauthentication() async {


    final validty = _formkey.currentState!.validate();
    if(validty) {
      _formkey.currentState!.save();
      submitform(_email,_password,_username);
    }
  }

  submitform(String email, String password, String username) async{
    final auth ;
    try{
        if(isLoginPage){
          auth = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        }else{
          auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
          String uid = auth.user.id;
          await Firestore.instance.collection('users').document(uid).setData({
            'username':username,
            'email':email,
          });
        }
    }catch(err){
      print(err);
    }
  }
  //-----------------------------------------//

    @override
  Widget build(BuildContext context) {
    return Container(

      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,

      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
            child: Form(
              key: _formkey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(!isLoginPage)
                    TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      key: ValueKey('username'),
                      validator: (value){
                        if(value!.isNotEmpty){
                          return "Incorrect Username";
                        }
                        return null;
                      },

                      onSaved: (value){
                        _username = value.toString ();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: new BorderSide(),
                        ),
                        labelText: "ENTER USERNAME",
                        //labelStyle: GoogleFonts.aBeeZee(),
                      ),
                    ),

                    Padding(padding: const EdgeInsets.only(top: 10.0,)),

                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('email'),
                      validator: (value){
                        if(value!.isNotEmpty || !value.contains('@')){
                              return "Incorrect Email";
                        }
                        return null;
                      },

                      onSaved: (value){
                        _email = value.toString ();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: new BorderSide(),
                        ),
                        labelText: "ENTER EMAIL",
                       //labelStyle: GoogleFonts.aBeeZee(),
                      ),
                    ),

                    Padding(padding: const EdgeInsets.only(top: 10.0,)),

                    TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      key: ValueKey('password'),
                      validator: (value){
                        if(value!.isNotEmpty){
                          return "Incorrect Password";
                        }
                        return null;
                      },

                      onSaved: (value){
                        _password = value.toString ();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: new BorderSide(),
                        ),
                        labelText: "ENTER PASSWORD",
                        //labelStyle: GoogleFonts.aBeeZee(),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 10.0,)),
                    
                    Container(
                    padding: EdgeInsets.all(5.0),
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(4.0),
                    ),
                    child: ElevatedButton(onPressed: (){
                      startauthentication();
                    },
                        child: isLoginPage ? Text("Login") : Text("Signup"),

                    ),
                    ),

                    Padding(padding: const EdgeInsets.only(top: 10.0,)),

                    Container(child: TextButton(onPressed: (){
                      setState(() {
                        isLoginPage = !isLoginPage;
                      });
                    }, child: isLoginPage?Text("Not A Member! Signup"):Text("Already user ? Login")))
                  ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
