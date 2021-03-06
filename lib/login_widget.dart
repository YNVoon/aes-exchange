import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'signup_widget.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aes_exchange/utils/app_localizations.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  final FocusNode _nodeEmail = FocusNode();  
  final FocusNode _nodePassword = FocusNode();

  final TextEditingController _passwordController = new TextEditingController();

  ProgressDialog pr;

  String _email;
  String _password;

  bool _obscureText = true;

  bool validateEmail(String value) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) 
      return false;
    else
      return true;
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
  }

  Future<void> getCurrentUser() async {
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        print(user.email);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
      } else {
        print('No active user');
      }
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> signIn (String email, String password) async {
    pr.show();
    try {
      AuthResult authResult =  await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("Success");
      print(authResult);
      pr.dismiss();
      if (!pr.isShowing()) {
        Future.delayed(Duration(milliseconds: 500)).then((onValue) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
        });
      }
      print('isDismiss');
      
      // Future.delayed(Duration(milliseconds: 2000)).then((onValue) {
      //   pr.dismiss();
        
      // }).then((onValue) {
        
      // })
      
      
      
      // Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } catch (e) {
      print("error");
      print(e.message);
      pr.dismiss();
      _showMaterialDialog(e.message);
      
    }
    
  }
  
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context, isDismissible: false);
    pr.style(message: AppLocalizations.of(context).translate('please_wait'));
    
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFFF),
        body: Container(
          padding: EdgeInsets.only(left: 25.0, right: 25.0),
          child: Center(
            child: Container(
              // margin: EdgeInsets.all(10.0),
              child: SingleChildScrollView (
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Logo
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: Image(image: AssetImage('assets/aes_deposit_full.png'), width: 200.0,),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50.0),
                      child: Form(
                        autovalidate: _autoValidate,
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              onFieldSubmitted: (term){
                                _nodeEmail.unfocus();
                                FocusScope.of(context).requestFocus(_nodePassword);
                              },
                              focusNode: _nodeEmail,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email, color: Colors.black,),
                                hintText: AppLocalizations.of(context).translate('enter_email'),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFF0e47a1), width: 2.0),
                                ),
                                filled: true,
                                fillColor: Color(0xFFfafbfd),
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
                              margin: EdgeInsets.all(7.0),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              focusNode: _nodePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (term){
                                _nodePassword.unfocus();
                                if (_formKey.currentState.validate()) {
                                  // If all data are correct then save data to out variables
                                  _formKey.currentState.save();
                                  // pr.show();
                                  signIn(_email, _password);
                                  
                                } else {
                                  // If all data are not valid then start auto validation.
                                  setState(() {
                                    _autoValidate = true;
                                  });
                                }
                              },
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: _obscureText ? Icon(Icons.visibility_off, color: Colors.grey,) : Icon(Icons.visibility, color: Colors.grey,),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText; 
                                    });
                                  },
                                ),
                                prefixIcon: Icon(Icons.lock, color: Colors.black,),
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
                              height: 50.0,
                              margin: EdgeInsets.only(top: 80.0, bottom: 20.0),
                              width: MediaQuery.of(context).size.width,
                              child: RaisedButton(
                                color: Color(0xFF0e47a1),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                      // If all data are correct then save data to out variables
                                      _formKey.currentState.save();
                                      // pr.show();
                                      signIn(_email, _password);
                                      
                                    } else {
                                      // If all data are not valid then start auto validation.
                                      setState(() {
                                        _autoValidate = true;
                                      });
                                    }
                                },
                                child: Text(
                                  AppLocalizations.of(context).translate('login'),
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)
                                ),
                              ),
                            ),
                            // Container(
                            //   margin: EdgeInsets.only(bottom: 20.0),
                            //   child: InkWell(
                            //     highlightColor: Colors.transparent,
                            //     splashColor: Colors.transparent,
                            //     onTap: () {
                            //       print("Forgot password");
                            //     },
                            //     child: Text(
                            //       "Forgot Password",
                            //       style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0e47a1), fontSize: 16.0),
                            //     ),
                            //   )
                            // ),
                            Container(
                              margin: EdgeInsets.only(bottom: 20.0),
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => SignupPage()),
                                  );
                                },
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.0,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(text: AppLocalizations.of(context).translate('dont_have_an_account_yet')),
                                      TextSpan(text: AppLocalizations.of(context).translate('register'), style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0e47a1), fontSize: 16.0))
                                    ],
                                  ),
                                ),
                              )
                            )
                          ],
                        )
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ),
      )
    );
  }
}