import 'package:aes_exchange/model/currency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:io';
import 'dart:convert';
import 'utils/decimal_text_input_formatter.dart';

import 'package:pinput/pin_put/pin_put.dart';

import 'package:aes_exchange/utils/app_localizations.dart';

// import 'package:pinput/pin_put/pin_put.dart';

class ProcessingRate {
  var availableBalance;
  var aesCurrentPrice;
  var btcCurrentPrice;
  var ethCurrentPrice;
  var usdtCurrentPrice;
  var processingRate;
  var aesBalance;
  String userPasscode;

  ProcessingRate({this.userPasscode, this.aesBalance, this.availableBalance, this.aesCurrentPrice, this.btcCurrentPrice, this.ethCurrentPrice, this.usdtCurrentPrice, this.processingRate});

  factory ProcessingRate.fromJson(Map<String, dynamic> json) {
    return ProcessingRate(
      availableBalance: json['availableBalance'],
      aesCurrentPrice: json['aesCurrentPrice'],
      btcCurrentPrice: json['btcCurrentPrice'],
      ethCurrentPrice: json['ethCurrentPrice'],
      usdtCurrentPrice: json['usdtCurrentPrice'],
      processingRate: json['processingRate'],
      aesBalance: json['aesBalance'],
      userPasscode: json['userPasscode']
    );
  }
}

class TransactionStatus {
  var status;

  TransactionStatus({this.status});

  factory TransactionStatus.fromJson(Map<String, dynamic> json) {
    return TransactionStatus(
      status: json['status']
    );
  }
}

class SwapPage extends StatefulWidget {
  final Currency currency;

  SwapPage({Key key, @required this.currency}) : super(key: key);

  @override
  _SwapPageState createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var queryParameters = <String, String>{};

  ProgressDialog pr1, pr2;

  String dropdownValue = '';
  String dropdownValueFix = '';

  bool textFormValidate = true;
  bool textFormValidate2 = true;
  String textFormInvalidMsg = '';
  String textFormInvalidMsg2 = '';
  var handlingFee = 0.0;

  List<String> _myDropDown;
  List<String> _currentDropDown;

  final TextEditingController _fromConversionController = new TextEditingController();
  final TextEditingController _toConversionController = new TextEditingController();

