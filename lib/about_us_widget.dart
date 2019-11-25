import 'package:flutter/material.dart';
import 'package:aes_exchange/utils/app_localizations.dart';

class AboutUsPage extends StatefulWidget {
  AboutUsPage({Key key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          elevation: 1.0,
          title: Text(
            AppLocalizations.of(context).translate('about_us'),
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 10.0),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
                width: MediaQuery.of(context).size.width,
                child: Image(
                  image: AssetImage('assets/aes_transparent.png'),
                  width: 150.0,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 40.0, left: 30.0, right: 30.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('about_us_para'),
                  style: TextStyle(fontSize: 15.0),
                  textAlign: TextAlign.justify,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
