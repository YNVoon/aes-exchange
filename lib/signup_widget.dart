import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'dart:io';
import 'dart:convert';
import 'package:random_string/random_string.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login_widget.dart';
import 'package:aes_exchange/utils/app_localizations.dart';



class SignUpStatus {
  var status;

  SignUpStatus({this.status});

  factory SignUpStatus.fromJson(Map<String, dynamic> json) {
    return SignUpStatus(
      status: json['status']
    );
  }
}


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
  String _invitationCode = '';

  bool _obscureText = true;
  bool _obscureText1 = true;

  final FocusNode _nodeEmail = FocusNode();
  final FocusNode _nodePassword = FocusNode();
  final FocusNode _nodeRepeatPassword = FocusNode();
  final FocusNode _nodeInvitation = FocusNode();

  ProgressDialog pr1;

  SignUpStatus mySignUpStatus = SignUpStatus(status: '');

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

  Future<void> signOut () async {
    try {
      FirebaseUser user = await _auth.currentUser();
      if (user != null) {
        await _auth.signOut();
        print('Successfully Signed out');
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context).translate('something_went_wrong'),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      } else {
        print('No active user');
      }
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> signUp() async {
    pr1.show();
    var queryParameters;
    
    print('Sign up with ' + _invitationCode);
    try {
      FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: _email, password: _password)).user;
      if (_invitationCode == null || _invitationCode == ''){
        queryParameters = {
          'email': _email,
          'uuid': user.uid,
          'referralCode': randomAlphaNumeric(10),
          'invitationCode': '700628776X'
        };
      } else {
        queryParameters = {
          'email': _email,
          'uuid': user.uid,
          'referralCode': randomAlphaNumeric(10),
          'invitationCode': _invitationCode
        };
      }
      
      new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/createUser', queryParameters))
        .then((HttpClientRequest request) => request.close())
        .then((HttpClientResponse response) {
          response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
            mySignUpStatus = SignUpStatus.fromJson(contents);
            if (mySignUpStatus.status == 'success') {
              pr1.dismiss();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
            } else {
              pr1.dismiss();
              signOut();
            }
          });
          print(response.toString());
        });
      
      
    } catch (e) {
      print(e.message);
      pr1.dismiss();
      _showMaterialDialog(e.message);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    pr1 = new ProgressDialog(context, isDismissible: false);
    pr1.style(message: AppLocalizations.of(context).translate('please_wait'));

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
                        child: Image(image: AssetImage('assets/aes_deposit_full.png'), width: 200.0,),
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
                                  
                                  hintText: AppLocalizations.of(context).translate('enter_email'),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFF0e47a1), width: 2.0),
                                  ),
                                ),
                                validator: (value) {
                                  _email = value;
                                  if (value.isEmpty) {
                                    return AppLocalizations.of(context).translate('please_insert_an_email_address');
                                  } else if (!validateEmail(value)) {
                                    return AppLocalizations.of(context).translate('please_insert_valid_email');
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
                                    icon: _obscureText ? Icon(Icons.visibility_off, color: Colors.grey,) : Icon(Icons.visibility, color: Colors.grey,),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText; 
                                      });
                                    },
                                  ),
                                  hintText: AppLocalizations.of(context).translate('input_password'),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFF0e47a1), width: 2.0),
                                  ),
                                ),
                                validator: (value) {
                                  _password = value;
                                  if (value.isEmpty) {
                                    return AppLocalizations.of(context).translate('please_insert_password');
                                  } else if (value.length < 6) {
                                    return AppLocalizations.of(context).translate('insert_at_least_six_characters');
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
                                    icon: _obscureText1 ? Icon(Icons.visibility_off, color: Colors.grey,) : Icon(Icons.visibility, color: Colors.grey,),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText1 = !_obscureText1; 
                                      });
                                    },
                                  ),
                                  hintText: AppLocalizations.of(context).translate('confirm_password'),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFF0e47a1), width: 2.0),
                                  ),
                                ),
                                validator: (value) {
                                  _confirmPassword = value;
                                  if (value.isEmpty) {
                                    return AppLocalizations.of(context).translate('please_confirm_password');
                                  } else if (value != _password) {
                                    return AppLocalizations.of(context).translate('password_not_match');
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
                                  
                                  hintText: AppLocalizations.of(context).translate('input_invitation_code'),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFF0e47a1), width: 2.0),
                                  ),
                                ),
                                validator: (value) {
                                  _invitationCode = value;
                                  if (value.isNotEmpty) {
                                    if (value.length < 6) {
                                      return AppLocalizations.of(context).translate('invalid_invitation_code');
                                    }
                                  } 
                                  // else if (value.length < 6) {
                                  
                                  // }
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
                                      if (_invitationCode == null || _invitationCode == ''){
                                        print(_invitationCode);
                                      }
                                      
                                    }
                                    
                                  },
                                  child: Text(
                                    AppLocalizations.of(context).translate('signup'),
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