  ProcessingRate myProcessingRate = ProcessingRate(aesBalance: 0.00, availableBalance: 0.00, btcCurrentPrice: 0.00, aesCurrentPrice: 0.00, ethCurrentPrice: 0.00, usdtCurrentPrice: 0.00, processingRate: 0.00);
  TransactionStatus myTransactionStatus = TransactionStatus(status: '');
  var afterConversionValue = 0.00;
  var extensionForCurrency = 'ETH';
  bool enableButton = false;

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
                child: Text(AppLocalizations.of(context).translate('ok'), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
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

  void _showMaterialDialog(var processingFeeDialog, var amountToTransferDialog, var amountSwapDialog) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
            content: Text(
              AppLocalizations.of(context).translate('confirm_to_swap'),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(AppLocalizations.of(context).translate('cancel'), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                onPressed: () {
                  Navigator.pop(context);
                  
                },
              ),
              FlatButton(
                child: Text(AppLocalizations.of(context).translate('ok'), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                onPressed: () {
                  Navigator.pop(context);
                  if (amountToTransferDialog  + processingFeeDialog > myProcessingRate.availableBalance) {
                    _showMaterialDialogForError(AppLocalizations.of(context).translate('insufficient_fund_or_processing_fee_to_swap'), 'dismissDialog');
                  } else {
                    // Init transfer here
                    pr1 = new ProgressDialog(context, isDismissible: false);
                    pr1.style(message: AppLocalizations.of(context).translate('swaping_currency'));
                    _confirmSwap(pr1, amountToTransferDialog.toString(), amountSwapDialog.toString(), processingFeeDialog.toString());
                  }
                  // if (widget.currency.currencyName != 'AES') {
                  //   if (amountToTransferDialog  + processingFeeDialog > myProcessingRate.availableBalance) {
                  //     _showMaterialDialogForError('Insufficient fund / processing fee to swap', 'dismissDialog');
                  //   } else {
                  //     // Init transfer here
                  //     pr1 = new ProgressDialog(context, isDismissible: false);
                  //     pr1.style(message: 'Swaping Currency');
                  //     _confirmSwap(pr1, amountToTransferDialog.toString(), amountSwapDialog.toString(), processingFeeDialog.toString());
                  //   }
                  // } else {
                  //   if (amountToTransferDialog + processingFeeDialog > myProcessingRate.aesBalance) {
                  //     _showMaterialDialogForError('Insufficient fund to swap', 'dismissDialog');
                  //   } else {
                  //     // Init transfer here
                  //     pr1 = new ProgressDialog(context, isDismissible: false);
                  //     pr1.style(message: 'Swaping Currency');
                  //     _confirmSwap(pr1, amountToTransferDialog.toString(), amountSwapDialog.toString(), processingFeeDialog.toString());
                  //   }
                  // }
                  
                },
              ),
              
            ],
          ),
        );
        
      }
    );
  }

  void _showPasscodeDialog (var processingFeeDialog, var amountToTransferDialog, var amountSwapDialog) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Please enter your passcode',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'You may check your default passcode at setting page.',
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                // height: 10.0,
                child: PinPut(
                  inputDecoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    contentPadding: const EdgeInsets.all(5.0),
                    counterStyle: TextStyle(height: double.minPositive,),
                    counterText: ""
                  ),
                  
                  actionButtonsEnabled: false,
                  isTextObscure: true,
                  fieldsCount: 6,
                  onSubmit: (String pin) {
                    if (pin != myProcessingRate.userPasscode) {
                      Navigator.pop(context);
                      _showMaterialDialogForError('Incorrect passcode', 'dismissDialog');
                    } else {
                      Navigator.pop(context);
                      if (widget.currency.currencyName != 'AES') {
                        if (amountToTransferDialog > myProcessingRate.availableBalance) {
                          _showMaterialDialogForError('Insufficient fund to swap', 'dismissDialog');
                        } else if (processingFeeDialog > myProcessingRate.aesBalance) {
                          _showMaterialDialogForError('Insufficient processing fee', 'dismissDialog');
                        } else {
                          // Init transfer here
                          pr1 = new ProgressDialog(context, isDismissible: false);
                          pr1.style(message: AppLocalizations.of(context).translate('swaping_currency'));
                          _confirmSwap(pr1, amountToTransferDialog.toString(), amountSwapDialog.toString(), processingFeeDialog.toString());
                        }
                      } else {
                        if (amountToTransferDialog + processingFeeDialog > myProcessingRate.aesBalance) {
                          _showMaterialDialogForError('Insufficient fund to swap', 'dismissDialog');
                        } else {
                          // Init transfer here
                          pr1 = new ProgressDialog(context, isDismissible: false);
                          pr1.style(message: AppLocalizations.of(context).translate('swaping_currency'));
                          _confirmSwap(pr1, amountToTransferDialog.toString(), amountSwapDialog.toString(), processingFeeDialog.toString());
                        }
                      }
                      
                      
                    }
                  },
                ),
              )
            ],
          )
        );
      }
    );
  }

  Future<void> _confirmSwap(ProgressDialog pd, String amountToTransfer, String amountAfterSwap, String processingFee) async {
    pd.show();
    try{
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        if (widget.currency.currencyName == 'BTC') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'btc',
            'toWhichCurrency': dropdownValue,
            'amountToTransfer': amountToTransfer,
            'amountAfterSwap': amountAfterSwap,
            'processingFee': processingFee,
            'availableBalance': myProcessingRate.availableBalance.toString(),
            'aesAvailableBalance': myProcessingRate.aesBalance.toString()
          };
        } else if (widget.currency.currencyName == 'ETH') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'eth',
            'toWhichCurrency': dropdownValue,
            'amountToTransfer': amountToTransfer,
            'amountAfterSwap': amountAfterSwap,
            'processingFee': processingFee,
            'availableBalance': myProcessingRate.availableBalance.toString(),
            'aesAvailableBalance': myProcessingRate.aesBalance.toString()
          };
        } else if (widget.currency.currencyName == 'USDT') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'usdt',
            'toWhichCurrency': dropdownValue,
            'amountToTransfer': amountToTransfer,
            'amountAfterSwap': amountAfterSwap,
            'processingFee': processingFee,
            'availableBalance': myProcessingRate.availableBalance.toString(),
            'aesAvailableBalance': myProcessingRate.aesBalance.toString()
          };
        } else if (widget.currency.currencyName == 'AES') {
          queryParameters = {
            'uuid': user.uid,
            'typeOfCurrency': 'aes',
            'toWhichCurrency': dropdownValue,
            'amountToTransfer': amountToTransfer,
            'amountAfterSwap': amountAfterSwap,
            'processingFee': processingFee,
            'availableBalance': myProcessingRate.availableBalance.toString(),
            'aesAvailableBalance': myProcessingRate.aesBalance.toString()
          };
        } 

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/swapFund', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              myTransactionStatus = TransactionStatus.fromJson(contents);
              pd.dismiss();
              if (myTransactionStatus.status == 'success') {
                _showMaterialDialogForError(AppLocalizations.of(context).translate('swap_successfully'), "navigate");
              } else {
                _showMaterialDialogForError(AppLocalizations.of(context).translate('transaction_failed'), "navigate");
              }
              print(contents.toString());
              
            });
          });

        
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getSwappingRate (ProgressDialog pd) async {
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        if (widget.currency.currencyName == 'BTC') {
          queryParameters = {
            'typeOfCurrency': 'btc',
            'uuid': user.uid
          };
        } else if (widget.currency.currencyName == 'ETH') {
          queryParameters = {
            'typeOfCurrency': 'eth',
            'uuid': user.uid
          };
        } else if (widget.currency.currencyName == 'USDT') {
          queryParameters = {
            'typeOfCurrency': 'usdt',
            'uuid': user.uid
          };
        } else if (widget.currency.currencyName == 'AES') {
          queryParameters = {
            'typeOfCurrency': 'aes',
            'uuid': user.uid
          };
        }

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/getExchangeAndAvailableAmount', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              print(contents.toString());
              setState(() {
                myProcessingRate = ProcessingRate.fromJson(contents);
                if (widget.currency.currencyName == 'BTC') {
                  if (dropdownValue == 'Ethereum') {
                    afterConversionValue = double.parse((myProcessingRate.btcCurrentPrice / myProcessingRate.ethCurrentPrice).toStringAsFixed(8));
                    extensionForCurrency = 'ETH';
                  } else if (dropdownValue == 'USDT') {
                    afterConversionValue = double.parse((myProcessingRate.btcCurrentPrice / myProcessingRate.usdtCurrentPrice).toStringAsFixed(6));
                    extensionForCurrency = 'USDT';
                  } else if (dropdownValue == 'AES') {
                    extensionForCurrency = 'AES';
                    afterConversionValue = double.parse((myProcessingRate.btcCurrentPrice / myProcessingRate.aesCurrentPrice).toStringAsFixed(8));
                  }
                } else if (widget.currency.currencyName == 'ETH') {
                  if (dropdownValue == 'Bitcoin') {
                    afterConversionValue = double.parse((myProcessingRate.ethCurrentPrice / myProcessingRate.btcCurrentPrice).toStringAsFixed(8));
                    extensionForCurrency = 'BTC';
                  } else if (dropdownValue == 'USDT') {
                    afterConversionValue = double.parse((myProcessingRate.ethCurrentPrice / myProcessingRate.usdtCurrentPrice).toStringAsFixed(6));
                    extensionForCurrency = 'USDT';
                  } else if (dropdownValue == 'AES') {
                    extensionForCurrency = 'AES';
                    afterConversionValue = double.parse((myProcessingRate.ethCurrentPrice / myProcessingRate.aesCurrentPrice).toStringAsFixed(8));
                  }
                } else if (widget.currency.currencyName == 'USDT') {
                  if (dropdownValue == 'Bitcoin') {
                    afterConversionValue = double.parse((myProcessingRate.usdtCurrentPrice / myProcessingRate.btcCurrentPrice).toStringAsFixed(8));
                    extensionForCurrency = 'BTC';
                  } else if (dropdownValue == 'Ethereum') {
                    afterConversionValue = double.parse((myProcessingRate.usdtCurrentPrice / myProcessingRate.ethCurrentPrice).toStringAsFixed(10));
                    extensionForCurrency = 'ETH';
                  } else if (dropdownValue == 'AES') {
                    extensionForCurrency = 'AES';
                    afterConversionValue = double.parse((myProcessingRate.usdtCurrentPrice / myProcessingRate.aesCurrentPrice).toStringAsFixed(8));
                  }
                } else if (widget.currency.currencyName == 'AES') {
                  if (dropdownValue == 'Bitcoin') {
                    afterConversionValue = double.parse((myProcessingRate.aesCurrentPrice / myProcessingRate.btcCurrentPrice).toStringAsFixed(8));
                    extensionForCurrency = 'BTC';
                  } else if (dropdownValue == 'Ethereum') {
                    afterConversionValue = double.parse((myProcessingRate.aesCurrentPrice / myProcessingRate.ethCurrentPrice).toStringAsFixed(10));
                    extensionForCurrency = 'ETH';
                  } else if (dropdownValue == 'USDT') {
                    extensionForCurrency = 'USDT';
                    afterConversionValue = double.parse((myProcessingRate.aesCurrentPrice / myProcessingRate.usdtCurrentPrice).toStringAsFixed(8));
                  }
                }
                pd.dismiss();
              });
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
    String valueToPlace;
    if (widget.currency.currencyName == 'BTC') {
      valueToPlace = 'Bitcoin';
      _myDropDown = ['Ethereum', 'USDT', 'AES'];
      dropdownValue = 'Ethereum';
    } else if (widget.currency.currencyName == 'ETH') {
      valueToPlace = 'Ethereum';
      _myDropDown = ['Bitcoin', 'USDT', 'AES'];
      dropdownValue = 'Bitcoin';
    } else if (widget.currency.currencyName == 'USDT') {
      valueToPlace = 'USDT';
      _myDropDown = ['Bitcoin', 'Ethereum', 'AES'];
      dropdownValue = 'Bitcoin';
    } else if (widget.currency.currencyName == 'AES') {
      valueToPlace = 'AES';
      _myDropDown = ['Bitcoin', 'Ethereum', 'USDT'];
      dropdownValue = 'Bitcoin';
    }
    _currentDropDown = [valueToPlace];
    dropdownValueFix = valueToPlace;
    Future.delayed(Duration.zero, () {
      pr2 = new ProgressDialog(context, isDismissible: false);
      pr2.style(message: AppLocalizations.of(context).translate('retrieving_latest_data'));
      _getSwappingRate(pr2);
      // _showPasscodeDialog();
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
             elevation: 1.0,
             centerTitle: true,
             title: Text(
               AppLocalizations.of(context).translate('swap'),
               style: Theme.of(context).textTheme.title
             ),
            ),
         ),
         body: Container(
           padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
           color: Color(0xFFf7f6fb),
           child: Column(
             children: <Widget>[
               Container(
                 padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 20.0, bottom: 20.0),
                //  color: Colors.white,
                 height: 230.0,
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.all(
                     Radius.circular(10.0)
                   ),
                   boxShadow: [BoxShadow(
                     color: Colors.grey,
                     blurRadius: 1.0
                   )]
                 ),
                 child: Column(
                   children: <Widget>[
                     Container(
                       width: MediaQuery.of(context).size.width,
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 120.0,
                            margin: EdgeInsets.only(left: 20.0, right: 10.0),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                // isExpanded: true,
                                value: dropdownValueFix,
                                // icon: Icon(Icons.arrow_downward),
                                // iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.black, fontSize: 16.0),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValueFix = newValue;
                                  });
                                },
                                items: _currentDropDown.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          Icon(Icons.swap_horiz, color: Colors.blue, size: 25.0,),
                          Container(
                            width: 120.0,
                            margin: EdgeInsets.only(left: 10.0, right: 20.0),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                value: dropdownValue,
                                // icon: Icon(Icons.arrow_downward),
                                // iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.black, fontSize: 16.0),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                    if (widget.currency.currencyName == 'BTC') {
                                      if (dropdownValue == 'Ethereum') {
                                        afterConversionValue = double.parse((myProcessingRate.btcCurrentPrice / myProcessingRate.ethCurrentPrice).toStringAsFixed(8));
                                        extensionForCurrency = 'ETH';
                                      } else if (dropdownValue == 'USDT') {
                                        afterConversionValue = double.parse((myProcessingRate.btcCurrentPrice / myProcessingRate.usdtCurrentPrice).toStringAsFixed(6));
                                        extensionForCurrency = 'USDT';
                                      } else if (dropdownValue == 'AES') {
                                        extensionForCurrency = 'AES';
                                        afterConversionValue = double.parse((myProcessingRate.btcCurrentPrice / myProcessingRate.aesCurrentPrice).toStringAsFixed(8));
                                      }
                                    } else if (widget.currency.currencyName == 'ETH') {
                                      if (dropdownValue == 'Bitcoin') {
                                        afterConversionValue = double.parse((myProcessingRate.ethCurrentPrice / myProcessingRate.btcCurrentPrice).toStringAsFixed(8));
                                        extensionForCurrency = 'BTC';
                                      } else if (dropdownValue == 'USDT') {
                                        afterConversionValue = double.parse((myProcessingRate.ethCurrentPrice / myProcessingRate.usdtCurrentPrice).toStringAsFixed(6));
                                        extensionForCurrency = 'USDT';
                                      } else if (dropdownValue == 'AES') {
                                        extensionForCurrency = 'AES';
                                        afterConversionValue = double.parse((myProcessingRate.ethCurrentPrice / myProcessingRate.aesCurrentPrice).toStringAsFixed(8));
                                      }
                                    } else if (widget.currency.currencyName == 'USDT') {
                                      if (dropdownValue == 'Bitcoin') {
                                        afterConversionValue = double.parse((myProcessingRate.usdtCurrentPrice / myProcessingRate.btcCurrentPrice).toStringAsFixed(8));
                                        extensionForCurrency = 'BTC';
                                      } else if (dropdownValue == 'Ethereum') {
                                        afterConversionValue = double.parse((myProcessingRate.usdtCurrentPrice / myProcessingRate.ethCurrentPrice).toStringAsFixed(10));
                                        extensionForCurrency = 'ETH';
                                      } else if (dropdownValue == 'AES') {
                                        extensionForCurrency = 'AES';
                                        afterConversionValue = double.parse((myProcessingRate.usdtCurrentPrice / myProcessingRate.aesCurrentPrice).toStringAsFixed(8));
                                      }
                                    } else if (widget.currency.currencyName == 'AES') {
                                      if (dropdownValue == 'Bitcoin') {
                                        afterConversionValue = double.parse((myProcessingRate.aesCurrentPrice / myProcessingRate.btcCurrentPrice).toStringAsFixed(8));
                                        extensionForCurrency = 'BTC';
                                      } else if (dropdownValue == 'Ethereum') {
                                        afterConversionValue = double.parse((myProcessingRate.aesCurrentPrice / myProcessingRate.ethCurrentPrice).toStringAsFixed(10));
                                        extensionForCurrency = 'ETH';
                                      } else if (dropdownValue == 'USDT') {
                                        extensionForCurrency = 'USDT';
                                        afterConversionValue = double.parse((myProcessingRate.aesCurrentPrice / myProcessingRate.usdtCurrentPrice).toStringAsFixed(8));
                                      }
                                    }
                                    print(_toConversionController.text);
                                    if (_toConversionController.text != '') {
                                      _toConversionController.text = (double.parse(_fromConversionController.text) * afterConversionValue).toStringAsFixed(10);
                                    }
                                  });
                                },
                                items: _myDropDown.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                     ),
                     Container(
                       width: MediaQuery.of(context).size.width,
                       margin: EdgeInsets.only(top: 5.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                           Container(
                             width: 120.0,
                             margin: EdgeInsets.only(left: 20.0, right: 10.0),
                             child: TextFormField(
                               controller: _fromConversionController,
                               inputFormatters: [DecimalTextInputFormatter(decimalRange: 12)],
                               onFieldSubmitted: (term) {

                               },
                               onChanged:(text) {
                                 print(_fromConversionController.text);
                                 
                                 if (_fromConversionController.text == '') {
                                   _toConversionController.text = '';
                                   setState(() {
                                    enableButton = false;
                                    handlingFee = 0.0;
                                   });
                                   
                                 } else {
                                   _toConversionController.text = (double.parse(_fromConversionController.text) * afterConversionValue).toStringAsFixed(10);
                                   setState(() {
                                     enableButton = true;
                                     handlingFee = (double.parse(_fromConversionController.text) * myProcessingRate.processingRate);
                                   });
                                  //  if (widget.currency.currencyName == 'BTC') {
                                  //     setState(() {
                                  //       handlingFee = double.parse(_fromConversionController.text) * myProcessingRate.processingRate;
                                  //     });
                                  //   } else if (widget.currency.currencyName == 'ETH') {
                                  //     setState(() {
                                  //       handlingFee = double.parse(((double.parse(_fromConversionController.text) * myProcessingRate.ethCurrentPrice / myProcessingRate.aesCurrentPrice) * myProcessingRate.processingRate).toStringAsFixed(8));
                                  //     });
                                  //   } else if (widget.currency.currencyName == 'USDT') {
                                  //     setState(() {
                                  //       handlingFee = double.parse(((double.parse(_fromConversionController.text) * myProcessingRate.usdtCurrentPrice / myProcessingRate.aesCurrentPrice) * myProcessingRate.processingRate).toStringAsFixed(8));
                                  //     });
                                  //   } else if (widget.currency.currencyName == 'AES') {
                                  //     setState(() {
                                  //       handlingFee = double.parse(((double.parse(_fromConversionController.text) * myProcessingRate.aesCurrentPrice / myProcessingRate.aesCurrentPrice) * myProcessingRate.processingRate).toStringAsFixed(8));
                                  //     });
                                  //   }
                                 }

                                 
                               },
                               keyboardType: TextInputType.numberWithOptions(decimal: true),
                               decoration: InputDecoration(
                                 errorText: textFormValidate ? null : textFormInvalidMsg,
                                 enabledBorder: UnderlineInputBorder(
                                   borderSide: BorderSide(color: Color(0xFFe5e5e7))
                                 ),
                                 focusedBorder: UnderlineInputBorder(
                                   borderSide: BorderSide(color: Colors.grey)
                                 ),
                                 hintText: AppLocalizations.of(context).translate('input_quantity'),
                                 hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey, fontWeight: FontWeight.w400),
                               ),
                             ),
                           ),
                           Icon(Icons.arrow_forward, color: Colors.blue, size: 25.0,),
                           Container(
                             width: 120.0,
                             margin: EdgeInsets.only(left: 10.0, right: 20.0),
                             child: TextFormField(
                               enabled: false,
                               controller: _toConversionController,
                               onFieldSubmitted: (term) {

                               },
                               keyboardType: TextInputType.numberWithOptions(decimal: true),
                               decoration: InputDecoration(
                                 
                                 errorText: textFormValidate2 ? null : textFormInvalidMsg2,
                                 enabledBorder: UnderlineInputBorder(
                                   borderSide: BorderSide(color: Color(0xFFe5e5e7))
                                 ),
                                 focusedBorder: UnderlineInputBorder(
                                   borderSide: BorderSide(color: Colors.grey)
                                 ),
                                 hintText: AppLocalizations.of(context).translate('exchange_quantity'),
                                 hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey, fontWeight: FontWeight.w400),
                               ),
                             ),
                           ),
                         ],
                       ),

                     ),
                     Spacer(),
                     Container(
                       margin: EdgeInsets.only(left: 20.0),
                       width: MediaQuery.of(context).size.width,
                       child: Text(
                         AppLocalizations.of(context).translate('convert_rate'),
                         textAlign: TextAlign.left,
                        ),
                     ),
                     Container(
                       margin: EdgeInsets.only(left: 20.0, top: 5.0),
                       width: MediaQuery.of(context).size.width,
                       child: Text(
                         '1 ' + widget.currency.currencyName + ' = ' + afterConversionValue.toString() + ' ' + extensionForCurrency,
                         textAlign: TextAlign.left,
                         style: TextStyle(fontSize: 16.0),
                        ),
                     ),
                     Container(
                       margin: EdgeInsets.only(left: 20.0, top: 5.0),
                       width: MediaQuery.of(context).size.width,
                       child: RichText(
                         text: TextSpan(
                           style: TextStyle(
                             color: Colors.black,
                             fontSize: 14.0
                           ),
                           children: <TextSpan>[
                             TextSpan(text: AppLocalizations.of(context).translate('handling_fee')),
                             TextSpan(text: handlingFee.toStringAsFixed(8) + " " + widget.currency.currencyName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))
                           ]
                           
                         ),
                       )
                     )
                     
                   ],
                 ),
                 
               ),
               Container(
                 margin: EdgeInsets.only(top: 10.0),
                 width: MediaQuery.of(context).size.width,
                 
                 child: RaisedButton(
                   shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                   color: Colors.blue,
                   onPressed: enableButton ? () {
                     var amountToSwapOutInInt, amountToSwapInInInt, handlingFeeToProcess;
                     if (widget.currency.currencyName == 'BTC') {
                       amountToSwapOutInInt = double.parse(_fromConversionController.text) * 1e3 * 1e3 * 1e2;
                       amountToSwapOutInInt = num.parse(amountToSwapOutInInt.toStringAsFixed(2));
                     } else if (widget.currency.currencyName == 'ETH') {
                      //  amountToSwapOutInInt = int.parse((double.parse(_fromConversionController.text) * 1e18).toStringAsFixed(0));
                       amountToSwapOutInInt = double.parse(_fromConversionController.text) * 1e3 * 1e3 * 1e3 * 1e3 * 1e3 * 1e3;
                       amountToSwapOutInInt = num.parse(amountToSwapOutInInt.toStringAsFixed(2));
                     } else if (widget.currency.currencyName == 'USDT') {
                       amountToSwapOutInInt = double.parse(_fromConversionController.text) * 1e3 * 1e3;
                       amountToSwapOutInInt = num.parse(amountToSwapOutInInt.toStringAsFixed(2));
                     } else if (widget.currency.currencyName == 'AES') {
                       amountToSwapOutInInt = double.parse(_fromConversionController.text) * 1e3 * 1e3 * 1e2;
                       amountToSwapOutInInt = num.parse(amountToSwapOutInInt.toStringAsFixed(2));
                     }

                     if (dropdownValue == 'Bitcoin') {
                       amountToSwapInInInt = double.parse(_toConversionController.text) * 1e3 * 1e3 * 1e2;
                       amountToSwapInInInt = num.parse(amountToSwapInInInt.toStringAsFixed(2));
                     } else if (dropdownValue == 'Ethereum') {
                       amountToSwapInInInt = double.parse(_toConversionController.text) * 1e3 * 1e3 * 1e3 * 1e3 * 1e3 * 1e3;
                       amountToSwapInInInt = num.parse(amountToSwapInInInt.toStringAsFixed(2));
                     } else if (dropdownValue == 'USDT') {
                       amountToSwapInInInt = double.parse(_toConversionController.text) * 1e3 * 1e3;
                       amountToSwapInInInt = num.parse(amountToSwapInInInt.toStringAsFixed(2));
                     } else if (dropdownValue == 'AES') {
                       amountToSwapInInInt = double.parse(_toConversionController.text) * 1e3 * 1e3 * 1e2;
                       amountToSwapInInInt = num.parse(amountToSwapInInInt.toStringAsFixed(2));
                     }

                     if (widget.currency.currencyName == 'BTC' || widget.currency.currencyName == 'AES') {
                       handlingFeeToProcess = handlingFee * 1e3 * 1e3 * 1e2;
                       handlingFeeToProcess = num.parse(handlingFeeToProcess.toStringAsFixed(2));
                     } else if (widget.currency.currencyName == 'USDT') {
                       handlingFeeToProcess = handlingFee * 1e3 * 1e3;
                       handlingFeeToProcess = num.parse(handlingFeeToProcess.toStringAsFixed(2));
                     } else if (widget.currency.currencyName == 'ETH') {
                       handlingFeeToProcess = handlingFee * 1e3 * 1e3 * 1e3 * 1e3 * 1e3 * 1e3;
                       handlingFeeToProcess = num.parse(handlingFeeToProcess.toStringAsFixed(2));
                     }
                     
                     _showMaterialDialog(handlingFeeToProcess, amountToSwapOutInInt, amountToSwapInInInt);
                    var testingNumber = myProcessingRate.availableBalance - amountToSwapOutInInt;
                     print('handlingFee ' + handlingFeeToProcess.toString());
                     print('amountToSwapOut ' + amountToSwapOutInInt.toString());
                     print('amountToSwapIn ' + amountToSwapInInInt.toString());
                     print('available balance ' + myProcessingRate.availableBalance.toString());
                     print('aes available balance ' + myProcessingRate.aesBalance.toString());
                     print('after ' + testingNumber.toString());

                   } : null,
                   child: Text(
                     AppLocalizations.of(context).translate('next_step'),
                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
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