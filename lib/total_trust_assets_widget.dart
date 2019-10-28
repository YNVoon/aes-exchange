import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'model/trust_transaction_list.dart';

import 'transfer_trust_widget.dart';

class TotalTrustAssetPage extends StatefulWidget {
  TotalTrustAssetPage({Key key}) : super(key: key);

  @override
  _TotalTrustAssetPageState createState() => _TotalTrustAssetPageState();
}

class _TotalTrustAssetPageState extends State<TotalTrustAssetPage> {

  final RefreshController _refreshController = RefreshController();

  List<TrustTransaction> _trustTransactionList = List<TrustTransaction>();

  @override
  void initState() {
    super.initState();
    _trustTransactionList.add(TrustTransaction('2019-10-28', '22:18:25', 'BTC', 0.00184561, true));
    _trustTransactionList.add(TrustTransaction('2019-10-28', '22:25:25', 'BTC', 0.00382561, false));
  }

  Widget _buildTransactionRow (TrustTransaction trustTransaction) {
    return Container(
      color: Colors.white,
      // padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Column(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {

              },
              child: Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ClipOval(
                          child: Container(
                            color: trustTransaction.isTransferIn ? Color(0xFF34b187) : Color(0xFFff0152),
                            width: 30.0,
                            height: 30.0,
                            child: Center(
                              child: IconTheme(
                                data: IconThemeData(
                                  color: Colors.white
                                ),
                                child: Icon(
                                  trustTransaction.isTransferIn ? Icons.arrow_downward : Icons.arrow_upward
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 160.0,
                          margin: EdgeInsets.only(left: 20.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(trustTransaction.currencyType, textAlign: TextAlign.start,),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(trustTransaction.date + ' ' + trustTransaction.time, textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    Container(
                      child: Text(
                        trustTransaction.transactionAmount.toStringAsFixed(8) + ' BTC',
                        style: TextStyle(fontWeight: FontWeight.bold, color: trustTransaction.isTransferIn ? Color(0xFF34b187) : Color(0xFFff0152)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Divider(
            thickness: 0.3,
            height: 0.0,
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            "Total Assest Value",
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: MaterialClassicHeader(color: Colors.blue, backgroundColor: Colors.white,),
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          _refreshController.refreshCompleted();
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                height: 108.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0
                          ),
                          children: <TextSpan>[
                            TextSpan(text: "0.000000", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0)),
                            TextSpan(text: "  BTC")
                          ]
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 25.0),
                      child: Text(
                        '= 0.000000 USDT',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 12.0,
                color: Color(0xFFf2f3f5),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20.0, top: 12.0, bottom: 12.0),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Trust List',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)
                      ),
                    ),
                    Divider(
                      height: 0.0,
                    )
                  ],
                ),
              ),
            ),
            _trustTransactionList.length <= 0 ? SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                height: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'No data available',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    )
                  ],
                ),
              ),
            ) : SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildTransactionRow(_trustTransactionList[0]),
                  _buildTransactionRow(_trustTransactionList[1]),
                  _buildTransactionRow(_trustTransactionList[0]),
                  _buildTransactionRow(_trustTransactionList[1]),
                  _buildTransactionRow(_trustTransactionList[0]),
                  _buildTransactionRow(_trustTransactionList[1]),
                  _buildTransactionRow(_trustTransactionList[0]),
                  _buildTransactionRow(_trustTransactionList[1]),
                ]
                
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 65.0,
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
        child: RaisedButton(
          color: Color(0xFF018dee),
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => TransferTrustPage()),
            );
          },
          child: Text(
            "Transfer Trust",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
        ),
      ),
    );
  }
}