import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'model/currency.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'performance_widget.dart';
import 'assets_widget.dart';
import 'model/crypto_address.dart';
import 'model/crypto_current_balance.dart';

import 'dart:io';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

 
class PropertyWidget extends StatefulWidget {
  @override
  _MyPropertyWidgetState createState() => _MyPropertyWidgetState();
}


class _MyPropertyWidgetState extends State<PropertyWidget> {

  final RefreshController _refreshController = RefreshController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProgressDialog pr1, pr2;

  final List<Currency> _currencyList = [
    Currency("AES", 0.00, 0.00, "assets/aessignatum.png", 0.000000),
    Currency("BTC", 0.00, 0.00, "assets/bitcoin.png", 0.000000),
    Currency("ETH", 0.00, 0.00, "assets/ethereum.png", 0.000000),
    Currency("USDT", 0.00, 0.00, "assets/tether.png", 0.000000),
  ];

  CryptoCurrentBalance myCryptoCurrentBalance = CryptoCurrentBalance(btcBalance: "0.000000", ethBalance: "0.000000", usdtBalance: "0.000000", aesBalance: "0.000000",
                                                                    btcCurrentPrice: "0.00", ethCurrentPrice: "0.00", usdtCurrentPrice: "0.00", aesCurrentPrice: "0.00",
                                                                    btcPercentChange: "0.00", ethPercentChange: "0.00", usdtPercentChange: "0.00", aesPercentChange: "0.00",
                                                                    btcToUsdt: "0.000000", ethToUsdt: "0.000000", usdtToUsdt: "0.000000", aesToUsdt: "0.000000", totalAssetInUsdt: "0.000000",
                                                                    totalAesBalance: "0.000000", totalBtcBalance: "0.000000", totalUsdtBalance: "0.000000", totalEthBalance: "0.000000");

