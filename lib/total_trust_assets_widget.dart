import 'package:aes_exchange/model/trust_currency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'model/trust_transaction_list.dart';

import 'transfer_trust_widget.dart';
import 'trust_withdraw_widget.dart';

import 'dart:io';
import 'dart:convert';

class TransactionList {
  final String trustToUsdt;
  final String trustBalance;
  final List<dynamic> transaction;
  String trustBalanceInString = "0.00000000";

  TransactionList({this.trustToUsdt, this.trustBalance, this.transaction, this.trustBalanceInString });

  factory TransactionList.fromJson(Map<String, dynamic> json) {
    return TransactionList(
      trustToUsdt: json['trustToUsdt'],
      trustBalance: json['trustBalance'],
      transaction: json['transaction']
    );
  }
}

class TotalTrustAssetPage extends StatefulWidget {
  final TrustCurrency currency;

  TotalTrustAssetPage({Key key, @required this.currency}) : super(key: key);

  @override
  _TotalTrustAssetPageState createState() => _TotalTrustAssetPageState();
}

class _TotalTrustAssetPageState extends State<TotalTrustAssetPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RefreshController _refreshController = RefreshController();

  List<TrustTransaction> _trustTransactionList = List<TrustTransaction>();
  
  ProgressDialog pr1, pr2;

  var queryParameters = <String, String>{};

  

  TransactionList myTransactionList = TransactionList(trustToUsdt: "0.000000", trustBalance: "0.00000000", transaction: [], trustBalanceInString: '0.00000000');
  
  Future<void> _getTransactionListAndLatestTrustBalance2(ProgressDialog pd) async {
    pd.show();
    try {
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
        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/updateTrustTransactionList', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              setState(() {
                myTransactionList = TransactionList.fromJson(contents);
                _trustTransactionList.length = 0;
                if (myTransactionList.transaction.length > 0) {
                  for (var item in myTransactionList.transaction) {
                    var status, date, day, month, year, time, hour, minute, second, transactionAmount, isTransferIn, transactionId;
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
                        if (item[key] == 'trust in') {
                          isTransferIn = true;
                        } else {
                          isTransferIn = false;
                        }
                      } else if (key == 'status') {
                        status = item[key];
                      } else if (key == 'transactionId') {
                        transactionId = item[key];
                      }
                    }
                    date = year.toString() + '-' + month.toString() + '-' + day.toString();
                    time = hour.toString() + ':' + minute.toString() + ':' + second.toString();
                    if (status == 'approved' || status == 'claimed') {
                      _trustTransactionList.add(TrustTransaction(date, time, widget.currency.currencyName, transactionAmount, isTransferIn, status, day.toString(), year.toString(), month.toString(), transactionId));
                    }
                  }
                }

                if (widget.currency.currencyName == 'BTC') {
                  myTransactionList.trustBalanceInString = (double.parse(myTransactionList.trustBalance) / 1e8).toStringAsFixed(8);
                } else if (widget.currency.currencyName == 'ETH') {
                  myTransactionList.trustBalanceInString = (double.parse(myTransactionList.trustBalance) / 1e18).toStringAsFixed(10);
                } else if (widget.currency.currencyName == 'USDT') {
                  myTransactionList.trustBalanceInString = (double.parse(myTransactionList.trustBalance) / 1e6).toStringAsFixed(6);
                } else if (widget.currency.currencyName == 'AES') {
                  myTransactionList.trustBalanceInString = (double.parse(myTransactionList.trustBalance) / 1e8).toStringAsFixed(8);
                } 
              });
              pd.dismiss();
            });
          });
      }
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> _getTransactionListAndLatestTrustBalance(ProgressDialog pd) async {
    pd.show();
    try {
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

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/getTrustTransactionList', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              print(contents.toString());
              setState(() {
                myTransactionList = TransactionList.fromJson(contents);
                _trustTransactionList.length = 0;
                // print(myTransactionList.transaction[0]);
                if (myTransactionList.transaction.length > 0) {
                  int counter = -1;
                  for (var item in myTransactionList.transaction) {
                    //  print(item.runtimeType);
                    counter++;
                    var status, date, day, month, year, time, hour, minute, second, transactionAmount, isTransferIn, transactionId;
                    for (String key in item.keys) {
                      if (key == 'amount') {
                        transactionAmount = item[key];
                        if (widget.currency.currencyName == 'BTC') {
                          transactionAmount = (item[key] / 1e8);
                        } else if (widget.currency.currencyName == 'ETH') {
                          transactionAmount = (item[key] / 1e12);
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
                      } else if (key == 'isTransferIn') {
                        isTransferIn = item[key];
                      } else if (key == 'status') {
                        status = item[key];
                      } else if (key == 'transactionId') {
                        transactionId = item[key];
                      }
                    }
                    date = year.toString() + '-' + month.toString() + '-' + day.toString();
                    time = hour.toString() + ':' + minute.toString() + ':' + second.toString();
                    if (status == 'approved' || status == 'claimed') {
                      _trustTransactionList.add(TrustTransaction(date, time, widget.currency.currencyName, transactionAmount, isTransferIn, status, day.toString(), year.toString(), month.toString(), transactionId));
                    }
                  }
                }

                
                
                if (widget.currency.currencyName == 'BTC') {
                  myTransactionList.trustBalanceInString = (double.parse(myTransactionList.trustBalance) / 1e8).toStringAsFixed(8);
                } else if (widget.currency.currencyName == 'ETH') {
                  myTransactionList.trustBalanceInString = (double.parse(myTransactionList.trustBalance) / 1e18).toStringAsFixed(10);
                } else if (widget.currency.currencyName == 'USDT') {
                  myTransactionList.trustBalanceInString = (double.parse(myTransactionList.trustBalance) / 1e6).toStringAsFixed(6);
                } else if (widget.currency.currencyName == 'AES') {
                  myTransactionList.trustBalanceInString = (double.parse(myTransactionList.trustBalance) / 1e8).toStringAsFixed(8);
                } 
               
                //  print(myTransactionList.transaction);
              });
              pd.dismiss();
            });
          });
      } else {
        print('No active user');
        pd.dismiss();
      }
    } catch (e) {
      pd.dismiss();
      print(e.message);
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      pr2 = new ProgressDialog(context, isDismissible: false);
      pr2.style(message: 'Retrieving latest data...');
      _getTransactionListAndLatestTrustBalance2(pr2);
    });
  }

  Widget _buildTransactionRow (TrustTransaction trustTransaction) {
    return Container(
      color: Colors.white,
      // padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Column(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (trustTransaction.isTransferIn) {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => TrustWithdrawPage(date: trustTransaction.date, currency: trustTransaction.currencyType, transactionAmount: trustTransaction.transactionAmount, day: trustTransaction.day, year: trustTransaction.year, month: trustTransaction.month, transactionId: trustTransaction.transactionId,)),
                  );
                }
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
                                child: Text(trustTransaction.currencyType, textAlign: TextAlign.start,),
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

    for (int i = 0; i < _trustTransactionList.length; i++) {
      sliverDelegateList.add(_buildTransactionRow(_trustTransactionList[i]));
    }

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            "Total Assets Value",
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
          _getTransactionListAndLatestTrustBalance2(pr1);
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                height: 108.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0
                          ),
                          children: <TextSpan>[
                            TextSpan(text: myTransactionList.trustBalanceInString, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0)),
                            TextSpan(text: "  " + widget.currency.currencyName)
                          ]
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 25.0),
                      child: Text(
                        '= ' + myTransactionList.trustToUsdt + ' USDT',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 12.0,
                color: Color(0xFFf2f3f5),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20.0, top: 12.0, bottom: 12.0),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Trust List',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)
                      ),
                    ),
                    Divider(
                      height: 0.0,
                    )
                  ],
                ),
              ),
            ),
            _trustTransactionList.length <= 0 ? SliverToBoxAdapter(
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
                // [
                //   _buildTransactionRow(_trustTransactionList[0]),
                //   _buildTransactionRow(_trustTransactionList[1]),
                //   _buildTransactionRow(_trustTransactionList[0]),
                //   _buildTransactionRow(_trustTransactionList[1]),
                //   _buildTransactionRow(_trustTransactionList[0]),
                //   _buildTransactionRow(_trustTransactionList[1]),
                //   _buildTransactionRow(_trustTransactionList[0]),
                //   _buildTransactionRow(_trustTransactionList[1]),
                // ]
                sliverDelegateList
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 65.0,
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
        child: RaisedButton(
          color: Color(0xFF018dee),
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => TransferTrustPage(currency: widget.currency,)),
            );
          },
          child: Text(
            "Transfer Trust",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
        ),
      ),
    );
  }
}