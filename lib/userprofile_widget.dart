import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'model/user_profile.dart';

import 'personal_info_widget.dart';
import 'login_widget.dart';

import 'package:firebase_auth/firebase_auth.dart';

class UserProfileWidget extends StatefulWidget {
  UserProfileWidget({Key key}) : super(key: key);

  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  final RefreshController _refreshController = RefreshController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<List<UserProfile>> _settingList = [
    [UserProfile("Invitation code", Icons.drafts, "invitation_code"), UserProfile("Address book", Icons.contacts, "address_book"),],
    [UserProfile("Security", Icons.security, "security"), UserProfile("Settings", Icons.settings_applications, "settings"),],
    [UserProfile("About us", Icons.help_outline, "about_us"),]
  ];

  Future<void> signOut () async {
    try {
      FirebaseUser user = await _auth.currentUser();
      if (user != null) {
        await _auth.signOut();
        print('Sign out successful');
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
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => PersonalInfoPage())
                );
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
                                child: Text("demo@email.com", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              // Currency current value
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text("ID: ABC12345", style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.start)
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
                            "VIP 0",
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
                _buildSettingRow(_settingList[0][1], 0),
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