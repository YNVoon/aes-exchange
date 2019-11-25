import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'model/crypto_trust_balance.dart';
import 'model/trust_currency.dart';

import 'total_trust_assets_widget.dart';

import 'dart:io';
import 'dart:convert';

import 'package:aes_exchange/utils/app_localizations.dart';
 
class TrustWidget extends StatefulWidget {
  @override
  _MyTrustWidgetState createState() => _MyTrustWidgetState();
}

class _MyTrustWidgetState extends State<TrustWidget> {

  final RefreshController _refreshController = RefreshController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProgressDialog pr1, pr2;

  final List<TrustCurrency> _currencyList = [
    TrustCurrency("AES", 0.00, "0.00000000", "assets/aessignatum.png", 0.000000),
    TrustCurrency("BTC", 0.00, "0.00000000", "assets/bitcoin.png", 0.000000),
    TrustCurrency("ETH", 0.00, "0.0000000000", "assets/ethereum.png", 0.000000),
    TrustCurrency("USDT", 0.00, "0.000000", "assets/tether.png", 0.000000),
  ];

  CryptoTrustBalance myCryptoTrustBalance = CryptoTrustBalance(
    btcTrustBalance: "0.00000000",
    ethTrustBalance: "0.0000000000",
    usdtTrustBalance: "0.000000",
    aesTrustBalance: "0.00000000",
    btcCurrentPrice: "0.00",
    ethCurrentPrice: "0.00",
    usdtCurrentPrice: "0.00",
    aesCurrentPrice: "0.00",
    btcTrustToUsdt: "0.000000",
    ethTrustToUsdt: "0.000000",
    usdtTrustToUsdt: "0.000000",
    aesTrustToUsdt: "0.000000",
    totalAssetInUsdt: "0.000000"
  );

