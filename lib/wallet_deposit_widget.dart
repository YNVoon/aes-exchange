import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WalletDepositPage extends StatefulWidget {
  WalletDepositPage({Key key}) : super(key: key);

  @override
  _WalletDepositPageState createState() => _WalletDepositPageState();
}

class _WalletDepositPageState extends State<WalletDepositPage> {
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
                     Image(image: AssetImage('assets/bitcoin.png'), width: 25.0,),
                     Container(
                       margin: EdgeInsets.only(left: 10.0),
                       child: Text(
                         'BTC',
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
                       data: "123456789010",
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
                       child: Text(
                         '123456789010',
                         style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                       ),
                     ),
                     Container(
                       margin: EdgeInsets.all(0.0),
                       child: RaisedButton(
                         color: Colors.blue,
                         onPressed: () {
                           
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