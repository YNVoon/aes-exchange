import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final _formKey = GlobalKey<FormState>();

  final FocusNode _nodeEmail = FocusNode();  
  final FocusNode _nodePassword = FocusNode(); 

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFFF),
        body: Container(
          padding: EdgeInsets.only(left: 25.0, right: 25.0),
          // color: Colors.black,
          child: Center(
            child: Container(
              // margin: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Logo
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text("T", style: TextStyle(fontSize: 80.0)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50.0),
                    child: Form(
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
                              hintText: "Enter Email",
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xFF0e47a1), width: 2.0),
                              ),
                              filled: true,
                              fillColor: Color(0xFFfafbfd),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          Container(
                            margin: EdgeInsets.all(7.0),
                          ),
                          TextFormField(
                            focusNode: _nodePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (term){
                              // _nodeEmail.unfocus();
                              // FocusScope.of(context).requestFocus(_nodePassword);
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: Colors.black,),
                              
                              hintText: "Input password",
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xFF0e47a1), width: 2.0),
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          Container(
                            height: 50.0,
                            margin: EdgeInsets.only(top: 80.0, bottom: 20.0),
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              color: Color(0xFF0e47a1),
                              onPressed: () {

                              },
                              child: Text(
                                "Login",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                print("Forgot password");
                              },
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0e47a1), fontSize: 16.0),
                              ),
                            )
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                print("Sign up");
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: "Don't have an account yet? "),
                                    TextSpan(text: 'Register', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0e47a1), fontSize: 16.0))
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
          )
        ),
      )
    );
  }
}