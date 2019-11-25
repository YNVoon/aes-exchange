import 'dart:io';
import 'dart:convert';

import 'package:aes_exchange/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'notification_details_widget.dart';
import 'package:aes_exchange/utils/app_localizations.dart';

class NotificationRecord {
  String date;
  String time;
  String notificationTitle;
  String notificationContent;

  NotificationRecord(this.date, this.time, this.notificationTitle, this.notificationContent);
}

class NotificationRecordList {
  final List<dynamic> notification;

  NotificationRecordList({this.notification});

  factory NotificationRecordList.fromJson(Map<String, dynamic> json) {
    return NotificationRecordList(
      notification: json['notification']
    );
  }
}

class NotificationPage extends StatefulWidget {
  NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  List<NotificationRecord> _notificationRecordList = List<NotificationRecord>();

  NotificationRecordList myNotificationRecordList = NotificationRecordList(notification: []);

  ProgressDialog pr1, pr2;

  var _inversedNotificationRecordList = [];

  final RefreshController _refreshController = RefreshController();

  Future<void> _getNotificationList(ProgressDialog pd) async {
    pd.show();
    try {
      var queryParameters = {
        'language': AppLocalizations.of(context).translate('language'),
      };
      new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/getNotice', queryParameters))
        .then((HttpClientRequest request) => request.close())
        .then((HttpClientResponse response) {
          response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
            setState(() {
              myNotificationRecordList = NotificationRecordList.fromJson(contents);
              _notificationRecordList.length = 0;
              _inversedNotificationRecordList.length = 0;
              if (myNotificationRecordList.notification.length > 0) {
                for (var item in myNotificationRecordList.notification) {
                  var day, month, year, minute, hour, second, title, description;
                  for (String key in item.keys) {
                    if (key == 'title') {
                      title = item[key];
                    } else if (key == 'description') {
                      description = item[key];
                    } else if (key == 'day') {
                      day = item[key];
                    } else if (key == 'month') {
                      month = item[key];
                    } else if (key == 'year') {
                      year = item[key];
                    } else if (key == 'hour') {
                      hour = item[key];
                    } else if (key == 'minute') {
                      minute = item[key];
                    } else if (key == 'second') {
                      second = item[key];
                    }
                  }
                  DateTime utcTime = DateTime.utc(year, month, day, hour, minute, second);
                  String localTime = utcTime.toLocal().toString();
                  var dateString = localTime.split(' ');
                  var timeString = dateString[1].split('.000');
                  _notificationRecordList.add(NotificationRecord(dateString[0], timeString[0], title, description));
                }
                _inversedNotificationRecordList = _notificationRecordList.reversed.toList();
              } 
            });
            pd.dismiss();
          });
        });
    } catch (error) {
      print('error');
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      pr2 = new ProgressDialog(context, isDismissible: false);
      pr2.style(message: AppLocalizations.of(context).translate('getting_notification'));
      _getNotificationList(pr2);
    });
  }

  Widget _buildNotificationRow (NotificationRecord notifications) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => NotificationDetailsPage(notificationTitle: notifications.notificationTitle, notificationContent: notifications.notificationContent,))
                );
              },
              child: Container(
                padding: EdgeInsets.only(left: 5.0, right: 10.0, top: 10.0, bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 6.0),
                      width: MediaQuery.of(context).size.width,
                      child: Text(notifications.notificationTitle, textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(Utility.truncateString(notifications.notificationContent, 60, '...'), textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, color: Colors.grey),),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(notifications.date + ' ' + notifications.time, textAlign: TextAlign.end, style: TextStyle(fontSize: 12.0, color: Colors.grey, fontWeight: FontWeight.w300),),
                    )
                  ],
                ),
                
              ),
            ),
            
          ),
          Divider(
            thickness: 0.3,
            height: 0.0,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    pr1 = new ProgressDialog(context, isDismissible: false);
    pr1.style(message: AppLocalizations.of(context).translate('getting_notification'));

    List<Widget> sliverDelegateList = List<Widget> ();

    // _notificationRecordList.add(NotificationRecord('21/11/2019', '20.00', 'Title 1', 'description1'));

    for (int i = 0; i < _inversedNotificationRecordList.length; i++) {
      sliverDelegateList.add(_buildNotificationRow(_inversedNotificationRecordList[i]));
    }

    return Container(
       child: Scaffold(
         backgroundColor: Color(0xFFFAFAFA),
         appBar: PreferredSize(
           preferredSize: Size.fromHeight(50.0),
           child: AppBar(
             centerTitle: true,
             elevation: 1.0,
             title: Text(
               AppLocalizations.of(context).translate('notice'),
               style: Theme.of(context).textTheme.title,
             ),
           ),
         ),
         body: SmartRefresher(
           controller: _refreshController,
           enablePullDown: true,
           header: MaterialClassicHeader(color: Colors.blue, backgroundColor: Colors.white,),
           onRefresh: () async {
            _refreshController.refreshCompleted();
            _getNotificationList(pr1);
          },
          child: CustomScrollView(
            slivers: <Widget>[
              _inversedNotificationRecordList.length <= 0 ? SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  height: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('no_notification'),
                        style: TextStyle(fontSize: 14.0, color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ) : SliverList(
                delegate: SliverChildListDelegate(
                  sliverDelegateList
                ),
              ),
            ],
          ),
         )
       ),
    );
  }
}