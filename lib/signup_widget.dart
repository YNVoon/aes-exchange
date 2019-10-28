import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'main.dart';

import 'dart:io';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;


class SignupPage extends StatefulWidget {
  SignupPage({Key key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController = new TextEditingController();

  String _email;
  String _password;
  String _confirmPassword;
  String _invitationCode;

  bool _obscureText = true;
  bool _obscureText1 = true;

  final FocusNode _nodeEmail = FocusNode();
  final FocusNode _nodePassword = FocusNode();
  final FocusNode _nodeRepeatPassword = FocusNode();
  final FocusNode _nodeInvitation = FocusNode();

  ProgressDialog pr1;

  bool validateEmail(String value) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) 
      return false;
    else
      return true;
  }

  bool validateConfirmPassword (String password, String confirmPw) {
    if (password == confirmPw) {
      return true;
    } else {
      return false;
    }
  }

  void _showMaterialDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            message,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        );
      }
    );
    _passwordController.clear();
    _confirmPasswordController.clear();
  }
  

  _setUserDatabase(String email, String uuid, String invitationCode) async {
    var queryParameters = {
      'email': email,
      'uuid': uuid,
      'referralCode': randomAlphaNumeric(10),
      'invitationCode': invitationCode
    };
    new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/createUser', queryParameters))
      .then((HttpClientRequest request) => request.close())
      .then((HttpClientResponse response) {
        print(response.toString());
      });
  }

  Future<void> signUp() async {
    pr1.show();
    try {
      FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: _email, password: _password)).user;
      _setUserDatabase(_email, user.uid, _invitationCode);
      pr1.dismiss();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
      
    } catch (e) {
      print(e.message);
      pr1.dismiss();
      _showMaterialDialog(e.message);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    pr1 = new ProgressDialog(context);
    pr1.style(message: 'Please wait...');

    return Container(
       child: Scaffold(
         backgroundColor: Color(0xFFFFFFFF),
         body: Container(
           child: CustomScrollView(
             slivers: <Widget>[
               SliverToBoxAdapter(
                 child: Container(
                   child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //Logo
                      Container(
                        margin: EdgeInsets.only(top: 50.0, left: 50.0, right: 50.0),
                        child: Image(image: AssetImage('assets/aes_transparent.png')),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                        child: Form(
                          autovalidate: _autoValidate,
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                focusNode: _nodeEmail,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (term){
                                  _nodeEmail.unfocus();
                                  FocusScope.of(context).requestFocus(_nodePassword);
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email, color: Colors.black,),
                                  
                                  hintText: "Insert Email Address",
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFF0e47a1), width: 2.0),
                                  ),
                                ),
                                validator: (value) {
                                  _email = value;
                                  if (value.isEmpty) {
                                    return 'Please insert email address';
                                  } else if (!validateEmail(value)) {
                                    return 'Please insert valid email';
                                  }
                                  return null;
                                },
                                onSaved: (String val){
                                  _email = val;
                                },
                                keyboardType: TextInputType.emailAddress,
                              ),
                              Container(
                                margin: EdgeInsets.all(12.0),
                              ),
                              TextFormField(
                                controller: _passwordController,
                                focusNode: _nodePassword,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (term){
                                  _nodePassword.unfocus();
                                  FocusScope.of(context).requestFocus(_nodeRepeatPassword);
                                },
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock, color: Colors.black,),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.remove_red_eye, color: Colors.grey,),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText; 
                                      });
                                    },
                                  ),
                                  hintText: "Input password",
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFF0e47a1), width: 2.0),
                                  ),
                                ),
                                validator: (value) {
                                  _password = value;
                                  if (value.isEmpty) {
                                    return 'Please insert password';
                                  } else if (value.length < 6) {
                                    return 'Insert at least 6 characters';
                                  }
                                  return null;
                                },
                                onSaved: (String val){
                                  _password = val;
                                },
                              ),
                              Container(
                                margin: EdgeInsets.all(12.0),
                              ),
                              TextFormField(
                                controller: _confirmPasswordController,
                                focusNode: _nodeRepeatPassword,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (term){
                                  _nodePassword.unfocus();
                                  FocusScope.of(context).requestFocus(_nodeInvitation);
                                },
                                obscureText: _obscureText1,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock, color: Colors.black,),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.remove_red_eye, color: Colors.grey,),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText1 = !_obscureText1; 
                                      });
                                    },
                                  ),
                                  hintText: "Confirm Password",
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFF0e47a1), width: 2.0),
                                  ),
                                ),
                                validator: (value) {
                                  _confirmPassword = value;
                                  if (value.isEmpty) {
                                    return 'Please confirm password';
                                  } else if (value != _password) {
                                    return 'Password doesn\'t match';
                                  }
                                  return null;
                                },
                                onSaved: (String val){
                                  _confirmPassword = val;
                                },
                              ),
                              Container(
                                margin: EdgeInsets.all(12.0),
                              ),
                              TextFormField(
                                focusNode: _nodeInvitation,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (term){
                                  _nodeInvitation.unfocus();
                                  // FocusScope.of(context).requestFocus(_nodeRepeatPassword);
                                  if (_formKey.currentState.validate()) {
                                    // If all data are correct then save data to out variables
                                    _formKey.currentState.save();
                                    signUp();
                                    
                                  } else {
                                    // If all data are not valid then start auto validation.
                                    setState(() {
                                      _autoValidate = true;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.local_offer, color: Colors.black,),
                                  
                                  hintText: "Input invitation code",
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFF0e47a1), width: 2.0),
                                  ),
                                ),
                                validator: (value) {
                                  _invitationCode = value;
                                  if (value.isEmpty) {
                                    return 'Please insert invitation code';
                                  } else if (value.length < 6) {
                                    return 'Invalid invitation code';
                                  }
                                  return null;
                                },
                              ),
                              Container(
                                height: 50.0,
                                margin: EdgeInsets.only(top: 50.0, bottom: 20.0),
                                width: MediaQuery.of(context).size.width,
                                child: RaisedButton(
                                  color: Color(0xFF0e47a1),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      // If all data are correct then save data to out variables
                                      _formKey.currentState.save();
                                      signUp();
                                      
                                    } else {
                                      // If all data are not valid then start auto validation.
                                      setState(() {
                                        _autoValidate = true;
                                      });
                                    }
                                    
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                   ),
                 ),
               )
             ],
           ),

         ),
       ),
    );
  }
}