  _request() async {
    // Generate new address (btc) 
    new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/webApi/api/v1/test'))
      .then((HttpClientRequest request) => request.close())
      .then((HttpClientResponse response) {
        response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
          print(contents.toString());
          print(CryptoAddress.fromJson(contents).privateKey);
        });
      });
  }

  Future<void> _requestUserDataThenCheckBalance(ProgressDialog pd) async {
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        var queryParameters = {
          'uuid': user.uid,
        };
        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/updateUserBalanceInWallet', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              setState(() {
                myCryptoCurrentBalance = CryptoCurrentBalance.fromJson(contents);
                _currencyList[0].currencyCurrentValue = double.parse(myCryptoCurrentBalance.aesCurrentPrice);
                _currencyList[0].currencyQuoteChange = double.parse(myCryptoCurrentBalance.aesPercentChange);
                _currencyList[0].equalityToUsdt = double.parse(myCryptoCurrentBalance.aesToUsdt);
                _currencyList[0].currencyBalance = (double.parse(myCryptoCurrentBalance.aesBalance) / 1e8).toStringAsFixed(8);
                _currencyList[0].equalityToUsdtTotal = double.parse(myCryptoCurrentBalance.totalAesToUsdt);
                _currencyList[0].currencyBalanceTotal = (double.parse(myCryptoCurrentBalance.totalAesBalance) / 1e8).toStringAsFixed(8);
                _currencyList[1].currencyCurrentValue = double.parse(myCryptoCurrentBalance.btcCurrentPrice);
                _currencyList[1].currencyQuoteChange = double.parse(myCryptoCurrentBalance.btcPercentChange);
                _currencyList[1].equalityToUsdt = double.parse(myCryptoCurrentBalance.btcToUsdt);
                _currencyList[1].currencyBalance = (double.parse(myCryptoCurrentBalance.btcBalance) / 100000000).toStringAsFixed(8);
                _currencyList[1].equalityToUsdtTotal = double.parse(myCryptoCurrentBalance.totalBtcToUsdt);
                _currencyList[1].currencyBalanceTotal = (double.parse(myCryptoCurrentBalance.totalBtcBalance) / 100000000).toStringAsFixed(8);
                _currencyList[2].currencyCurrentValue = double.parse(myCryptoCurrentBalance.ethCurrentPrice);
                _currencyList[2].currencyQuoteChange = double.parse(myCryptoCurrentBalance.ethPercentChange);
                _currencyList[2].equalityToUsdt = double.parse(myCryptoCurrentBalance.ethToUsdt);
                _currencyList[2].currencyBalance = (double.parse(myCryptoCurrentBalance.ethBalance) / 1e18).toStringAsFixed(10);
                _currencyList[2].equalityToUsdtTotal = double.parse(myCryptoCurrentBalance.totalEthToUsdt);
                _currencyList[2].currencyBalanceTotal = (double.parse(myCryptoCurrentBalance.totalEthBalance) / 1e18).toStringAsFixed(10);
                _currencyList[3].currencyCurrentValue = double.parse(myCryptoCurrentBalance.usdtCurrentPrice);
                _currencyList[3].currencyQuoteChange = double.parse(myCryptoCurrentBalance.usdtPercentChange);
                _currencyList[3].equalityToUsdt = double.parse(myCryptoCurrentBalance.usdtToUsdt);
                _currencyList[3].currencyBalance = (double.parse(myCryptoCurrentBalance.usdtBalance) / 1000000).toStringAsFixed(6);
                _currencyList[3].equalityToUsdtTotal = double.parse(myCryptoCurrentBalance.totalUsdtToUsdt);
                _currencyList[3].currencyBalanceTotal = (double.parse(myCryptoCurrentBalance.totalUsdtBalance) / 1000000).toStringAsFixed(6);
                pd.dismiss();
              });

              
              
              print('btcBalance: ' + (double.parse(myCryptoCurrentBalance.btcBalance) / 100000000).toString());
              print('ethBalance: ' + (double.parse(myCryptoCurrentBalance.ethBalance) / 1e18).toString());
              print('aesBalance: ' + (double.parse(myCryptoCurrentBalance.aesBalance) / 1e8).toString());
              print('usdtBalance: ' + (double.parse(myCryptoCurrentBalance.usdtBalance) / 1000000).toString());
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

  Widget _buildRow(Currency currency, String myWalletAmount) {
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
                  MaterialPageRoute(builder: (context) => AssetsPage(currency: currency)),
                );
              },
              child: Container(
                padding: EdgeInsets.only(left: 15.0, right: 10.0, top: 10.0, bottom: 10.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                        flex: 4,
                        child: Row(
                          children: <Widget>[
                            // Currency Logo Image
                            Image(image: AssetImage(currency.currencyLogoUrl), width: 25.0,),
                            Container(
                              width:70.0,
                              margin: EdgeInsets.only(left: 20.0),
                              child: Column(
                                children: <Widget>[
                                  //Currency Name
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(currency.currencyName, textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                  // Currency current value
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("\$" + currency.currencyCurrentValue.toStringAsFixed(2), style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.start)
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 6,
                        child: Column(
                          children: <Widget>[
                            //Currency Name
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(myWalletAmount, textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                            // Currency current value
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(currency.equalityToUsdt.toStringAsFixed(6) + ' USDT', style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.start)
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 70.0,
                        height: 30.0,
                        color: currency.currencyQuoteChange < 0 ? Colors.red : Colors.green,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            currency.currencyQuoteChange < 0 ? currency.currencyQuoteChange.toStringAsFixed(2) + "%" : "+" + currency.currencyQuoteChange.toStringAsFixed(2) + "%",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        )
                      )
                  ],
                ),
              ),
            ),
          ),
          _currencyList.indexOf(currency) != _currencyList.length - 1 ? Divider(
            color: Colors.grey,
            thickness: 0.3,
            height: 0.0,
          ) : Container(padding: EdgeInsets.only(top: 0.0))
        ],
      )
    );
    
  }
  
  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration(milliseconds: 300), () {
      pr2 = new ProgressDialog(context, isDismissible: false);
      pr2.style(message: 'Retrieving latest data...');
      _requestUserDataThenCheckBalance(pr2);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    pr1 = new ProgressDialog(context, isDismissible: false);
    pr1.style(message: 'Retrieving latest data...');

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      header: MaterialClassicHeader(color: Colors.blue, backgroundColor: Colors.white,),
      onRefresh: () async {
        _refreshController.refreshCompleted();
        _requestUserDataThenCheckBalance(pr1);
        // await Future.delayed(Duration(seconds: 2));
        
      },
      child: CustomScrollView(
        slivers: <Widget>[
          // Assets Value card
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF4a7dbf),
                borderRadius: BorderRadius.all(const Radius.circular(10.0))
              ),
              height: 115.0,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 10.0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Total Assets Value",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      // backgroundColor: Colors.black,
                      color: Colors.white,
                      fontSize: 16.0
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 30.0),
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: double.parse(myCryptoCurrentBalance.totalAssetInUsdt).toStringAsFixed(6), style: TextStyle(fontSize: 32.0)),
                          TextSpan(text: ' USDT')
                        ],
                      ),
                    )
                  )
                ],
              )
            ),
          ),
          //  Performance and Notice
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              height: 50.0,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2.0,
                    child: FlatButton.icon(
                      onPressed: () {
                        SystemChrome.setSystemUIOverlayStyle(
                          SystemUiOverlayStyle(
                            statusBarColor: Color(0x33000116)
                          )
                        );
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => PerformancePage()),
                        );
                        
                        
                      },
                      color: Colors.transparent,
                      icon: Icon(Icons.insert_chart, color: Color(0xFF1d2f33), size: 26.0),
                      label: Text('Performance', style: TextStyle(color: Color(0xFF1d2f33), fontSize: 16.0)),
                    ),
                  ),
                  VerticalDivider(
                    width: 0.5,
                    color: Colors.grey,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.05,
                    child: FlatButton.icon(
                      onPressed: () {
                        _request();
                      },
                      color: Colors.transparent,
                      icon: Icon(Icons.notifications, color: Color(0xFF1d2f33), size: 26.0),
                      label: Text('Notice', style: TextStyle(color: Color(0xFF1d2f33), fontSize: 16.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // currency rate header
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 7.0),
              padding: EdgeInsets.only(left: 15.0, right: 10.0, top: 10.0, bottom: 0.0),
              // height: 350.0,
              child: 
              Column(
                children: <Widget>[
                  // Header
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 4,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 30.0,
                          // color: Colors.blue,
                          child: Text(
                            "Name", 
                            style: TextStyle(color: Colors.grey, fontSize: 12.0),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 6,
                          child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 30.0,
                          // color: Colors.green,
                          child: Text(
                            "Quantity Owned", 
                            style: TextStyle(color: Colors.grey, fontSize: 12.0)
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        // width: MediaQuery.of(context).size.width,
                        height: 30.0,
                        // color: Colors.yellow,
                        child: Text(
                          "Quote Change", 
                          style: TextStyle(color: Colors.grey, fontSize: 12.0)
                        ),
                      ),
                    ],
                  ),
                  
                  
                ],
              )
            ),
          ),
          // currency list
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildRow(_currencyList[0], (double.parse(myCryptoCurrentBalance.totalAesBalance) / 1e8).toStringAsFixed(8)),
                _buildRow(_currencyList[1], (double.parse(myCryptoCurrentBalance.totalBtcBalance) / 100000000).toStringAsFixed(8)),
                _buildRow(_currencyList[2], (double.parse(myCryptoCurrentBalance.totalEthBalance) / 1e18).toStringAsFixed(10)),
                _buildRow(_currencyList[3], (double.parse(myCryptoCurrentBalance.totalUsdtBalance) / 1000000).toStringAsFixed(6)),
              ]
            ),
          )
        ],
      ),
    );
  }
}