import 'package:flutter/material.dart';
import 'package:aes_exchange/utils/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:io';
import 'dart:convert';

class ResetStatus {
  final String status;

  ResetStatus({this.status});

  factory ResetStatus.fromJson(Map<String, dynamic> json) {
    return ResetStatus(
      status: json['status']
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  final FocusNode _nodeCurrentPassword = FocusNode();
  final FocusNode _nodeUpdatePassword = FocusNode();
  final FocusNode _nodeConfirmUpdatePassword = FocusNode();

  final TextEditingController _currentPasswordController =
      new TextEditingController();
  final TextEditingController _updatePasswordController =
      new TextEditingController();
  final TextEditingController _confirmUpdatePasswordController =
      new TextEditingController();

  ProgressDialog pr1, pr2;

  ResetStatus myResetStatus = ResetStatus(status: '');

  String _currentPassword;
  String _updatePassword;
  String _confirmUpdatePassword;
  String _userEmail;

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;

  Future<void> getCurrentUser() async {
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        print(user.email);
        _userEmail = user.email;
      } else {
        print('No active user');
      }
    } catch (e) {
      print(e.message);
    }
  }

  void _showMaterialDialogForError(String message, String condition) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
            content: Text(
              message,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(AppLocalizations.of(context).translate('ok'), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                onPressed: () {
                  if (condition == 'navigate') {
                    _confirmUpdatePasswordController.clear();
                    _updatePasswordController.clear();
                    _currentPasswordController.clear();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else if (condition == 'dismissDialog') {
                    _confirmUpdatePasswordController.clear();
                    _updatePasswordController.clear();
                    _currentPasswordController.clear();
                    Navigator.pop(context);
                  }
                  
                },
              ),
            ],
          ),
        );
        
      }
    );
  }

  Future<void> _resetPassword (ProgressDialog pd, String currentPassword, String updatePassword) async {
    pd.show();
    try {
      FirebaseUser user = await _auth.currentUser();
      if (user != null) {
        final AuthCredential credential = EmailAuthProvider.getCredential(
          email: user.email,
          password: currentPassword,
        );
        print(user.email);
        try {
          final firebaseUser = await user.reauthenticateWithCredential(credential);
          print(firebaseUser.toString());
          user.updatePassword(updatePassword).then((result) {
            pd.dismiss();
            _showMaterialDialogForError(AppLocalizations.of(context).translate('successful_update_new_password'), 'navigate');
          });
        } on PlatformException catch (e) {
          print(e.message);
          pd.dismiss();
          _showMaterialDialogForError(AppLocalizations.of(context).translate('something_went_wrong_please_try_again'), 'dismissDialog');
          
        }
        
      } else {
        print('No active user');
        pd.dismiss();
      }
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    pr1 = new ProgressDialog(context, isDismissible: false);
    pr1.style(message: AppLocalizations.of(context).translate('please_wait'));

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          elevation: 1.0,
          title: Text(
            AppLocalizations.of(context).translate('reset_password'),
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
          child: Form(
            autovalidate: _autoValidate,
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  onFieldSubmitted: (term) {
                    _nodeCurrentPassword.unfocus();
                    FocusScope.of(context).requestFocus(_nodeUpdatePassword);
                  },
                  focusNode: _nodeCurrentPassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate('current_password'),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF0e47a1), width: 2.0),
                      ),
                      filled: true,
                      fillColor: Color(0xFFFAFBFD),
                      suffixIcon: IconButton(
                        icon: _obscureText1
                            ? Icon(Icons.visibility_off, color: Colors.grey)
                            : Icon(Icons.visibility, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _obscureText1 = !_obscureText1;
                          });
                        },
                      )),
                  obscureText: _obscureText1,
                  validator: (value) {
                    _currentPassword = value;
                    if (value.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate('this_field_cannot_be_blank');
                    } else if (value.length < 6) {
                      return AppLocalizations.of(context)
                          .translate('insert_at_least_six_characters');
                    }
                    return null;
                  },
                  onSaved: (String val) {
                    _currentPassword = val;
                  },
                  controller: _currentPasswordController,
                ),
                Container(
                  margin: EdgeInsets.all(7.0),
                ),
                TextFormField(
                  onFieldSubmitted: (term) {
                    _nodeUpdatePassword.unfocus();
                    FocusScope.of(context)
                        .requestFocus(_nodeConfirmUpdatePassword);
                  },
                  focusNode: _nodeUpdatePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate('new_password'),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF0e47a1), width: 2.0),
                      ),
                      filled: true,
                      fillColor: Color(0xFFFAFBFD),
                      suffixIcon: IconButton(
                        icon: _obscureText2
                            ? Icon(Icons.visibility_off, color: Colors.grey)
                            : Icon(Icons.visibility, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                        },
                      )),
                  obscureText: _obscureText2,
                  validator: (value) {
                    _updatePassword = value;
                    if (value.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate('this_field_cannot_be_blank');
                    } else if (value.length < 6) {
                      return AppLocalizations.of(context)
                          .translate('insert_at_least_six_characters');
                    }
                    return null;
                  },
                  onSaved: (String val) {
                    _updatePassword = val;
                  },
                  controller: _updatePasswordController,
                ),
                Container(
                  margin: EdgeInsets.all(7.0),
                ),
                TextFormField(
                  onFieldSubmitted: (term) {
                    _nodeUpdatePassword.unfocus();
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      // TODO: Add changePassword()
                      pr2 = new ProgressDialog(context, isDismissible: false);
                      pr2.style(message: AppLocalizations.of(context).translate('please_wait'));
                      _resetPassword(pr2, _currentPassword, _updatePassword);
                    } else {
                      setState(() {
                        _autoValidate = true;
                      });
                    }
                  },
                  focusNode: _nodeConfirmUpdatePassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate('confirm_new_password'),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF0e47a1), width: 2.0),
                      ),
                      filled: true,
                      fillColor: Color(0xFFFAFBFD),
                      suffixIcon: IconButton(
                        icon: _obscureText3
                            ? Icon(Icons.visibility_off, color: Colors.grey)
                            : Icon(Icons.visibility, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _obscureText3 = !_obscureText3;
                          });
                        },
                      )),
                  obscureText: _obscureText3,
                  validator: (value) {
                    _confirmUpdatePassword = value;
                    if (value.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate('this_field_cannot_be_blank');
                    } else if (value.length < 6) {
                      return AppLocalizations.of(context)
                          .translate('insert_at_least_six_characters');
                    } else if (value != _updatePassword) {
                      return AppLocalizations.of(context)
                          .translate('password_not_match');
                    }
                    return null;
                  },
                  onSaved: (String val) {
                    _confirmUpdatePassword = val;
                  },
                  controller: _confirmUpdatePasswordController,
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
                        // TODO
                        pr2 = new ProgressDialog(context, isDismissible: false);
                        pr2.style(message: AppLocalizations.of(context).translate('please_wait'));
                        _resetPassword(pr2, _currentPassword, _updatePassword);
                      } else {
                        // If all data are not valid then start auto validation.
                        setState(() {
                          _autoValidate = true;
                        });
                      }
                    },
                    child: Text(AppLocalizations.of(context).translate('change_password'),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
