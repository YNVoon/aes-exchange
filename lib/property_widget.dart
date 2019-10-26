import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'model/currency.dart';

import 'performance_widget.dart';
import 'assets_widget.dart';
import 'model/crypto_address.dart';

import 'dart:io';
import 'dart:convert';

 
class PropertyWidget extends StatefulWidget {
  @override
  _MyPropertyWidgetState createState() => _MyPropertyWidgetState();
}


class _MyPropertyWidgetState extends State<PropertyWidget> {
  final RefreshController _refreshController = RefreshController();

  final List<Currency> _currencyList = [
    Currency("AES", 4.15, 0.72, ""),
    Currency("BTC", 8094.74, -0.61, ""),
    Currency("ETH", 176.77, -3.09, ""),
    Currency("USDT", 1.00, -0.03, ""),
    // Currency("USDT", 1.00, -0.03, ""),
  ];

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

  Widget _buildRow(Currency currency) {
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
                  MaterialPageRoute(builder: (context) => AssetsPage(currency: currency,)),
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
                            Text("T", style: TextStyle(fontSize: 30.0)),
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
                                    child: Text("\$" + currency.currencyCurrentValue.toString(), style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.start)
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
                              child: Text('0.000000', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                            // Currency current value
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text('=0.00 AES', style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.start)
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
                            currency.currencyQuoteChange < 0 ? currency.currencyQuoteChange.toString() + "%" : "+" + currency.currencyQuoteChange.toString() + "%",
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
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      header: MaterialClassicHeader(color: Colors.blue, backgroundColor: Colors.white,),
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        _refreshController.refreshCompleted();
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
                          TextSpan(text: '0.00000 ', style: TextStyle(fontSize: 32.0)),
                          TextSpan(text: 'AES')
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
                _buildRow(_currencyList[0]),
                _buildRow(_currencyList[1]),
                _buildRow(_currencyList[2]),
                _buildRow(_currencyList[3]),
              ]
            ),
          )
        ],
      ),
    );
  }
}