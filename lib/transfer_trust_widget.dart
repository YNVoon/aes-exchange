import 'package:aes_exchange/model/trust_currency.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'utils/decimal_text_input_formatter.dart';
import 'model/transfer_trust_fess_amount.dart';

import 'dart:io';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransferTrustPage extends StatefulWidget {

  TrustCurrency currency;

  TransferTrustPage({Key key, @required this.currency}) : super(key: key);

  @override
  _TransferTrustPageState createState() => _TransferTrustPageState();
}

// class TransferTrustFeesAndAmount {
//   final String btcBalance;
//   final String ethBalance;
//   final String aesBalance;
//   final String usdtBalance;

//   TransferTrustFeesAndAmount({this.btcBalance, this.ethBalance, this.aesBalance, this.usdtBalance});

//   factory TransferTrustFeesAndAmount.fromJson(Map<String, dynamic> json) {
//     return TransferTrustFeesAndAmount(
//       btcBalance: json['btcBalance'].toString(),
//       ethBalance: json['ethBalance'].toString(),
//       aesBalance: json['aesBalance'].toString(),
//       usdtBalance: json['usdtBalance'].toString()
//     );
//   }
// }

class _TransferTrustPageState extends State<TransferTrustPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProgressDialog pr1, pr2;

  bool accept = false;
  bool textFormValidate = true;
  String textFormInvalidMsg = '';

  final TextEditingController _quantityController = new TextEditingController();
  String quantity;

  var avaiBalance = '0.00000000';
  var avaiBalanceForCalc;
  var avaiEthBalanceForCalc;

  var miningFee = '0.00000000';
  var miningCurrency = 'BTC';

  TransferTrustFeesAndAmount myTransferTrustFeesAndAmount = TransferTrustFeesAndAmount(
    btcBalance: '0.00000000', ethBalance: '0.0000000000', aesBalance: '0.00000000', usdtBalance: '0.000000'
  );

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

  var queryParameters = <String, String>{};

  Future<void> _requestAppropriateAvailableAmount(ProgressDialog pd) async{
    pd.show();
    // var btcAddress, ethAddress;
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        // To check whether there is any transaction before
        
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
          response.transform(Utf8Decoder()).transform(json.decoder).listen((contents){
            setState(() {
              myTransferTrustFeesAndAmount = TransferTrustFeesAndAmount.fromJson(contents); 
            });
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

          // pd.dismiss();
        });
      } else {
        pd.dismiss();
        print('No active user');
      }
    } catch (e) {
      pd.dismiss();
      print(e.message);
    }

    
    
  }

  Future<void> _confirmAndTransfer(ProgressDialog pd, int amountToSend) async {
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        if (widget.currency.currencyName == 'BTC') {
          queryParameters = {
            'typeOfCurrency': 'btc',
            'uuid': user.uid,
            'amountToSend': amountToSend.toString()
          };
        } else if (widget.currency.currencyName == 'ETH') {
          queryParameters = {
            'typeOfCurrency': 'eth',
            'uuid': user.uid,
            'amountToSend': amountToSend.toString()
          };
        } else if (widget.currency.currencyName == 'USDT') {
          queryParameters = {
            'typeOfCurrency': 'usdt',
            'uuid': user.uid,
            'amountToSend': amountToSend.toString(),
            //#FFF
            'previousBalance': avaiBalance // need to store this to database if success transaction
          };
        } else if (widget.currency.currencyName == 'AES') {
          queryParameters = {
            'typeOfCurrency': 'aes',
            'uuid': user.uid,
            'amountToSend': amountToSend.toString(),
            //#FFF
            'previousBalance': avaiBalance // need to store this to database if success transaction
          };
        }

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/confirmTransferTrust', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              print(contents.toString());
              
            });
            pd.dismiss();
            _showMaterialDialogForError("Successful transfer", "navigate");
            // Navigator.pop(context);
            
          });
        
      }
    } catch (e) {
      pd.dismiss();
      print(e.message);
    }
  }

  Future<void> _createAndVerifyTrustTransfer(ProgressDialog pd, int amountToSend) async {
    var senderBtcAddress, senderEthAddress, receiverBtcAddress, receiverEthAddress;
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        final usersRef = FirebaseDatabase.instance.reference().child('users/' + user.uid);
        final currencyRef = FirebaseDatabase.instance.reference().child('admin/currencyAddress');
        usersRef.once().then((DataSnapshot snapshot) {
          senderBtcAddress = snapshot.value.entries.elementAt(1).value.toString();
          // senderBtcAddress = '18rVSPVVjeMnhvncT1LuHZBzzkAoet4vcr';
          senderEthAddress = snapshot.value.entries.elementAt(11).value.toString();
          // senderEthAddress = '0x3c06e885c32e2e7d09eaf4c8e80480bd5e87f9f5';
          currencyRef.once().then((DataSnapshot snapshot) {
            receiverBtcAddress = snapshot.value.entries.elementAt(1).value.toString();
            receiverEthAddress = snapshot.value.entries.elementAt(0).value.toString();
            // receiverBtcAddress = "15iCdrjtw8R7f6HXbUvEWgyW2QzQsVvGhA";
            // receiverEthAddress = "0x119441cd07b87056b46233b75c8d32604327e061";
            print('btc ' + receiverBtcAddress);
            print('eth ' + receiverEthAddress);
            
            if (widget.currency.currencyName == 'BTC') {
              queryParameters = {
                'typeOfCurrency': 'btc',
                'senderAddress': senderBtcAddress,
                'receiverAddress': receiverBtcAddress,
                'amountToSend': amountToSend.toString()
              };
            } else if (widget.currency.currencyName == 'ETH') {
              queryParameters = {
                'typeOfCurrency': 'eth',
                'senderAddress': senderEthAddress,
                'receiverAddress': receiverEthAddress,
                'amountToSend': amountToSend.toString()
              };
            } else if (widget.currency.currencyName == 'USDT') {
              queryParameters = {
                'typeOfCurrency': 'usdt',
                'senderAddress': senderEthAddress,
                'receiverAddress': receiverEthAddress,
                'amountToSend': amountToSend.toString()
              };
            } else if (widget.currency.currencyName == 'AES') {
              queryParameters = {
                'typeOfCurrency': 'aes',
                'senderAddress': senderEthAddress,
                'receiverAddress': receiverEthAddress,
                'amountToSend': amountToSend.toString()
              };
            } 
            // pd.dismiss();

            new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/createAndVerifyTrustTransfer', queryParameters))
              .then((HttpClientRequest request) => request.close())
              .then((HttpClientResponse response) {
                response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
                  print(contents.toString());
                  
                });
                pd.dismiss();
                
              });
          });
        });
      } else {
        pd.dismiss();
        print('No active user');
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
      _requestAppropriateAvailableAmount(pr2);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
       child: Scaffold(
         backgroundColor: Colors.white,
         appBar: PreferredSize(
           preferredSize: Size.fromHeight(50.0),
           child: AppBar(
             centerTitle: true,
             elevation: 0.0,
             title: Text(
               "Transfer",
               style: Theme.of(context).textTheme.title,
             ),
           ),
         ),
         body: Container(
           padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
           child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 12.0),
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
                    widget.currency.currencyName,
                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  height: 0.0,
                ),
                Container(
                  margin: EdgeInsets.only(top: 25.0, bottom: 15.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Quantity',
                    style: TextStyle(color: Color(0xFF5f696b), fontSize: 14.0),
                    textAlign: TextAlign.start,
                  ),
                ),
                TextFormField(
                  enabled: !accept,
                  onFieldSubmitted: (term) {
                    print(_quantityController.text);
                  },
                  validator: (value) {
                  },
                  inputFormatters: [DecimalTextInputFormatter(decimalRange: 10)],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  // keyboardType: TextInputType.number,
                  controller: _quantityController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    errorText: textFormValidate ? null : textFormInvalidMsg,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFfafafa))
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                    ),
                    hintText: 'Input Quantity',
                    hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),
                    border: OutlineInputBorder(),
                    suffixIcon: Container(
                      width: 75.0,
                      child: Row(
                        children: <Widget>[
                          Text(
                            widget.currency.currencyName + '  |',
                            style: TextStyle(fontSize: 12.0, color: Color(0xFFc4c5c7)),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                _quantityController.text = avaiBalance;
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
                  margin: EdgeInsets.only(top: 15.0),
                  padding: EdgeInsets.all(15.0),
                  color: Color(0xFFf7f6fb),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Mining Fee / Gas Price: ' + miningFee + ' ' + miningCurrency,
                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                      )
                    ],
                  ),
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
                        'Note: When the total value of Trust is turned on, it will automatically turn on Trust to generate revenue (additional fee is charged for Re-turning out.',
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
                              var inputQuantityInDouble;

                              if (_quantityController.text.isNotEmpty) {
                                if (widget.currency.currencyName == 'BTC') {
                                  inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e2;
                                } else if (widget.currency.currencyName == 'ETH'){
                                  inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e3 * 1e3 * 1e3 * 1e3;
                                } else if (widget.currency.currencyName == 'USDT'){
                                  inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3;
                                } else if (widget.currency.currencyName == 'AES'){
                                  inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e2;
                                }
                              }

                              print('inputQuantityInDouble' + inputQuantityInDouble.toString());
                              
                              if (_quantityController.text.isEmpty) {
                                textFormValidate = false;
                                textFormInvalidMsg = 'Please insert minimum amount.';
                              } else if (inputQuantityInDouble <= 0){
                                textFormValidate = false;
                                textFormInvalidMsg = 'Insufficient Fund to transfer.';
                              } else if (inputQuantityInDouble > avaiBalanceForCalc){
                                textFormValidate = false;
                                textFormInvalidMsg = 'Insufficient Fund.';
                                
                              } else {
                                pr1 = new ProgressDialog(context, isDismissible: false);
                                pr1.style(message: 'Verifying Transaction...');
                                if (value) {
                                  if (widget.currency.currencyName == 'BTC') {
                                    // _createAndVerifyTrustTransfer(pr1, (double.parse(_quantityController.text) * 1e8).round());
                                    // _createAndVerifyTrustTransfer(pr1, 1000000);
                                  } else if (widget.currency.currencyName == 'ETH'){
                                    // TODO: !!!!!!!!!!! When we transfer ETH, the receipt of total eth transfer need to divide by 6 then only can push to firebase as a transaction
                                    // _createAndVerifyTrustTransfer(pr1, (double.parse(_quantityController.text) * 1e18).round());
                                  } else if (widget.currency.currencyName == 'USDT'){
                                    // _createAndVerifyTrustTransfer(pr1, (double.parse(_quantityController.text) * 1e6).round());
                                    if (avaiEthBalanceForCalc < 420000000000000) {
                                      textFormValidate = false;
                                      textFormInvalidMsg = 'Insufficient Gas for transaction.';
                                      return;
                                    }
                                  } else if (widget.currency.currencyName == 'AES'){
                                    // _createAndVerifyTrustTransfer(pr1, (double.parse(_quantityController.text) * 1e8).round());
                                    if (avaiEthBalanceForCalc < 420000000000000) {
                                      textFormValidate = false;
                                      textFormInvalidMsg = 'Insufficient Gas for transaction.';
                                      return;
                                    }
                                  }
                                  accept = value;
                                  textFormValidate = true;
                                } else {
                                  accept = value;
                                }
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
                          onPressed: accept ? () {
                            // test();
                            pr1 = new ProgressDialog(context, isDismissible: false);
                            pr1.style(message: 'Verifying Transaction...');
                            if (widget.currency.currencyName == 'BTC') {
                              _confirmAndTransfer(pr1, (double.parse(_quantityController.text) * 1e3 * 1e3 * 1e2).round());
                            } else if (widget.currency.currencyName == 'ETH') {
                              _confirmAndTransfer(pr1, (double.parse(_quantityController.text) * 1e3 * 1e3 * 1e3 * 1e3 * 1e3 * 1e3).round());
                            } else if (widget.currency.currencyName == 'USDT') {
                              _confirmAndTransfer(pr1, (double.parse(_quantityController.text) * 1e3 * 1e3).round());
                            } else if (widget.currency.currencyName == 'AES') {
                              _confirmAndTransfer(pr1, (double.parse(_quantityController.text) * 1e3 * 1e3 * 1e2).round());
                            }
                            
                          } : null,
                          child: Text(
                            'Confirm Transfer',
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