  Future<void> _requestUserDataThenCheckTrustBalance(ProgressDialog pd) async {
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        var queryParameters = {
          'uuid' : user.uid
        };
        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/checkTrustBalance', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              setState(() {
               myCryptoTrustBalance = CryptoTrustBalance.fromJson(contents);
               _currencyList[0].currencyCurrentValue = double.parse(myCryptoTrustBalance.aesCurrentPrice);
               _currencyList[0].equalityToUsdt = double.parse(myCryptoTrustBalance.aesTrustToUsdt);
               _currencyList[0].currencyBalance = (double.parse(myCryptoTrustBalance.aesTrustBalance) / 1e8).toStringAsFixed(8);
               _currencyList[1].currencyCurrentValue = double.parse(myCryptoTrustBalance.btcCurrentPrice);
               _currencyList[1].equalityToUsdt = double.parse(myCryptoTrustBalance.btcTrustToUsdt);
               _currencyList[1].currencyBalance = (double.parse(myCryptoTrustBalance.btcTrustBalance) / 1e8).toStringAsFixed(8);
               _currencyList[2].currencyCurrentValue = double.parse(myCryptoTrustBalance.ethCurrentPrice);
               _currencyList[2].equalityToUsdt = double.parse(myCryptoTrustBalance.ethTrustToUsdt);
               _currencyList[2].currencyBalance = (double.parse(myCryptoTrustBalance.ethTrustBalance) / 1e18).toStringAsFixed(10);
               _currencyList[3].currencyCurrentValue = double.parse(myCryptoTrustBalance.usdtCurrentPrice);
               _currencyList[3].equalityToUsdt = double.parse(myCryptoTrustBalance.usdtTrustToUsdt);
               _currencyList[3].currencyBalance = (double.parse(myCryptoTrustBalance.usdtTrustBalance) / 1e6).toStringAsFixed(6);    
              });
              pd.dismiss();
              print(_currencyList[2].currencyBalance);
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

  Widget _buildRow(TrustCurrency currency, String myTrustAmount) {
    return Container(
      // color: Colors.white,
      // padding: EdgeInsets.only(left: 15.0, right: 10.0),
      child: Column(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => TotalTrustAssetPage(currency: currency,)),
                );
              },
              child: Container(
                padding: EdgeInsets.only(left: 15.0, right: 10.0, top: 10.0, bottom: 10.0),
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        // Currency Logo Image
                        Image(image: AssetImage(currency.currencyLogoUrl), width: 25.0,),
                        Container(
                          width: 70.0,
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
                    Spacer(),
                    Column(
                      children: <Widget>[
                        //Currency Name
                        Container(
                          width: 200.0,
                          child: Text(myTrustAmount, textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold), ),
                        ),
                        // Currency current value
                        Container(
                          width: 200.0,
                          child: Text(currency.equalityToUsdt.toStringAsFixed(6) + ' USDT', style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.end)
                        )
                        
                      ],
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
          
          Divider(
            color: _currencyList.indexOf(currency) == _currencyList.length - 1 ? Colors.white : Colors.grey,
            thickness: 0.3,
            height: 0.0,
          )
        ],
      ),
    );
  }

  @override
  void initState() { 
    super.initState();
    Future.delayed(Duration.zero, () {
      pr2 = new ProgressDialog(context, isDismissible: false);
      pr2.style(message: AppLocalizations.of(context).translate('retrieving_latest_data'),);
      _requestUserDataThenCheckTrustBalance(pr2);
    });
  }

  @override
  Widget build(BuildContext context) {
    pr1 = new ProgressDialog(context, isDismissible: false);
    pr1.style(message: AppLocalizations.of(context).translate('retrieving_latest_data'),);

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      header: MaterialClassicHeader(color: Colors.blue, backgroundColor: Colors.white,),
      onRefresh: () async {
        _refreshController.refreshCompleted();
        _requestUserDataThenCheckTrustBalance(pr1);
      },
      child: CustomScrollView(
        slivers: <Widget>[
          // Assets Value card
          SliverToBoxAdapter(
            child: Column (
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF282b62),
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
                        AppLocalizations.of(context).translate('trust_assets_value'),
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
                              TextSpan(text: double.parse(myCryptoTrustBalance.totalAssetInUsdt).toStringAsFixed(6), style: TextStyle(fontSize: 28.0)),
                              TextSpan(text: '  USDT')
                            ],
                          ),
                        )
                      )
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   margin: EdgeInsets.only(top: 10.0),
                      //   child: RichText(
                      //     textAlign: TextAlign.start,
                      //     text: TextSpan(
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 16.0,
                      //       ),
                      //       children: <TextSpan>[
                      //         TextSpan(text: '= '),
                      //         TextSpan(text: double.parse(myCryptoTrustBalance.totalAssetInUsdt).toStringAsFixed(6), style: TextStyle(fontSize: 28.0)),
                      //         TextSpan(text: '  USDT')
                      //       ],
                      //     ),
                      //   )
                      // )
                    ],
                  )
                ),
                Container(
                  // color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 12.0, bottom: 15.0),
                  margin: EdgeInsets.only(top: 15.0),
                  child: Text(
                    AppLocalizations.of(context).translate('trust_assets_list'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    textAlign: TextAlign.start,
                  ),
                )
              ],
            )
          ),
          // currency list
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildRow(_currencyList[0], (double.parse(myCryptoTrustBalance.aesTrustBalance) / 1e8).toStringAsFixed(8)),
                _buildRow(_currencyList[1], (double.parse(myCryptoTrustBalance.btcTrustBalance) / 1e8).toStringAsFixed(8)),
                _buildRow(_currencyList[2], (double.parse(myCryptoTrustBalance.ethTrustBalance) / 1e18).toStringAsFixed(10)),
                _buildRow(_currencyList[3], (double.parse(myCryptoTrustBalance.usdtTrustBalance) / 1000000).toStringAsFixed(6)),
              ]
            ),
          )
        ],
      ),
    );
  }
}