import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'model/currency.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

class UserAddress {

  final String ethAddress;
  final String btcAddress;

  UserAddress({this.ethAddress, this.btcAddress});

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      ethAddress: json['ethAddress'],
      btcAddress: json['btcAddress'],
    );
  }
}

class WalletDepositPage extends StatefulWidget {

  final Currency currency;

  WalletDepositPage({Key key, @required this.currency}) : super(key: key);

  @override
  _WalletDepositPageState createState() => _WalletDepositPageState();
}

class _WalletDepositPageState extends State<WalletDepositPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserAddress myUserAddress = UserAddress(ethAddress: '', btcAddress: '');

  ProgressDialog pr1, pr2;

  Future<void> _getUserAddress(ProgressDialog pd) async{
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        var queryParameters = {
          'uuid': user.uid,
        };
        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/getUserAddress', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              print(contents.toString());
              setState(() {
                myUserAddress = UserAddress.fromJson(contents);
                print(myUserAddress.ethAddress);
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

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      pr1 = new ProgressDialog(context, isDismissible: false);
      pr1.style(message: 'Getting User Information');
      _getUserAddress(pr1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         backgroundColor: Color(0xFFFAFAFA),
         appBar: PreferredSize(
           preferredSize: Size.fromHeight(50.0),
           child: AppBar(elevation: 0.0,),
         ),
         body: Container(
           color: Colors.white,
           padding: EdgeInsets.only(left: 20.0, right: 20.0),
           child: Column(
             children: <Widget>[
               Container(
                 width: MediaQuery.of(context).size.width,
                 child: Text(
                   'Deposit',
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
                 margin: EdgeInsets.only(top: 15.0),
                 height: 300.0,
                 width: MediaQuery.of(context).size.width,
                 color: Color(0xFFf7f6fb),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                     QrImage(
                       data: widget.currency.currencyName == 'BTC' ? myUserAddress.btcAddress.toString() : myUserAddress.ethAddress.toString(),
                       version: 4,
                       size: 165.0,
                     ),
                     Container(
                       margin: EdgeInsets.all(5.0),
                       child: Text(
                         'Currency Address',
                         style: TextStyle(color: Colors.grey),
                       ),
                     ),
                     Container(
                       margin: EdgeInsets.all(5.0),
                       padding: EdgeInsets.only(left: 15.0, right: 15.0),
                       width: MediaQuery.of(context).size.width,
                       child: Text(
                         widget.currency.currencyName == 'BTC' ? myUserAddress.btcAddress.toString() : myUserAddress.ethAddress.toString(),
                         style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                         textAlign: TextAlign.center,
                       ),
                     ),
                     Container(
                       margin: EdgeInsets.all(0.0),
                       child: RaisedButton(
                         color: Colors.blue,
                         onPressed: () {
                            Clipboard.setData(new ClipboardData(text: widget.currency.currencyName == 'BTC' ? myUserAddress.btcAddress : myUserAddress.ethAddress));
                            Fluttertoast.showToast(
                                msg: "Copied to clipboard",
                            );
                         },
                         child: Text(
                           "Copy",
                           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
               Container(
                 margin: EdgeInsets.only(top: 20.0),
                 child: Text(
                   'Do not recharge any of the above addresses for non-' + 'BTC' + ', otherwise the assets will not be recovered.\nAfter you recharge to the above address, you need confirmation from the entire network node. Can be confirmed after 6 network confirmation.\nYour replenishment address will not change frequently, you can replenish; If there is any change, we try to notify you through the website announcement or mail.',
                   style: TextStyle(color: Colors.grey),
                 ),
               )
             ],
           ),
         ),
       ),
    );
  }
}