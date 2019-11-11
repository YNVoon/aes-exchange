import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'model/user_profile.dart';

import 'personal_info_widget.dart';
import 'login_widget.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'invitation_code_widget.dart';

import 'dart:io';
import 'dart:convert';
import 'model/user_information.dart';
import 'security_widget.dart';



class UserProfileWidget extends StatefulWidget {
  UserProfileWidget({Key key}) : super(key: key);

  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  final RefreshController _refreshController = RefreshController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProgressDialog pr1, pr2;

  UserInformation myUserInformation = UserInformation(userEmail: '', userId: '', userInvitationCode: '', userVIPStatus: 0);

  List<List<UserProfile>> _settingList = [
    // [UserProfile("Invitation code", Icons.drafts, "invitation_code"), UserProfile("Address book", Icons.contacts, "address_book"),],
    [UserProfile("Invitation code", Icons.drafts, "invitation_code"), ],
    [UserProfile("Security", Icons.security, "security"), UserProfile("English", Icons.settings_applications, "settings"),],
    [UserProfile("About us", Icons.help_outline, "about_us"),]
  ];

  void _showMaterialDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            'Coming Soon',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        );
      }
    );
  }

  Future<void> _getUserInformation (ProgressDialog pd) async {
    pd.show();
    try {
      FirebaseUser user = await _auth.currentUser();
      if (user != null) {
        var queryParameters = {
          'uuid': user.uid
        };

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/getUserInformation', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              print(contents.toString());
              setState(() {
                myUserInformation = UserInformation.fromJson(contents); 
              });
              pd.dismiss();
            });
          });
      } else {
        print('No active user');
        pd.dismiss();
      }
    } catch (e) {
      print(e.message);
      pd.dismiss();
    }
  }

  Future<void> signOut () async {
    try {
      FirebaseUser user = await _auth.currentUser();
      if (user != null) {
        await _auth.signOut();
        print('Sign out successful');
        Fluttertoast.showToast(
            msg: "Successfully Sign Out",
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      } else {
        print('No active user');
      }
    } catch (e) {
      print(e.message);
    }
  }

  

  Widget _buildSettingRow(UserProfile userProfile, int index) {
    return GestureDetector(
      onTap: () {
        print("tabbed");
        if (userProfile.title == 'Invitation code') {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => InvitationCodePage(userInformation: myUserInformation,)),
          );
        } else if (userProfile.title == 'About us' || userProfile.title == 'Security') {
          _showMaterialDialog();
        } 
        // else if (userProfile.title == 'Security') {
        //   Navigator.push(
        //     context, 
        //     MaterialPageRoute(builder: (context) => SecurityPage()),
        //   );
        // }
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 52.0,
            child: Row(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(userProfile.icon, size: 30.0,),
                    Container(
                      width: 200.0,
                      margin: EdgeInsets.only(left: 20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(userProfile.title, textAlign: TextAlign.start),
                      ),
                    )
                  ],
                ),
                Spacer(),
                Icon(Icons.chevron_right)
              ],
            ),
          ),
          _settingList[index].indexOf(userProfile) != _settingList[index].length - 1 ? Divider(
            color: Colors.grey,
            thickness: 0.3,
            height: 0.0,
          ) : Container(padding: EdgeInsets.all(4.0), color: Color(0xFFEEEEEE),)
        ],
      )
    );
  }

  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration.zero, () {
      pr2 = new ProgressDialog(context, isDismissible: false);
      pr2.style(message: 'Getting User Information..');
      _getUserInformation(pr2);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      header: MaterialClassicHeader(color: Colors.blue, backgroundColor: Colors.white,),
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        _refreshController.refreshCompleted();
      },
      child: CustomScrollView(
        slivers: <Widget>[
          // Avatar header
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context, 
                //   MaterialPageRoute(builder: (context) => PersonalInfoPage())
                // );
              },
              child: Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: 105.0,
                child: Row(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 30.0,
                        ),
                        Container(
                          width: 200.0,
                          margin: EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(myUserInformation.userEmail, textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              // Currency current value
                              Container(
                                margin: EdgeInsets.only(top: 5.0),
                                width: MediaQuery.of(context).size.width,
                                child: Text("User ID: " + myUserInformation.userId, style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.start)
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(4.0),
                          margin: EdgeInsets.only(right: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(const Radius.circular(10.0)),
                            color: Colors.blue,
                          ),
                          child: Text(
                            "VIP " + myUserInformation.userVIPStatus.toString(),
                            style: TextStyle(color: Colors.white, letterSpacing: 2.0, fontSize: 11.0)
                          ),
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    )
                  ],
                ),
              ),
            )
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Color(0xFFEEEEEE),
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 12.0, bottom: 12.0),
              child: Text(
                "Please do not disclose the transaction password, SMS and verification code to anyone, including AES exchange staff",
                style: TextStyle(fontSize: 9.0, color: Colors.grey)
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildSettingRow(_settingList[0][0], 0),
                // _buildSettingRow(_settingList[0][1], 0),
              ]
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildSettingRow(_settingList[1][0], 1),
                _buildSettingRow(_settingList[1][1], 1),
              ]
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildSettingRow(_settingList[2][0], 2),
              ]
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 38.0,
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () {
                  signOut();
                },
                child: Text(
                  "Sign Out",
                  style: TextStyle(fontSize: 16.0)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}