import 'package:flutter/material.dart';

class NotificationDetailsPage extends StatefulWidget {
  final String notificationTitle;
  final String notificationContent;

  NotificationDetailsPage({Key key, @required this.notificationTitle, @required this.notificationContent}) : super(key: key);

  @override
  _NotificationDetailsPageState createState() => _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          elevation: 1.0,
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.notificationTitle,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.notificationContent,
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}