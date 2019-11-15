import 'package:aes_exchange/model/currency.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'model/transaction_record.dart';

import 'dart:io';
import 'dart:convert';

class TransactionRecordList {
  final List<dynamic> transaction;

  TransactionRecordList({this.transaction,});

  factory TransactionRecordList.fromJson(Map<String, dynamic> json) {
    return TransactionRecordList(
      transaction: json['transaction']
    );
  }
}

class WithdrawalRecordPage extends StatefulWidget {
  final Currency currency;

  WithdrawalRecordPage({Key key, @required this.currency}) : super(key: key);

  @override
  _WithdrawalRecordPageState createState() => _WithdrawalRecordPageState();
}

class _WithdrawalRecordPageState extends State<WithdrawalRecordPage> {

  List<TransactionRecord> _transactionRecordList = List<TransactionRecord>();

  TransactionRecordList myTransactionList = TransactionRecordList(transaction: []);

  ProgressDialog pr1, pr2;

  var queryParameters = <String, String>{};

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RefreshController _refreshController = RefreshController();

  Future<void> _getTransactionList(ProgressDialog pd) async {
    pd.show();
    try{
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        if (widget.currency.currencyName == 'BTC') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'btc'
          };
        } else if (widget.currency.currencyName == 'ETH') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'eth'
          };
        } else if (widget.currency.currencyName == 'USDT') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'usdt'
          };
        } else if (widget.currency.currencyName == 'AES') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'aes'
          };
        }
        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/getAllWithdrawalList', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              setState(() {
                myTransactionList = TransactionRecordList.fromJson(contents);
                _transactionRecordList.length = 0;
                if (myTransactionList.transaction.length > 0) {
                  for (var item in myTransactionList.transaction) {
                    var status, date, day, month, year, time, hour, minute, second, transactionAmount, isTransferIn, transactionId, typeOfTransaction;
                    for (String key in item.keys) {
                      if (key == 'amount') {
                        transactionAmount = item[key];
                        if (widget.currency.currencyName == 'BTC') {
                          transactionAmount = (item[key] / 1e8);
                        } else if (widget.currency.currencyName == 'ETH') {
                          transactionAmount = (item[key] / 1e18);
                        } else if (widget.currency.currencyName == 'USDT') {
                          transactionAmount = (item[key] / 1e6);
                        } else if (widget.currency.currencyName == 'AES') {
                          transactionAmount = (item[key] / 1e8);
                        }
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
                      } else if (key == 'type') {
                        if (item[key] == 'withdrawal out') {
                          isTransferIn = false;
                          typeOfTransaction = 'Withdrawal Out';
                        } 
                      } else if (key == 'status') {
                        status = item[key];
                      } else if (key == 'transactionId') {
                        transactionId = item[key];
                      }
                    }
                    DateTime utcTime = DateTime.utc(year, month, day, hour, minute, second);
                    String localTime = utcTime.toLocal().toString();
                    var dateString = localTime.split(' ');
                    var timeString = dateString[1].split('.000');
                    date = year.toString() + '-' + month.toString() + '-' + day.toString();
                    time = hour.toString() + ':' + minute.toString() + ':' + second.toString();
                    _transactionRecordList.add(TransactionRecord(dateString[0], timeString[0], typeOfTransaction, transactionAmount, isTransferIn, status, day.toString(), year.toString(), month.toString(), transactionId));
                  }
                } 
              });
              pd.dismiss();
            });
          });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      pr2 = new ProgressDialog(context, isDismissible: false);
      pr2.style(message: 'Retrieving latest data...');
      _getTransactionList(pr2);
    });
  }

  Widget _buildTransactionRow (TransactionRecord trustTransaction) {
    return Container(
      color: Colors.white,
      // padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Column(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // if (trustTransaction.isTransferIn) {
                //   Navigator.push(
                //     context, 
                //     MaterialPageRoute(builder: (context) => TrustWithdrawPage(date: trustTransaction.date, currency: trustTransaction.currencyType, transactionAmount: trustTransaction.transactionAmount, day: trustTransaction.day, year: trustTransaction.year, month: trustTransaction.month, transactionId: trustTransaction.transactionId,)),
                //   );
                // }
              },
              child: Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ClipOval(
                          child: Container(
                            color: trustTransaction.isTransferIn ? Color(0xFF34b187) : Color(0xFFff0152),
                            width: 30.0,
                            height: 30.0,
                            child: Center(
                              child: IconTheme(
                                data: IconThemeData(
                                  color: Colors.white
                                ),
                                child: Icon(
                                  trustTransaction.isTransferIn ? Icons.arrow_downward : Icons.arrow_upward
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 160.0,
                          margin: EdgeInsets.only(left: 20.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(trustTransaction.typeOfTransaction, textAlign: TextAlign.start,),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(trustTransaction.date + ' ' + trustTransaction.time, textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    Container(
                      child: Text(
                        // highlight
                        trustTransaction.transactionAmount.toStringAsFixed(8) + ' ' + widget.currency.currencyName,
                        style: TextStyle(fontWeight: FontWeight.bold, color: trustTransaction.isTransferIn ? Color(0xFF34b187) : Color(0xFFff0152)),
                      ),
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
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    pr1 = new ProgressDialog(context, isDismissible: false);
    pr1.style(message: 'Retrieving latest data...');

    List<Widget> sliverDelegateList = List<Widget> ();

    for (int i = 0; i < _transactionRecordList.length; i++) {
      sliverDelegateList.add(_buildTransactionRow(_transactionRecordList[i]));
    }

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          elevation: 1.0,
          title: Text(
            'Withdrawal Records',
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
          _getTransactionList(pr1);
          
        },
        child: CustomScrollView(
          slivers: <Widget>[
            _transactionRecordList.length <= 0 ? SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                height: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'No data available',
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
      ),
    );
  }
}