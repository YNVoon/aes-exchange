import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'model/currency.dart';
 
class TrustWidget extends StatefulWidget {
  @override
  _MyTrustWidgetState createState() => _MyTrustWidgetState();
}

class _MyTrustWidgetState extends State<TrustWidget> {
  final RefreshController _refreshController = RefreshController();

  final List<Currency> _currencyList = [
    Currency("AES", 0.00, 0.00, "assets/aessignatum.png", 0.000000),
    Currency("BTC", 0.00, 0.00, "assets/bitcoin.jpg", 0.000000),
    Currency("ETH", 0.00, 0.00, "assets/ethereum.png", 0.000000),
    Currency("USDT", 0.00, 0.00, "assets/tether.png", 0.000000),
    // Currency("USDT", 1.00, -0.03, ""),
  ];

  Widget _buildRow(Currency currency) {
    return Container(
      // color: Colors.white,
      // padding: EdgeInsets.only(left: 15.0, right: 10.0),
      child: Column(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                print("Tapped");
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
                                child: Text("\$" + currency.currencyCurrentValue.toString(), style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.start)
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
                          // width: MediaQuery.of(context).size.width,
                          child: Text('0.000000', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        // Currency current value
                        Container(
                          // width: MediaQuery.of(context).size.width,
                          child: Text('=0.00 AES', style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.start)
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
                        "Trust Assets",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          // backgroundColor: Colors.black,
                          color: Colors.white,
                          fontSize: 16.0
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 10.0),
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: '= '),
                              TextSpan(text: '0.00000 ', style: TextStyle(fontSize: 28.0)),
                              TextSpan(text: 'AES')
                            ],
                          ),
                        )
                      )
                    ],
                  )
                ),
                Container(
                  // color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 12.0, bottom: 15.0),
                  margin: EdgeInsets.only(top: 15.0),
                  child: Text(
                    "Trust List",
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