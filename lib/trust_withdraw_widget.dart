import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'dart:io';
import 'dart:convert';

import 'model/processing_fee.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrustWithdrawPage extends StatefulWidget {
  final String date;
  final String currency;
  var transactionAmount;
  var day='1', year='1997', month='1';
  final String transactionId;


  TrustWithdrawPage({Key key,  @required this.date, @required this.currency, @required this.transactionAmount, @required this.day, @required this.year, @required this.month, @required this.transactionId}) : super(key: key);

  @override
  _TrustWithdrawPageState createState() => _TrustWithdrawPageState();
}

class _TrustWithdrawPageState extends State<TrustWithdrawPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool accept = false;

  var queryParameters = <String, String>{};

  ProgressDialog pr1, pr2;

  ProcessingFee processingFee = ProcessingFee(lowProcessing: 0.00, highProcessing: 0.00, processingFee: '0.0');
  var actualAESProcessingFee = 0.00;

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
                child: Text('OK', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                onPressed: () {
                  if (condition == 'navigate') {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else if (condition == 'dismissDialog') {
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

  Future<void> _confirmWithdrawTrust2 (ProgressDialog pd) async {
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        if (widget.currency == 'BTC') {
          var withdrawalAmount = widget.transactionAmount * 1e3 * 1e3 * 1e2;
          withdrawalAmount = num.parse(withdrawalAmount.toStringAsPrecision(12));
          var processingAmount = actualAESProcessingFee * 1e3 * 1e3 * 1e2;
          processingAmount = num.parse(processingAmount.toStringAsPrecision(12));
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'btc',
            'oldTransactionId': widget.transactionId,
            'withdrawalAmount': withdrawalAmount.toString(),
            'processingFee': processingAmount.toString()
          };
        } else if (widget.currency == 'ETH') {
          var withdrawalAmount = widget.transactionAmount * 1e3 * 1e3 * 1e3 * 1e3 * 1e3 * 1e3;
          withdrawalAmount = num.parse(withdrawalAmount.toStringAsPrecision(12));
          var processingAmount = actualAESProcessingFee * 1e3 * 1e3 * 1e3 * 1e3 * 1e3 * 1e3;
          processingAmount = num.parse(processingAmount.toStringAsPrecision(12));
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'eth',
            'oldTransactionId': widget.transactionId,
            'withdrawalAmount': withdrawalAmount.toString(),
            'processingFee': processingAmount.toString()
          };
        } else if (widget.currency == 'USDT') {
          var withdrawalAmount = widget.transactionAmount * 1e3 * 1e3;
          withdrawalAmount = num.parse(withdrawalAmount.toStringAsPrecision(12));
          var processingAmount = actualAESProcessingFee * 1e3 * 1e3;
          processingAmount = num.parse(processingAmount.toStringAsPrecision(12));
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'usdt',
            'oldTransactionId': widget.transactionId,
            'withdrawalAmount': withdrawalAmount.toString(),
            'processingFee': processingAmount.toString()
          };
        } else if (widget.currency == 'AES') {
          var withdrawalAmount = widget.transactionAmount * 1e3 * 1e3 * 1e2;
          withdrawalAmount = num.parse(withdrawalAmount.toStringAsPrecision(12));
          var processingAmount = actualAESProcessingFee * 1e3 * 1e3 * 1e2;
          processingAmount = num.parse(processingAmount.toStringAsPrecision(12));
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'aes',
            'oldTransactionId': widget.transactionId,
            'withdrawalAmount': withdrawalAmount.toString(),
            'processingFee': processingAmount.toString()
          };
        }

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/processWithdrawTrust', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              print(contents.toString());
              pd.dismiss();
              _showMaterialDialogForError('Successful Withdraw', 'navigate');
            });
          });
      }
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> _confirmWithdrawTrust (ProgressDialog pd) async {
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        if (widget.currency == 'BTC') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'btc',
            'oldTransactionId': widget.transactionId,
            'withdrawalAmount': (widget.transactionAmount * 1e3 * 1e3 * 1e2).toString(),
            'aesProcessingFee': (actualAESProcessingFee * 1e3 * 1e3 * 1e2).toString(),
            'aesPrevBalance': (processingFee.aesBalance * 1e3 * 1e3 *1e2).toString()
          };
        } else if (widget.currency == 'ETH') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'eth',
            'oldTransactionId': widget.transactionId,
            'withdrawalAmount': (widget.transactionAmount * 1e3 * 1e3 * 1e3 * 1e3).toString(), // now we put 1e12 because we need to consider firebase restriction, but remember the real transaction have to convert to full int, even in the admin firebase database
            'aesProcessingFee': (actualAESProcessingFee * 1e3 * 1e3 * 1e2).toString(),  // Therefore in admin database, when doing real transaction have to multiply the current integer with *1e6 to the real transaction case (which is in unit WEI)
            'aesPrevBalance': (processingFee.aesBalance * 1e3 * 1e3 *1e2).toString()
          };
        } else if (widget.currency == 'USDT') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'usdt',
            'oldTransactionId': widget.transactionId,
            'withdrawalAmount': (widget.transactionAmount * 1e3 * 1e3).toString(),
            'aesProcessingFee': (actualAESProcessingFee * 1e3 * 1e3 * 1e2).toString(),
            'aesPrevBalance': (processingFee.aesBalance * 1e3 * 1e3 *1e2).toString()
          };
        } else if (widget.currency == 'AES') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'aes',
            'oldTransactionId': widget.transactionId,
            'withdrawalAmount': (widget.transactionAmount * 1e3 * 1e3 * 1e2).toString(),
            'aesProcessingFee': (actualAESProcessingFee * 1e3 * 1e3 * 1e2).toString(),
            'aesPrevBalance': (processingFee.aesBalance * 1e3 * 1e3 *1e2).toString()
          };
        }

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/withdrawTrustTest', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              print(contents.toString());
              pd.dismiss();
              _showMaterialDialogForError('Pending for approval', 'navigate');
            });
          });
      }
    } catch (e) {
      pd.dismiss();
      print(e.message);
    }
  }
  
  Future<void> _requestProcessingFee2 (ProgressDialog pd) async {
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        if (widget.currency == 'BTC') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'btc',
            'amountToProcess': widget.transactionAmount.toStringAsFixed(8),
            'transactionId': widget.transactionId
          };
        } else if (widget.currency == 'ETH') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'eth',
            'amountToProcess': widget.transactionAmount.toStringAsFixed(10),
            'transactionId': widget.transactionId
          };
        } else if (widget.currency == 'USDT') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'usdt',
            'amountToProcess': widget.transactionAmount.toStringAsFixed(6),
            'transactionId': widget.transactionId
          };
        } else if (widget.currency == 'AES') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'aes',
            'amountToProcess': widget.transactionAmount.toStringAsFixed(8),
            'transactionId': widget.transactionId
          };
        }

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/updateTrustWithdrawProcessingFee', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              print(contents.toString());
              setState(() {
                processingFee = ProcessingFee.fromJson(contents); 
                final trustInDate = DateTime(int.parse(widget.year), int.parse(widget.month), int.parse(widget.day));
                final currentDate = DateTime.now();
                final difference = currentDate.difference(trustInDate).inDays;
                if (difference > 30) {
                  actualAESProcessingFee = 0;
                } else {
                  actualAESProcessingFee = double.parse(processingFee.processingFee);
                }
              });
              pd.dismiss();
            });
          });
      }
    } catch (e) {
      pd.dismiss();
      print(e.message);
    }
  }

  Future<void> _requestProcessingFee (ProgressDialog pd) async {
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        if (widget.currency == 'BTC') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'btc',
            'amountToProcess': widget.transactionAmount.toStringAsFixed(8),
            'transactionId': widget.transactionId
          };
        } else if (widget.currency == 'ETH') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'eth',
            'amountToProcess': widget.transactionAmount.toStringAsFixed(10),
            'transactionId': widget.transactionId
          };
        } else if (widget.currency == 'USDT') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'usdt',
            'amountToProcess': widget.transactionAmount.toStringAsFixed(6),
            'transactionId': widget.transactionId
          };
        } else if (widget.currency == 'AES') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'aes',
            'amountToProcess': widget.transactionAmount.toStringAsFixed(8),
            'transactionId': widget.transactionId
          };
        }

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/processingFee', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              print('contents ' + contents.toString());
              
              setState(() {
                processingFee = ProcessingFee.fromJson(contents);
                // convert full of aesBalance to actual
                processingFee.aesBalance = processingFee.aesBalance / 1e8;
                final trustInDate = DateTime(int.parse(widget.year), int.parse(widget.month), int.parse(widget.day));
                final currentDate = DateTime.now();
                final difference = currentDate.difference(trustInDate).inDays;
                if (difference > 28) {
                  actualAESProcessingFee = processingFee.lowProcessing;
                } else {
                  actualAESProcessingFee = processingFee.highProcessing;
                }
                print('transactionamount:' + widget.transactionAmount.toStringAsFixed(10));
                print('transactionamountInInt:' + (widget.transactionAmount*1e8).toString());
                FirebaseDatabase.instance.reference().child('users/' + user.uid + '/aesPrevious').once()
                  .then((DataSnapshot snapshot) {
                    if (snapshot.value.toString() != 'null') {
                      if (double.parse(snapshot.value.toString()) != 0) {
                        if (snapshot.value.toString() == processingFee.aesBalance) {
                          print('Not allowed!');
                          _showMaterialDialogForError('You have pending transaction. Please try again later', 'navigate');
                          
                        }
                        pd.dismiss();
                      } else {
                        pd.dismiss();
                      }
                    } else {
                      pd.dismiss();
                    }
                  });
              });
              print(widget.transactionId);
              pd.dismiss();
            });
          });
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
      _requestProcessingFee2(pr2);
    });
    

  }
  
  //TODO: During transaction remember to use transactionAmount * 0.x in order to make it into integer
  @override
  Widget build(BuildContext context) {
    var transactionAmountInString;
    final trustInDate = DateTime(int.parse(widget.year), int.parse(widget.month), int.parse(widget.day));
    final currentDate = DateTime.now();
    final difference = currentDate.difference(trustInDate).inDays;
    
    if (widget.currency == 'BTC') {
      transactionAmountInString = widget.transactionAmount.toStringAsFixed(8);
    } else if (widget.currency == 'ETH') {
      transactionAmountInString = widget.transactionAmount.toStringAsFixed(10);
    } else if (widget.currency == 'AES') {
      transactionAmountInString = widget.transactionAmount.toStringAsFixed(8);
    } else if (widget.currency == 'USDT') {
      transactionAmountInString = widget.transactionAmount.toStringAsFixed(6);
    }

    pr1 = new ProgressDialog(context, isDismissible: false);
    pr1.style(message: 'Create transaction. Do not close the dialog.');
    
    return Container(
       child: Scaffold(
         backgroundColor: Color(0xFFFAFAFA),
         appBar: PreferredSize(
           preferredSize: Size.fromHeight(50.0),
           child: AppBar(
             centerTitle: true,
             elevation: 0.0,
             title: Text(
               "Withdraw",
               style: Theme.of(context).textTheme.title,
             ),
           ),
         ),
         body: Container(
           color: Colors.white,
           padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
           child: Column(
             children: <Widget>[
               Container(
                 height: 70.0,
                 decoration: BoxDecoration(
                   border: Border.all(color: Color(0xFFfcfcfc))
                 ),
                 child: Column(
                   children: <Widget>[
                     Container(
                       height: 34.0,
                       color: Colors.white,
                       margin: EdgeInsets.only(left: 10.0, right: 10.0),
                       child: Row(
                         children: <Widget>[
                           ClipOval(
                             child: Container(
                               color: Color(0xFF1c71ad),
                               width: 8.0,
                               height: 8.0,
                             ),
                           ),
                           Container(
                             margin: EdgeInsets.only(left: 15.0),
                             child: Text(
                                "Trust in date",
                                style: TextStyle(color: Color(0xFFbec0bf)),
                              ),
                           ),
                           Container(
                             margin: EdgeInsets.only(left: 15.0),
                             child: Text(
                                widget.date,
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                           )
                         ],
                       ),
                     ),
                     Divider(
                       color: Colors.grey,
                       thickness: 0.3,
                       height: 0.0,
                     ),
                     Container(
                       height: 34.0,
                       color: Colors.white,
                       margin: EdgeInsets.only(left: 10.0, right: 10.0),
                       child: Row(
                         children: <Widget>[
                           ClipOval(
                             child: Container(
                               color: Color(0xFFd14970),
                               width: 8.0,
                               height: 8.0,
                             ),
                           ),
                           Container(
                             margin: EdgeInsets.only(left: 15.0),
                             child: Text(
                                "Duration",
                                style: TextStyle(color: Color(0xFFbec0bf)),
                              ),
                           ),
                           Container(
                             margin: EdgeInsets.only(left: 15.0),
                             child: Text(
                                difference > 1 ? difference.toString() + ' days' : difference.toString() + ' day',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                           )
                         ],
                       ),
                     ),
                   ],
                 ),
               ),
               Container(
                 margin: EdgeInsets.only(top: 30.0, bottom: 12.0),
                 width: MediaQuery.of(context).size.width,
                 child: Text(
                   'Coin',
                   style: TextStyle(color: Color(0xFF5f696b), fontSize: 14.0),
                   textAlign: TextAlign.start,
                 ),
               ),
               Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    widget.currency,
                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  height: 0.0,
                ),
                Container(
                 margin: EdgeInsets.only(top: 30.0, bottom: 12.0),
                 width: MediaQuery.of(context).size.width,
                 child: Text(
                   'Amount',
                   style: TextStyle(color: Color(0xFF5f696b), fontSize: 14.0),
                   textAlign: TextAlign.start,
                 ),
               ),
               Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    transactionAmountInString,
                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  height: 0.0,
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  padding: EdgeInsets.all(15.0),
                  color: Color(0xFFf7f6fb),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'If you stop storing FD at AES Wallet within 30 days, you will be charged a 5% fee.\nAfter 30 days, it can be realized at any time, no handling fee is deducted.\n\nProcessing fees: ' + actualAESProcessingFee.toString() + ' ' + widget.currency,
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                          value: accept,
                          onChanged: (bool value) {
                            setState(() {
                              // if (processingFee.aesBalance < actualAESProcessingFee) {
                              //   print('Insufficient processing fee');
                              //   _showMaterialDialogForError('Insufficient processing fee', 'dismissDialog');
                              // } else if (processingFee.ethBalance < 420000000000000) {
                              //   print('Insufficient gas');
                              //   _showMaterialDialogForError('Insufficient gas', 'dismissDialog');
                              // } else {
                              //   accept = value; 
                              // }
                              if (value) {
                                if ((processingFee.currentBalance + widget.transactionAmount) < actualAESProcessingFee) {
                                  _showMaterialDialogForError('Insufficient processing fee', 'dismissDialog');
                                } else {
                                  _showMaterialDialogForError('For trust that store less than 30 days will be implied with a surcharge of 5% processing fee. Are you sure?', 'dismissDialog');
                                  accept = value;
                                }
                              } else{
                                accept = value;
                              }

                              var withdrawalAmount = widget.transactionAmount * 1e3 * 1e3 * 1e2;
                              withdrawalAmount = num.parse(withdrawalAmount.toStringAsPrecision(12));
                              var processingAmount = actualAESProcessingFee * 1e3 * 1e3 * 1e2;
                              processingAmount = num.parse(processingAmount.toStringAsPrecision(12));
                              
                              print(processingAmount.toString());
                              print(withdrawalAmount.toString());

                              // if (processingFee.ethBalance < 420000000000000) {
                              //   _showMaterialDialogForError('Insufficient gas', 'dismissDialog');
                              // } else {
                              //   accept = value;
                              // }
                              // _showMaterialDialogForError('Transaction pending for approval', 'navigate');
                              
                            });
                          },
                        ),
                        Container(
                        //  margin: EdgeInsets.only(left: 10.0),
                          child: Text(
                            'I agree '
                          ),
                        ),
                        Container(
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              
                            },
                            child: Text(
                              'Trust Trading Rules',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          color: Colors.blue,
                          onPressed: accept && processingFee.status != 'claimed' ? () {
                            // test();
                            _confirmWithdrawTrust2(pr1);
                            
                            
                          } : null,
                          child: Text(
                            processingFee.status == 'claimed' ? 'You have withdrawn this' : 'Confirm Withdraw',
                            
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                      ),
                      )
                    ),
                  ),
                )
             ],
           ),
         ),
       ),
    );
  }
}