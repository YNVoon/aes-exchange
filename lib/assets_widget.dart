import 'package:aes_exchange/model/currency.dart';
import 'package:flutter/material.dart';

import 'wallet_withdrawal_widget.dart';
import 'wallet_transfer_widget.dart';
import 'wallet_deposit_widget.dart';

class AssetsPage extends StatefulWidget {

  final Currency currency;

  AssetsPage({Key key, @required this.currency}) : super(key: key);

  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {

  List<String> _buttonList = ["Hello World", "Testing", "Swap", "Transaction"];

  Widget _buildGridButtons (String title, int index) {
    return InkWell(
      onTap: () {
        if (index == 1) {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => WalletTransferPage(currency: widget.currency,)),
          );
        }
        
      },
      child: Container(
        margin: index % 2 == 0 ? EdgeInsets.only(right: 5.0) : EdgeInsets.only(left: 5.0),
        height: 75.0,
        child: Card(
          color: Color(0xFFf3f7fa),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("T", style: TextStyle(fontSize: 30.0)),
                
                Container(
                  width: 80.0,
                  margin: EdgeInsets.only(left: 15.0),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         backgroundColor: Color(0xFFFAFAFA),
         appBar: PreferredSize(
           preferredSize: Size.fromHeight(50.0),
           child: AppBar(
             centerTitle: true,
             elevation: 1.0,
             title: Text(
               "Assets",
               style: Theme.of(context).textTheme.title
             ),
           ),
         ),
         body: Container(
           color: Colors.white,
           child: Column(
             children: <Widget>[
               Container(
                 margin: EdgeInsets.only(top: 15.0),
                 child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                          // Currency Logo Image
                          // Text("T", style: TextStyle(fontSize: 40.0)),
                          Image(image: AssetImage(widget.currency.currencyLogoUrl), width: 30.0,),
                          Container(
                            width:50,
                            margin: EdgeInsets.only(left: 20.0),
                            child: Column(
                              children: <Widget>[
                                //Currency Name
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(widget.currency.currencyName, textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                                ),
                                // Currency current value
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(widget.currency.currencyName, style: TextStyle(fontSize: 14.0, color: Colors.grey,), textAlign: TextAlign.start)
                                )
                              ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 20.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  "Total",
                                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Spacer(),
                              Text(
                                widget.currency.currencyBalance,
                                style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "Available Balance",
                                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  widget.currency.currencyBalanceTotal,
                                  
                                  style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 0.3,
                      color: Colors.grey,
                      height: 15.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0, bottom: 15.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  "Estimate value (USDT)",
                                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Spacer(),
                              Text(
                                widget.currency.equalityToUsdt.toStringAsFixed(6),
                                style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "Estimate value (USDT)",
                                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  widget.currency.equalityToUsdtTotal.toStringAsFixed(6),
                                  
                                  style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      color: Color(0xFFf7f8fa),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 20.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Trade",
                              style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: _buildGridButtons("Swap", 0),
                          ),
                          Flexible(
                            flex: 1,
                            child: _buildGridButtons("Transfer", 1),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: _buildGridButtons("Withdrawal Record", 2),
                          ),
                          Flexible(
                            flex: 1,
                            child: _buildGridButtons("Transaction", 3),
                          ),
                        ],
                      ),
                    ),
                    
                  ],
                ),
                
               ),
               Expanded(
                 child: Container(
                   margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                   height: 50.0,
                   child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(right: 8.0),
                            width: MediaQuery.of(context).size.width / 2 -20.0,
                            child: RaisedButton(
                              color: Color(0xFF00be82),
                              onPressed: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => WalletDepositPage(currency: widget.currency,)),
                                );
                              },
                              child: Text(
                                "Deposit",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                              ),
                            ),
                          )
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left: 8.0),
                            width: MediaQuery.of(context).size.width / 2 - 20.0,
                            child: RaisedButton(
                              color: Color(0xFFee318b),
                              onPressed: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => WalletWithdrawalPage(currency: widget.currency,)),
                                );
                              },
                              child: Text(
                                "Withdrawal",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                              ),
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                 )
               ), 
             ],
           )
         ),
       )
    );
  }
}