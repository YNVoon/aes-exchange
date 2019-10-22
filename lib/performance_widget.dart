import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'model/performance_team.dart';

class PerformancePage extends StatefulWidget {
  
  PerformancePage({Key key}) : super(key: key);

  
  _PerformancePageState createState() => _PerformancePageState();
}


class _PerformancePageState extends State<PerformancePage> {

  final RefreshController _refreshController = RefreshController();

  List<PerformanceTeam> _performanceAttrList = [
    PerformanceTeam("Currency Management Income", 0.000000, 0.000000),
    PerformanceTeam("Recommended Market Income", 0.000000, 0.000000),
    PerformanceTeam("Sponsor Share Bonus", 0.000000, 0.000000),
    PerformanceTeam("Community Market Revenue", 0.000000, 0.000000),
    PerformanceTeam("Rank Overriding Bonus", 0.000000, 0.000000),
    PerformanceTeam("Rank Level Matching Bonus", 0.000000, 0.000000),
  ];

  Widget _buildCardRow(PerformanceTeam performanceTeam) {
    return Container(
      margin: EdgeInsets.only(left: 25.0, right: 25.0, top: 5.0),
      child: Card(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 80.0,
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  performanceTeam.title,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        "= " + performanceTeam.aesVal.toStringAsFixed(6),
                        style: TextStyle(color: Colors.black, fontSize: 15.0),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Spacer(),
                    Text(
                      performanceTeam.usdtVal.toStringAsFixed(6) + " USDT",
                      style: TextStyle(color: Color(0xFF273b54), fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          brightness: Brightness.dark,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  statusBarColor: Colors.white
                )
              );
              Navigator.pop(context);

            },
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 15.0),
              // height: 10.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Switch to Badge Reward",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
                  )
                ],
              ),
            )
          ],
          backgroundColor: Color(0xFF000116),
          elevation: 5.0,
          iconTheme: IconThemeData(
            color: Colors.white
          )
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
                width: MediaQuery.of(context).size.width,
                height: 400.0,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment(-1.0, -1.0),
                          image: AssetImage("assets/blue_stock.jpg"),
                          fit: BoxFit.contain
                        )
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 5.0),
                            child: Text(
                              "Yesterday Team Earnings (AES)",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 20.0),
                            child: Text(
                              "0.000000",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 10.0),
                            child: Text(
                              "= 0.000000 USDT",
                              style: TextStyle(color: Colors.white, fontSize: 13.0),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30.0),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        // margin: EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          "Recent 7-day Return",
                                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          "0.000000 AES",
                                          style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        // margin: EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          "Accured Return (30 days)",
                                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          "0.000000 AES",
                                          style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30.0),
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(15.0),
                                width: MediaQuery.of(context).size.width,
                                height: 130.0,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        "Team Data",
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context).size.width / 2,
                                            child: Text(
                                              "Team Community",
                                              style: TextStyle(color: Colors.black, fontSize: 15.0),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            "0 People",
                                            style: TextStyle(color: Colors.black, fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      thickness: 0.3,
                                      height: 28.0,
                                    ),
                                    Container(
                                      // margin: EdgeInsets.only(top: 15.0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context).size.width / 2,
                                            child: Text(
                                              "Trust Performance",
                                              style: TextStyle(color: Colors.black, fontSize: 15.0),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            "0.000000 USDT",
                                            style: TextStyle(color: Color(0xFF273b54), fontSize: 15.0, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 18.0, left: 20.0),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Income Overview",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),
                              textAlign: TextAlign.start,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildCardRow(_performanceAttrList[0]),
                  _buildCardRow(_performanceAttrList[1]),
                  _buildCardRow(_performanceAttrList[2]),
                  _buildCardRow(_performanceAttrList[3]),
                  _buildCardRow(_performanceAttrList[4]),
                  _buildCardRow(_performanceAttrList[5]),
                ]
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(10.0),
              ),
            )
          ],
        )
      )
    );
  }
}