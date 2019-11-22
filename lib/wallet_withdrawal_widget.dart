import 'package:aes_exchange/model/currency.dart';
import 'package:aes_exchange/utils/decimal_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/transfer_trust_fess_amount.dart';

import 'dart:io';
import 'dart:convert';

class FlexibleProcessingFee {
  
  final double aesProcessing;
  var aesBalance;
  var ethBalance;

  FlexibleProcessingFee({this.aesProcessing, this.aesBalance, this.ethBalance});

  factory FlexibleProcessingFee.fromJson(Map<String, dynamic> json) {
    return FlexibleProcessingFee(
      aesProcessing: json['aesProcessing'],
      aesBalance: json['aesBalance'],
      ethBalance: json['ethBalance'],
    );
  }
}

class WalletWithdrawalPage extends StatefulWidget {

  final Currency currency;

  WalletWithdrawalPage({Key key, @required this.currency}) : super(key: key);

  @override
  _WalletWithdrawalPageState createState() => _WalletWithdrawalPageState();
}

class _WalletWithdrawalPageState extends State<WalletWithdrawalPage> {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool accept = false;
  bool textFormValidate = true;
  bool textFormValidate2 = true;
  String textFormInvalidMsg = '';
  String textFormInvalidMsg2 = '';

  final TextEditingController _quantityController = new TextEditingController();
  final TextEditingController _coinAddressController = new TextEditingController();
  String quantity;

  ProgressDialog pr1, pr2;

  int decimal = 10;

  TransferTrustFeesAndAmount myTransferTrustFeesAndAmount = TransferTrustFeesAndAmount(
    btcBalance: '0.00000000', ethBalance: '0.0000000000', aesBalance: '0.00000000', usdtBalance: '0.000000'
  );

  FlexibleProcessingFee myFlexibleProcessingFee = FlexibleProcessingFee(
    aesBalance: 0.00, ethBalance: 0.00, aesProcessing: 0.00
  );

  var avaiBalance = '0.00000000';
  var avaiBalanceForCalc;
  var avaiEthBalanceForCalc;

  var miningFee = '0.00000000';
  var miningCurrency = 'BTC';

  var queryParameters = <String, String>{};

  var actualAESProcessingFee = 0.00;

  var processingFeeRate = 0.00;
  var aesProcessingFeeRate = 0.00;
  var handlingFee = 0.00;

  bool validateBitcoinAddress (String address) {
    if ((address[0] == '1' || address[0] == '3') && address.length == 34) {
      return true;
    } else {
      return false;
    }
  }

