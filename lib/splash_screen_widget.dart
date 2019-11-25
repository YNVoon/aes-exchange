import 'package:flutter/material.dart';
import 'package:aes_exchange/utils/app_localizations.dart';

import 'main.dart';
import 'login_widget.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'dart:io' show Platform;
import 'dart:io';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class AppUpdate {
  final String androidAppLink;
  final String iosAppLink;

  AppUpdate({this.androidAppLink, this.iosAppLink});

  factory AppUpdate.fromJson(Map<String, dynamic> json) {
    return AppUpdate(
      androidAppLink: json['androidAppLink'].toString(),
      iosAppLink: json['iosAppLink'].toString(),
    );
  }
}


class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  AppUpdate myAppUpdate = AppUpdate();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String currentAppVersion = '1.0.4';

  void _launchURL(String path) async {
    var url = path;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch URL';
    }
  }

  Future<void> _requestUpdateLink() async {
    try {
      new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/getUpdateLink'))
        .then((HttpClientRequest request) => request.close())
        .then((HttpClientResponse response) {
          response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
            myAppUpdate = AppUpdate.fromJson(contents);
            print('android: ' + myAppUpdate.androidAppLink);
            _checkAppVersion();
          });
        });
    } catch (e) {
      print(e);
    }
  }

  void _showMaterialDialogForUpdate() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
            content: Text(
              AppLocalizations.of(context).translate('app_is_outdated'),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(AppLocalizations.of(context).translate('update_now'), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                onPressed: () {
                  if (Platform.isAndroid) {
                    _launchURL(myAppUpdate.androidAppLink);
                  } else if (Platform.isIOS) {
                    _launchURL(myAppUpdate.iosAppLink);
                  }
                  
                },
              ),
            ],
          ),
        );
        
      }
    );
  }
  
  _checkAppVersion() async {
    var currentAndroidAppVersion = '1.0.4';
    var currentiOSAppVersion = '1.0.4';

    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    if (Platform.isIOS) {
      try {
        await remoteConfig.fetch(expiration: const Duration(seconds: 0));
        await remoteConfig.activateFetched();

        if (currentiOSAppVersion != remoteConfig.getString('ios_app_version')) {
          print('Please update your app!');
          print('update link ' + myAppUpdate.iosAppLink);
          _showMaterialDialogForUpdate();
        } else {
          getCurrentUser();
        }
      } catch (e) {
        print(e.toString());
      }
    } else if (Platform.isAndroid) {
      try {
        // final defaults = <String, dynamic>{'android_app_version': currentAndroidAppVersion};
        // await remoteConfig.setDefaults(defaults);
        await remoteConfig.fetch(expiration: const Duration(seconds: 0));
        await remoteConfig.activateFetched();
        print(remoteConfig.getString('android_app_version'));
        if (currentAndroidAppVersion != remoteConfig.getString('android_app_version')) {
          print('Please update your app!');
          print('update link ' + myAppUpdate.androidAppLink);
          _showMaterialDialogForUpdate();
        } else {
          getCurrentUser();
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> getCurrentUser() async {
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        print(user.email);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
      } else {
        print('No active user');
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      }
    } catch (e) {
      print(e.message);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      _requestUpdateLink();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 200.0,
                        child: Image(
                          image: AssetImage('assets/aes_deposit_full.png'),
                          width: 200.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0E47A1)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      'v' + currentAppVersion,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate('blockchain_based'),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
