import 'package:aes_exchange/model/currency.dart';
import 'package:aes_exchange/model/transfer_trust_fess_amount.dart';
import 'package:aes_exchange/utils/decimal_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:io';
import 'dart:convert';

class FlexibleProcessingFee {
  
  var aesProcessing;
  var aesBalance;
  var status;

  FlexibleProcessingFee({this.aesProcessing, this.aesBalance, this.status});

  factory FlexibleProcessingFee.fromJson(Map<String, dynamic> json) {
    return FlexibleProcessingFee(
      aesProcessing: json['aesProcessing'],
      aesBalance: json['aesBalance'],
      status: json['status'],
    );
  }
}

class WalletTransferPage extends StatefulWidget {
  final Currency currency;

  WalletTransferPage({Key key, @required this.currency}) : super(key: key);

  @override
  _WalletTransferPageState createState() => _WalletTransferPageState();
}

class _WalletTransferPageState extends State<WalletTransferPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool accept = false;
  bool textFormValidate = true;
  bool textFormValidate2 = true;
  String textFormInvalidMsg = '';
  String textFormInvalidMsg2 = '';

  final TextEditingController _quantityController = new TextEditingController();
  final TextEditingController _emailAddressController = new TextEditingController();
  String quantity;

  ProgressDialog pr1, pr2, pr3;

  TransferTrustFeesAndAmount myTransferTrustFeesAndAmount = TransferTrustFeesAndAmount(
    btcBalance: '0.00000000', ethBalance: '0.0000000000', aesBalance: '0.00000000', usdtBalance: '0.000000'
  );

  FlexibleProcessingFee myFlexibleProcessingFee = FlexibleProcessingFee(
    aesBalance: 0.00, status: '', aesProcessing:'0.00'
  );

  var avaiBalance = '0.00000000';
  var avaiBalanceForCalc;

  var queryParameters = <String, String>{};

  var actualAESProcessingFee = 0.00;

  var aesProcessingFeeInInt = 0;

  bool validateEmail(String value) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) 
      return false;
    else
      return true;
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

  Future<void> _requestAppropriateAvailableAmount(ProgressDialog pd) async {
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        queryParameters = {
          'uuid': user.uid
        };
        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/getAvailableBalanceFromWallet', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents){
              setState(() {
                myTransferTrustFeesAndAmount = TransferTrustFeesAndAmount.fromJson(contents);
                if (widget.currency.currencyName == 'BTC') {
                  avaiBalance = (int.parse(myTransferTrustFeesAndAmount.btcBalance) / 1e8).toStringAsFixed(8);
                  avaiBalanceForCalc = int.parse(myTransferTrustFeesAndAmount.btcBalance);
                } else if (widget.currency.currencyName == 'ETH') {
                  avaiBalance = (int.parse(myTransferTrustFeesAndAmount.ethBalance) / 1e18).toStringAsFixed(10);
                  avaiBalanceForCalc = int.parse(myTransferTrustFeesAndAmount.ethBalance);
                } else if (widget.currency.currencyName == 'USDT') {
                  avaiBalance = (int.parse(myTransferTrustFeesAndAmount.usdtBalance) / 1e6).toStringAsFixed(6);
                  avaiBalanceForCalc = int.parse(myTransferTrustFeesAndAmount.usdtBalance);
                } else if (widget.currency.currencyName == 'AES') {
                  avaiBalance = (int.parse(myTransferTrustFeesAndAmount.aesBalance) / 1e8).toStringAsFixed(8);
                  avaiBalanceForCalc = int.parse(myTransferTrustFeesAndAmount.aesBalance);
                }
                pd.dismiss();
              });
            });
          });
      }
    } catch (e) { 
      print(e.message);
    }
  }

  Future<void> _getProcessingFee(ProgressDialog pd, String amountToSend, String receiverEmail) async {
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        if (widget.currency.currencyName == 'BTC') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'btc',
            'amountToProcess': amountToSend,
            'receiverEmail': receiverEmail
          };
        } else if (widget.currency.currencyName == 'ETH') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'eth',
            'amountToProcess': amountToSend,
            'receiverEmail': receiverEmail
          };
        } else if (widget.currency.currencyName == 'USDT') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'usdt',
            'amountToProcess': amountToSend,
            'receiverEmail': receiverEmail
          };
        } else if (widget.currency.currencyName == 'AES') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'aes',
            'amountToProcess': amountToSend,
            'receiverEmail': receiverEmail
          };
        } 

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/updateProcessingFee', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              setState(() {
                pd.dismiss();
                print(contents.toString());
                myFlexibleProcessingFee = FlexibleProcessingFee.fromJson(contents);
                if (myFlexibleProcessingFee.status == 'No register email found') {
                  textFormInvalidMsg2 = myFlexibleProcessingFee.status;
                  textFormValidate2 = false;
                  accept = false;
                  myFlexibleProcessingFee.aesProcessing = '0.00000000';
                } else if (myFlexibleProcessingFee.status == "You can't transfer to your own account"){
                  textFormInvalidMsg2 = myFlexibleProcessingFee.status;
                  textFormValidate2 = false;
                  accept = false;
                  myFlexibleProcessingFee.aesProcessing = '0.00000000';
                } else {
                  if (widget.currency.currencyName == 'AES') {
                    var aesProcessingFeeCalc = double.parse(myFlexibleProcessingFee.aesProcessing) * 1e3 * 1e3 * 1e2;
                    aesProcessingFeeInInt = int.parse(aesProcessingFeeCalc.toStringAsFixed(0));
                    var inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e2;
                    inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsPrecision(12));
                    // Make sure aesprocessingfee plus aes amount to send wont greater than their balance fund in wallet
                    if ((aesProcessingFeeInInt + inputQuantityInDouble) > myFlexibleProcessingFee.aesBalance) {
                      print('testing ' + (aesProcessingFeeInInt + inputQuantityInDouble).toString());
                      _showMaterialDialogForError('Insufficient fund to transfer', 'dismissDialog');
                      accept = false;
                    }
                  } else {
                    var aesProcessingFeeCalc = double.parse(myFlexibleProcessingFee.aesProcessing) * 1e3 * 1e3 * 1e2;
                    aesProcessingFeeInInt = int.parse(aesProcessingFeeCalc.toStringAsFixed(0));
                    print(aesProcessingFeeInInt.toString());
                    if (myFlexibleProcessingFee.aesBalance < aesProcessingFeeInInt) {
                      _showMaterialDialogForError('Insufficient processing fee', 'dismissDialog');
                      accept = false;
                    }
                  }
                  
                }
              });
            });
          });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _transferFund(ProgressDialog pd, String amountToTransfer, String processingFee, String receiverEmail) async {
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        if (widget.currency.currencyName == 'BTC') {
          queryParameters = {
            'uuid': user.uid,
            'amountToTransfer': amountToTransfer,
            'processingFee': processingFee,
            'receiverEmail': receiverEmail,
            'typeOfCurrency': 'btc'
          };
        } else if (widget.currency.currencyName == 'ETH') {
          queryParameters = {
            'uuid': user.uid,
            'amountToTransfer': amountToTransfer,
            'processingFee': processingFee,
            'receiverEmail': receiverEmail,
            'typeOfCurrency': 'eth'
          };
        } else if (widget.currency.currencyName == 'USDT') {
          queryParameters = {
            'uuid': user.uid,
            'amountToTransfer': amountToTransfer,
            'processingFee': processingFee,
            'receiverEmail': receiverEmail,
            'typeOfCurrency': 'usdt'
          };
        } else if (widget.currency.currencyName == 'AES') {
          queryParameters = {
            'uuid': user.uid,
            'amountToTransfer': amountToTransfer,
            'processingFee': processingFee,
            'receiverEmail': receiverEmail,
            'typeOfCurrency': 'aes'
          };
        }

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/transferBalanceToOtherAccount', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              print(contents.toString());
              pd.dismiss();
              _showMaterialDialogForError('Successful Transaction', 'navigate');
            });
          });
      }
    } catch (e) {
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
                     'Transfer',
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
                  margin: EdgeInsets.only(top: 25.0, bottom: 15.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Other accounts',
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                    textAlign: TextAlign.start,
                  ),
                ),
                TextFormField(
                  enabled: !accept,
                  onFieldSubmitted: (term) {

                  },
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailAddressController,
                  decoration: InputDecoration(
                    errorText: textFormValidate2 ? null : textFormInvalidMsg2,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFe5e5e7))
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                    ),
                    hintText: "Please enter recipient's email address",
                    hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),
                    border: OutlineInputBorder(),
                    
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25.0, bottom: 15.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Quantity Transfer',
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                    textAlign: TextAlign.start,
                  ),
                ),
                TextFormField(
                  enabled: !accept,
                  onFieldSubmitted: (term) {

                  },
                  inputFormatters: [DecimalTextInputFormatter(decimalRange: 10)],
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
                  margin: EdgeInsets.only(bottom: 12.0, top: 20.0),
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
                    myFlexibleProcessingFee.aesProcessing + ' AES',
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
                //        "Miner's Fee " + "0.000400 BTC",
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
                //         'Transfer Amount',
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
                              // accept = value; 
                              var inputQuantityInDouble;

                              if (_quantityController.text.isNotEmpty) {
                                if (widget.currency.currencyName == 'BTC') {
                                  inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e2;
                                  inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsPrecision(12));
                                } else if (widget.currency.currencyName == 'ETH'){
                                  inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e3 * 1e3 * 1e3 * 1e3;
                                  inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsPrecision(12));
                                } else if (widget.currency.currencyName == 'USDT'){
                                  inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3;
                                  inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsPrecision(12));
                                } else if (widget.currency.currencyName == 'AES'){
                                  inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e2;
                                  inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsPrecision(12));
                                }
                              }

                              if (_emailAddressController.text.isNotEmpty) {
                                if (!validateEmail(_emailAddressController.text)) {
                                  textFormValidate2 = false;
                                  textFormInvalidMsg2 = 'Invalid email address.';
                                } else {
                                  textFormValidate2 = true;
                                }
                              } else if (_emailAddressController.text.isEmpty) {
                                textFormValidate2 = false;
                                textFormInvalidMsg2 = 'Please insert an email address.';
                              }

                              if (_quantityController.text.isEmpty) {
                                textFormValidate = false;
                                textFormInvalidMsg = 'Please insert minimum amount.';
                              } else if (inputQuantityInDouble <= 0){
                                textFormValidate = false;
                                textFormInvalidMsg = 'Insufficient Fund to transfer.';
                              } else if (inputQuantityInDouble > avaiBalanceForCalc){
                                print(inputQuantityInDouble);
                                print(avaiBalanceForCalc);
                                textFormValidate = false;
                                textFormInvalidMsg = 'Insufficient Fund.';
                              } else {
                                textFormValidate = true;
                                pr1 = new ProgressDialog(context, isDismissible: false);
                                pr1.style(message: 'Verifying Transaction...');

                                if (textFormValidate && textFormValidate2) {
                                  if (value) {
                                    // get processing fee
                                    accept = value;
                                    print(inputQuantityInDouble);
                                    _getProcessingFee(pr1, inputQuantityInDouble.toString(), _emailAddressController.text);
                                    
                                  } else {
                                    accept = value;
                                  }
                                }
                              }
                            });
                          },
                        ),
                        Container(
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 15.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: accept ? () {
                      var inputQuantityInDouble;
                      if (widget.currency.currencyName == 'BTC') {
                        inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e2;
                        inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsPrecision(12));
                      } else if (widget.currency.currencyName == 'ETH'){
                        inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e3 * 1e3 * 1e3 * 1e3;
                        inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsPrecision(12));
                      } else if (widget.currency.currencyName == 'USDT'){
                        inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3;
                        inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsPrecision(12));
                      } else if (widget.currency.currencyName == 'AES'){
                        inputQuantityInDouble = double.parse(_quantityController.text) * 1e3 * 1e3 * 1e2;
                        inputQuantityInDouble = num.parse(inputQuantityInDouble.toStringAsPrecision(12));
                      }
                      print('processingFee ' + aesProcessingFeeInInt.toString());
                      print('amountToProcess ' + inputQuantityInDouble.toString());
                      pr3 = new ProgressDialog(context, isDismissible: false);
                      pr3.style(message: 'Creating Transaction...');
                      _transferFund(pr3, inputQuantityInDouble.toString(), aesProcessingFeeInInt.toString(), _emailAddressController.text);
                    } : null,
                    child: Text(
                      'Transfer',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
               ],
             ),
           ),
         ),
       ),
    );
  }
}