  bool validateEthereumAddress (String address) {
    if ((address[0] == '0' && address[1] == 'x') && address.length == 42) {
      return true;
    } else {
      return false;
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

  Future<void> _confirmAndTransfer2(ProgressDialog pd, String amountToSend, String receiverAddress, String processingFee) async {
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        if (widget.currency.currencyName == 'BTC') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'btc',
            'amountToSend': amountToSend,
            'withdrawalAddress': receiverAddress,
            'processingFee': processingFee
          };
        } else if (widget.currency.currencyName == 'ETH') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'eth',
            'amountToSend': amountToSend,
            'withdrawalAddress': receiverAddress,
            'processingFee': processingFee
          };
        } else if (widget.currency.currencyName == 'USDT') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'usdt',
            'amountToSend': amountToSend,
            'withdrawalAddress': receiverAddress,
            'processingFee': processingFee
          };
        } else if (widget.currency.currencyName == 'AES') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'aes',
            'amountToSend': amountToSend,
            'withdrawalAddress': receiverAddress,
            'processingFee': processingFee
          };
        }

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/withdrawalFromWallet', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              print(contents.toString());
              pd.dismiss();
              _showMaterialDialogForError("Successfully transferred. Transaction usually takes 1 day to transfer.", "navigate");
            });
            
          });
      }
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> _requestAppropriateAvailableAmount2(ProgressDialog pd) async {
    pd.show();
    try{
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        queryParameters = {
          'uuid': user.uid
        };
        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/getAvailableBalanceFromWallet', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              setState(() {
                myTransferTrustFeesAndAmount = TransferTrustFeesAndAmount.fromJson(contents);
                if (widget.currency.currencyName == 'BTC') {
                  avaiBalance = (double.parse(myTransferTrustFeesAndAmount.btcBalance) / 1e8).toStringAsFixed(10);
                  avaiBalanceForCalc = num.parse(myTransferTrustFeesAndAmount.btcBalance);
                  decimal = 10;
                } else if (widget.currency.currencyName == 'ETH') {
                  avaiBalance = (double.parse(myTransferTrustFeesAndAmount.ethBalance) / 1e18).toStringAsFixed(12);
                  avaiBalanceForCalc = num.parse(myTransferTrustFeesAndAmount.ethBalance);
                  decimal = 12;
                } else if (widget.currency.currencyName == 'USDT') {
                  avaiBalance = (double.parse(myTransferTrustFeesAndAmount.usdtBalance) / 1e6).toStringAsFixed(8);
                  avaiBalanceForCalc = num.parse(myTransferTrustFeesAndAmount.usdtBalance);
                  decimal = 8;
                } else if (widget.currency.currencyName == 'AES') {
                  avaiBalance = (double.parse(myTransferTrustFeesAndAmount.aesBalance) / 1e8).toStringAsFixed(10);
                  avaiBalanceForCalc = num.parse(myTransferTrustFeesAndAmount.aesBalance);
                  decimal = 10;
                }
                processingFeeRate = double.parse(myTransferTrustFeesAndAmount.withdrawalProcessingFeeRate);
                aesProcessingFeeRate = double.parse(myTransferTrustFeesAndAmount.aesWithdrawalProcessingFeeRate);
                pd.dismiss();
              });
              
            });
          });
      }
    } catch (e) { 
      print(e.message);
    }
  }

  Future<void> _requestAppropriateAvailableAmount(ProgressDialog pd) async{
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        if (widget.currency.currencyName == 'BTC'){
          queryParameters = {
            'uuid': user.uid,
            // 'btcAddress': btcAddress,
            'typeOfCurrency': 'btc'
          };
        } else if (widget.currency.currencyName == 'ETH') {
          queryParameters = {
            'uuid': user.uid,
            // 'ethAddress': ethAddress,
            'typeOfCurrency': 'eth'
          };
        } else if (widget.currency.currencyName == 'USDT') {
          queryParameters = {
            'uuid': user.uid,
            // 'ethAddress': ethAddress,
            'typeOfCurrency': 'usdt'
          };
        } else if (widget.currency.currencyName == 'AES') {
          queryParameters = {
            'uuid': user.uid,
            // 'ethAddress': ethAddress,
            'typeOfCurrency': 'aes'
          };
        }

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/transferTrustPrep', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              setState(() {
                myTransferTrustFeesAndAmount = TransferTrustFeesAndAmount.fromJson(contents);
                if (widget.currency.currencyName == 'BTC'){
                  if (double.parse(myTransferTrustFeesAndAmount.btcBalance) - 30000 < 0) {
                    avaiBalance = '0.00000000';
                    avaiBalanceForCalc = 0;
                  } else {
                    avaiBalance = ((double.parse(myTransferTrustFeesAndAmount.btcBalance) - 30000) / 1e8).toStringAsFixed(8);
                    avaiBalanceForCalc = int.parse(myTransferTrustFeesAndAmount.btcBalance) - 30000;
                  }
                  miningCurrency = 'BTC';
                  miningFee = '0.00030000';
                  print(contents.toString());
                  pd.dismiss();
                } else if (widget.currency.currencyName == 'ETH') {
                  if (double.parse(myTransferTrustFeesAndAmount.ethBalance) - 357000000000000 < 0) {
                    avaiBalance = '0.00000000';
                    avaiBalanceForCalc = 0;
                  } else {
                    avaiBalance = ((double.parse(myTransferTrustFeesAndAmount.ethBalance) - 357000000000000) / 1e18).toStringAsFixed(10);
                    avaiBalanceForCalc = int.parse(myTransferTrustFeesAndAmount.ethBalance) - 357000000000000;
                  }
                  miningCurrency = 'ETH';
                  miningFee = '0.0003570000';
                  print(contents.toString());
                  pd.dismiss();
                } else if (widget.currency.currencyName == 'USDT') {
                  avaiBalance = ((double.parse(myTransferTrustFeesAndAmount.usdtBalance) / 1e6)).toStringAsFixed(6);
                  avaiBalanceForCalc = int.parse(myTransferTrustFeesAndAmount.usdtBalance);
                  avaiEthBalanceForCalc = int.parse(myTransferTrustFeesAndAmount.ethBalance);
                  miningCurrency = 'ETH (max)';
                  miningFee = '0.0004200000';
                  print(contents.toString());
                  FirebaseDatabase.instance.reference().child('users/' + user.uid + '/usdtPrevious').once()
                    .then((DataSnapshot snapshot) {
                      print('snapshot.value' + snapshot.value.toString());
                      if (snapshot.value.toString() != 'null') {
                        if (double.parse(snapshot.value.toString()) != 0) {
                          print('in condition');
                          if (snapshot.value.toString() == avaiBalance) {
                            print('Not allowed!');
                            pd.dismiss();
                            _showMaterialDialogForError('You have pending transaction. Please come back after 5 minutes', 'navigate');
                          }
                          pd.dismiss();
                        } else {
                          pd.dismiss();
                        }
                      } else {
                        pd.dismiss();
                      }
                    });
                } else if (widget.currency.currencyName == 'AES') {
                  avaiBalance = ((double.parse(myTransferTrustFeesAndAmount.aesBalance) / 1e8)).toStringAsFixed(8);
                  avaiBalanceForCalc = int.parse(myTransferTrustFeesAndAmount.aesBalance);
                  avaiEthBalanceForCalc = int.parse(myTransferTrustFeesAndAmount.ethBalance);
                  miningCurrency = 'ETH (max)';
                  miningFee = '0.0004200000';
                  print(contents.toString());
                  FirebaseDatabase.instance.reference().child('users/' + user.uid + '/aesPrevious').once()
                    .then((DataSnapshot snapshot) {
                      print('snapshot.value' + snapshot.value.toString());
                      if (snapshot.value.toString() != 'null') {
                        if (double.parse(snapshot.value.toString()) != 0) {
                          print('in condition');
                          if (snapshot.value.toString() == avaiBalance) {
                            print('Not allowed!');
                            pd.dismiss();
                            _showMaterialDialogForError('You have pending transaction. Please come back after 5 minutes', 'navigate');
                          }
                          pd.dismiss();
                        } else {
                          pd.dismiss();
                        }
                      } else {
                        pd.dismiss();
                      }
                    });
                }
              });
            });
          });
      }
    } catch (e) {
      print(e.message);
      pd.dismiss();
    }
  }
  
  Future<void> _confirmAndTransfer(ProgressDialog pd, int amountToSend, String receiverAddress) async {
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        if (widget.currency.currencyName == 'BTC') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'btc',
            'amountToSend': amountToSend.toString(),
            'receiverAddress': receiverAddress
          };
        } else if (widget.currency.currencyName == 'ETH') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'eth',
            'amountToSend': amountToSend.toString(),
            'receiverAddress': receiverAddress
          };
        } else if (widget.currency.currencyName == 'USDT') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'usdt',
            'amountToSend': amountToSend.toString(),
            'receiverAddress': receiverAddress,
            'previousBalance': avaiBalance
          };
        } else if (widget.currency.currencyName == 'AES') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'aes',
            'amountToSend': amountToSend.toString(),
            'receiverAddress': receiverAddress,
            'previousBalance': avaiBalance
          };
        } 

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/confirmTransferFromWallet', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              print(contents.toString());
            });
            pd.dismiss();
            _showMaterialDialogForError("Transfer Successfully", "navigate");
          });
        
      } else {
        pd.dismiss();

      }
    } catch (e) {
      print(e.message);
      pd.dismiss();
    }
  }

  Future<void> _getProcessingFee(ProgressDialog pd, String amountToSend) async {
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        if (widget.currency.currencyName == 'BTC') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'btc',
            'amountToProcess': amountToSend.toString()
          };
        } else if (widget.currency.currencyName == 'ETH') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'eth',
            'amountToProcess': amountToSend.toString()
          };
        } else if (widget.currency.currencyName == 'USDT') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'usdt',
            'amountToProcess': amountToSend.toString()
          };
        } else if (widget.currency.currencyName == 'AES') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'aes',
            'amountToProcess': amountToSend.toString()
          };
        } 

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/checkProcessingFeeAndAESBalance', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents){
              setState(() {
                pd.dismiss();
                myFlexibleProcessingFee = FlexibleProcessingFee.fromJson(contents);
                if (myFlexibleProcessingFee.aesProcessing * 1e3 * 1e3 * 1e2 > myFlexibleProcessingFee.aesBalance) {
                  _showMaterialDialogForError('Insufficient processing fee', 'dismissDialog');
                  accept = false;
                  pd.dismiss();
                } else if (myFlexibleProcessingFee.ethBalance < 420000000000000) {
                  _showMaterialDialogForError('Insufficient gas to process', 'dismissDialog');
                  accept = false;
                  pd.dismiss();
                } else {
                  FirebaseDatabase.instance.reference().child('users/' + user.uid + '/aesPrevious').once()
                    .then((DataSnapshot snapshot) {
                      if (snapshot.value.toString() != 'null') {
                        if (double.parse(snapshot.value.toString()) != 0) {
                          if ((snapshot.value * 1e3 * 1e3 * 1e2).toString() == myFlexibleProcessingFee.aesBalance.toString()) {
                            print('Not allowed!');
                            pd.dismiss();
                            _showMaterialDialogForError("You have pending transaction. Please try again later", "navigate");
                            
                          }
                          pd.dismiss();
                        } else {
                          pd.dismiss();
                        }
                      } else {
                        pd.dismiss();
                      }
                    });
                }
                print(contents.toString());
              });
            });
          });

      }
    } catch (err) {
      print(err.message);
      pd.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      pr2 = new ProgressDialog(context, isDismissible: false);
      pr2.style(message: 'Retrieving latest data...');
      _requestAppropriateAvailableAmount2(pr2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         backgroundColor: Colors.white,
         appBar: PreferredSize(
           preferredSize: Size.fromHeight(50.0),
           child: AppBar(elevation: 0.0,),
         ),
         body: SingleChildScrollView(
            child: Container(
             padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
             child: Column(
               children: <Widget>[
                 Container(
                   width: MediaQuery.of(context).size.width,
                   child: Text(
                     'Withdrawal',
                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                     textAlign: TextAlign.start,
                   ),
                 ),
                 Container(
                   margin: EdgeInsets.only(top: 15.0),
                   padding: EdgeInsets.only(left: 20.0, top: 5.0, bottom: 5.0),
                   color: Color(0xFFf7f6fb),
                   height: 35.0,
                   child: Row(
                     children: <Widget>[
                       Image(image: AssetImage(widget.currency.currencyLogoUrl), width: 25.0,),
                       Container(
                         margin: EdgeInsets.only(left: 10.0),
                         child: Text(
                           widget.currency.currencyName,
                           style: TextStyle(fontWeight: FontWeight.bold),
                         ),
                       ),
                     ],
                   ),
                 ),
                 Container(
                  margin: EdgeInsets.only(top: 15.0, bottom: 5.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Coin Address',
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                    textAlign: TextAlign.start,
                  ),
                ),
                TextFormField(
                  enabled: !accept,
                  controller: _coinAddressController,
                  onFieldSubmitted: (term) {

                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    errorText: textFormValidate2 ? null : textFormInvalidMsg2,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFe5e5e7))
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                    ),
                    hintText: 'Please enter your address',
                    hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),
                    border: OutlineInputBorder(),
                    // suffixIcon: Container(
                    //   width: 75.0,
                    //   child: Row(
                    //     children: <Widget>[
                    //       Container(
                    //         child: Icon(Icons.center_focus_weak, size: 20.0, color: Colors.black,),
                    //       ),
                          
                    //       Text(
                    //         '  |',
                    //         style: TextStyle(fontSize: 25.0, color: Color(0xFFc4c5c7), fontWeight: FontWeight.w200),
                    //       ),
                    //       Container(
                    //         margin: EdgeInsets.only(left: 10.0),
                    //         child: InkWell(
                    //           highlightColor: Colors.transparent,
                    //           splashColor: Colors.transparent,
                    //           onTap: () {

                    //           },
                    //           child: Text(
                    //             "Add",
                    //             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12.0),
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0, bottom: 5.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Quantity',
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                    textAlign: TextAlign.start,
                  ),
                ),
                TextFormField(
                  enabled: !accept,
                  onFieldSubmitted: (term) {

                  },
                  onChanged: (text) {
                    print(_quantityController.text);
                    if (_quantityController.text == '') {
                      setState(() {
                        handlingFee = 0.00;
                      });
                    } else {
                      setState(() {
                        if (widget.currency.currencyName != 'AES') {
                          handlingFee = double.parse(_quantityController.text) * processingFeeRate;
                        } else {
                          handlingFee = double.parse(_quantityController.text) * aesProcessingFeeRate;
                        }
                        
                      });
                    }
                   
                  },
                  inputFormatters: [DecimalTextInputFormatter(decimalRange: decimal)],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _quantityController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    errorText: textFormValidate ? null : textFormInvalidMsg,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFe5e5e7))
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                    ),
                    hintText: 'Please enter your quantity',
                    hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),
                    border: OutlineInputBorder(),
                    suffixIcon: Container(
                      width: 75.0,
                      child: Row(
                        children: <Widget>[
                          Text(
                            widget.currency.currencyName,
                            style: TextStyle(fontSize: 12.0, color: Colors.grey),
                          ),
                          Text(
                            '  |',
                            style: TextStyle(fontSize: 25.0, color: Color(0xFFc4c5c7), fontWeight: FontWeight.w200),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                _quantityController.text = avaiBalance;
                                 setState(() {
                                    handlingFee = double.parse(_quantityController.text) * processingFeeRate;
                                  });
                              },
                              child: Text(
                                "All",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Available amount ' + avaiBalance + ' ' + widget.currency.currencyName,
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 12.0, top: 15.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Handling fee',
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 10.0, top: 12.0),
                  child: Text(
                    handlingFee.toStringAsFixed(8) + ' ' + widget.currency.currencyName,
                    style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                // Divider(
                //   thickness: 0.5,
                //   height: 0.0,
                // ),
                // Container(
                //   margin: EdgeInsets.only(top: 15.0),
                //   padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                //   color: Color(0xFFf7f6fb),
                //   height: 35.0,
                //   child: Row(
                //     children: <Widget>[
                //       Text(
                //        'Mining Fee / Gas Price: ' + miningFee + ' ' + miningCurrency,
                //        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                //      )
                //     ],
                //   ),
                // ),
                // Container(
                //   margin: EdgeInsets.only(top: 15.0),
                //   child: Row(
                //     children: <Widget>[
                //       Text(
                //         'Withdrawal Amount',
                //         style: TextStyle(color: Colors.grey),
                //       ),
                //       Spacer(),
                //       Text(
                //         '0.00000000 BTC',
                //         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                //       )
                //     ],
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                          value: accept,
                          onChanged: (bool value) {
                            setState(() {
                              var inputQuantityInDouble;

                              if (_quantityController.text.isNotEmpty) {
                                if (widget.currency.currencyName == 'BTC') {
                                  inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e2;
                                  inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsFixed(2));
                                } else if (widget.currency.currencyName == 'ETH'){
                                  inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e3 * 1e3 * 1e3 * 1e3;
                                  inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsFixed(2));
                                } else if (widget.currency.currencyName == 'USDT'){
                                  inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3;
                                  inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsFixed(2));
                                } else if (widget.currency.currencyName == 'AES'){
                                  inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e2;
                                  inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsFixed(2));
                                }
                              }

                              print('inputQuantityInDouble ' + inputQuantityInDouble.toString());
                              print('avaiBalanceForCalc ' + avaiBalanceForCalc.toString());
                              print('avaiBalance ' + avaiBalance.toString());

                              if (_coinAddressController.text.isNotEmpty) {
                                if (widget.currency.currencyName == 'BTC') {
                                  if (!validateBitcoinAddress(_coinAddressController.text)) {
                                    textFormValidate2 = false;
                                    textFormInvalidMsg2 = 'Invalid bitcoin address.';
                                  } else {
                                    textFormValidate2 = true;
                                  }
                                } else {
                                  if (!validateEthereumAddress(_coinAddressController.text)) {
                                    textFormValidate2 = false;
                                    textFormInvalidMsg2 = 'Invalid address.';
                                  } else {
                                    textFormValidate2 = true;
                                  }
                                }
                              } else if (_coinAddressController.text.isEmpty) {
                                textFormValidate2 = false;
                                textFormInvalidMsg2 = 'Please insert address.';
                              }

                              if (_quantityController.text.isEmpty) {
                                textFormValidate = false;
                                textFormInvalidMsg = 'Please insert minimum amount.';
                              } else if (inputQuantityInDouble <= 0){
                                textFormValidate = false;
                                textFormInvalidMsg = 'Insufficient Fund to transfer.';
                              } else if (inputQuantityInDouble + handlingFee > avaiBalanceForCalc){
                                textFormValidate = false;
                                textFormInvalidMsg = 'Insufficient Fund / Processing Fee.';
                              } else {
                                // accept = value;
                                textFormValidate = true;
                                if (textFormValidate && textFormValidate2) {
                                  if (value) {
                                    _showMaterialDialogForError('Please double confirm the receiver address is\n ' + _coinAddressController.text + '\n\nThis process is not reversible.', 'dismissDialog');
                                    accept = value;
                                  } else {
                                    accept = value;
                                  }
                                  
                                }
                                // pr1 = new ProgressDialog(context, isDismissible: false);
                                // pr1.style(message: 'Verifying Transaction...');
                                // if (value) {
                                //   if (widget.currency.currencyName == 'BTC') {
                                //     // _getProcessingFee(pr1, _quantityController.text);
                                //   } else if (widget.currency.currencyName == 'ETH'){

                                //   } else if (widget.currency.currencyName == 'USDT'){
                                //     if (avaiEthBalanceForCalc < 420000000000000) {
                                //       textFormValidate = false;
                                //       textFormInvalidMsg = 'Insufficient Gas for transaction.';
                                //       return;
                                //     }
                                //   } else if (widget.currency.currencyName == 'AES'){
                                //     if (avaiEthBalanceForCalc < 420000000000000) {
                                //       textFormValidate = false;
                                //       textFormInvalidMsg = 'Insufficient Gas for transaction.';
                                //       return;
                                //     }
                                //   }
                                //   // accept = value;
                                //   textFormValidate = true;
                                // } else {
                                //   accept = value;
                                // }
                              }

                              
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
                              'Terms and Conditions',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                          ),
                          
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 0.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: accept ? () {
                      pr1 = new ProgressDialog(context, isDismissible: false);
                      pr1.style(message: 'Verifying Transaction...');
                      // if (widget.currency.currencyName == 'BTC') {
                      //   _confirmAndTransfer(pr1, (double.parse(_quantityController.text) * 1e3 * 1e3 * 1e2).round(), _coinAddressController.text);
                      // } else if (widget.currency.currencyName == 'ETH') {
                      //   _confirmAndTransfer(pr1, (double.parse(_quantityController.text) * 1e3 * 1e3 * 1e3 * 1e3 * 1e3 * 1e3).round(), _coinAddressController.text);
                      // } else if (widget.currency.currencyName == 'USDT') {
                      //   _confirmAndTransfer(pr1, (double.parse(_quantityController.text) * 1e3 * 1e3).round(), _coinAddressController.text);
                      // } else if (widget.currency.currencyName == 'AES') {
                      //   _confirmAndTransfer(pr1, (double.parse(_quantityController.text) * 1e3 * 1e3 * 1e2).round(), _coinAddressController.text);
                      // }
                      // print(_coinAddressController.text);
                      var inputQuantityInDouble, processingFeeInString;
                      if (widget.currency.currencyName == 'BTC') {
                        inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e2;
                        inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsFixed(2));
                        processingFeeInString = (handlingFee * 1e8).toStringAsFixed(2);
                      } else if (widget.currency.currencyName == 'ETH'){
                        inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e3 * 1e3 * 1e3 * 1e3;
                        inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsFixed(2));
                        processingFeeInString = (handlingFee * 1e18).toStringAsFixed(2);
                      } else if (widget.currency.currencyName == 'USDT'){
                        inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3;
                        inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsFixed(2));
                        processingFeeInString = (handlingFee * 1e6).toStringAsFixed(2);
                      } else if (widget.currency.currencyName == 'AES'){
                        inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e2;
                        inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsFixed(2));
                        processingFeeInString = (handlingFee * 1e8).toStringAsFixed(2);
                      }
                      _confirmAndTransfer2(pr1, inputQuantityInDouble.toString(), _coinAddressController.text, processingFeeInString);
                      

                    } : null,
                    child: Text(
                      'Withdrawal',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
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