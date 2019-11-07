import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'model/performance_team.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'dart:io';
import 'dart:convert';


class TrustPerformanceParam {
  final String yesterdayTeamEarningInUsdt;
  final String acquired30DaysInUsdt;
  final String communityMarketRevenueInUsdt;
  final String currencyManagementIncomeInUsdt;
  final String recent7DaysInUsdt;
  final String referralBonusInUsdt;
  final String yesterdayTeamEarning;
  final String acquired30Days;
  final String communityMarketRevenue;
  final String currencyManagementIncome;
  final String recent7Days;
  final String referralBonus;
  final String teamMember;

  TrustPerformanceParam({
    this.yesterdayTeamEarningInUsdt, this.yesterdayTeamEarning,
    this.acquired30DaysInUsdt, this.acquired30Days,
    this.communityMarketRevenueInUsdt, this.communityMarketRevenue,
    this.currencyManagementIncomeInUsdt, this.currencyManagementIncome,
    this.recent7DaysInUsdt, this.recent7Days,
    this.referralBonusInUsdt, this.referralBonus, this.teamMember});

  factory TrustPerformanceParam.fromJson(Map<String, dynamic> json) {
    return TrustPerformanceParam(
      acquired30Days: json['acquired30Days'],
      acquired30DaysInUsdt: json['acquired30DaysInUsdt'],
      yesterdayTeamEarning: json['yesterDayTeamEarning'],
      yesterdayTeamEarningInUsdt: json['yesterdayTeamEarningInUsdt'],
      communityMarketRevenueInUsdt: json['communityMarketRevenueInUsdt'],
      communityMarketRevenue: json['communityMarketRevenue'],
      currencyManagementIncome: json['currencyManagementIncome'],
      currencyManagementIncomeInUsdt: json['currencyManagementIncomeInUsdt'],
      recent7Days: json['recent7Days'],
      recent7DaysInUsdt: json['recent7DaysInUsdt'],
      referralBonus: json['referralBonus'],
      referralBonusInUsdt: json['referralBonusInUsdt'],
      teamMember: json['teamMember']
    );
  }
}

class PerformancePage extends StatefulWidget {
  
  PerformancePage({Key key}) : super(key: key);

  _PerformancePageState createState() => _PerformancePageState();
}


class _PerformancePageState extends State<PerformancePage> {

  final RefreshController _refreshController = RefreshController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<PerformanceTeam> _performanceAttrList = [
    PerformanceTeam("Currency Management Income", 0.000000, 0.000000),
    PerformanceTeam("Referral Bonus", 0.000000, 0.000000),
    PerformanceTeam("Community Market Revenue", 0.000000, 0.000000),
    // PerformanceTeam("Community Market Revenue", 0.000000, 0.000000),
    // PerformanceTeam("Rank Overriding Bonus", 0.000000, 0.000000),
    // PerformanceTeam("Rank Level Matching Bonus", 0.000000, 0.000000),
  ];

  TrustPerformanceParam myTrustPerformance = TrustPerformanceParam(
    acquired30Days: '0.00', acquired30DaysInUsdt: '0.00', yesterdayTeamEarning: '0.00',
    yesterdayTeamEarningInUsdt: '0.00', communityMarketRevenue: '0.00', communityMarketRevenueInUsdt: '0.00',
    currencyManagementIncome: '0.00', currencyManagementIncomeInUsdt: '0.00', recent7Days: '0.00', recent7DaysInUsdt: '0.00',
    referralBonus: '0.00', referralBonusInUsdt: '0.00', teamMember: '0'
  );

  ProgressDialog pr1, pr2;

  var queryParameters = <String, String>{};

  String yesterdayEarninginAES = '0.000000';
  String yesterdayEarninginUSDT = '0.000000';

  Future<void> _getPerformance (ProgressDialog pd) async {
    pd.show();
    try {
      FirebaseUser user = (await _auth.currentUser());
      if (user != null) {
        queryParameters = {
          'uuid': user.uid
        };

        new HttpClient().postUrl(new Uri.https('us-central1-aes-wallet.cloudfunctions.net', '/httpFunction/api/v1/getPerformance', queryParameters))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
            response.transform(Utf8Decoder()).transform(json.decoder).listen((contents) {
              setState(() {
                myTrustPerformance = TrustPerformanceParam.fromJson(contents);
                _performanceAttrList[0].aesVal = double.parse(myTrustPerformance.currencyManagementIncome);
                _performanceAttrList[0].usdtVal = double.parse(myTrustPerformance.currencyManagementIncomeInUsdt);
                _performanceAttrList[1].aesVal = double.parse(myTrustPerformance.referralBonus);
                _performanceAttrList[1].usdtVal = double.parse(myTrustPerformance.referralBonusInUsdt);
                _performanceAttrList[2].aesVal = double.parse(myTrustPerformance.communityMarketRevenue);
                _performanceAttrList[2].usdtVal = double.parse(myTrustPerformance.communityMarketRevenueInUsdt);
                yesterdayEarninginAES = myTrustPerformance.yesterdayTeamEarning;
                yesterdayEarninginUSDT = myTrustPerformance.yesterdayTeamEarningInUsdt;
                print(myTrustPerformance.yesterdayTeamEarning);
                pd.dismiss();
              });
            });
          });
        
      }
    } catch (e) {
      print (e);
    }
  }

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
                      performanceTeam.usdtVal.toStringAsFixed(2) + " USDT",
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
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      pr2 = new ProgressDialog(context, isDismissible: false);
      pr2.style(message: 'Retrieving latest data...');
      _getPerformance(pr2);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    pr1 = new ProgressDialog(context, isDismissible: false);
    pr1.style(message: 'Retrieving latest data...');
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
          // actions: <Widget>[
          //   Container(
          //     margin: EdgeInsets.only(right: 15.0),
          //     // height: 10.0,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: <Widget>[
          //         Text(
          //           "Switch to Badge Reward",
          //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
          //         )
          //       ],
          //     ),
          //   )
          // ],
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
          _refreshController.refreshCompleted();
          _getPerformance(pr1);
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 380.0,
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
                              yesterdayEarninginAES,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 10.0),
                            child: Text(
                              yesterdayEarninginUSDT + " USDT",
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
                                          myTrustPerformance.recent7Days + ' AES',
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
                                          myTrustPerformance.acquired30Days + " AES",
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
                                height: 100.0,
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
                                            myTrustPerformance.teamMember + " People",
                                            style: TextStyle(color: Colors.black, fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Divider(
                                    //   color: Colors.grey,
                                    //   thickness: 0.3,
                                    //   height: 28.0,
                                    // ),
                                    // Container(
                                    //   // margin: EdgeInsets.only(top: 15.0),
                                    //   child: Row(
                                    //     children: <Widget>[
                                    //       Container(
                                    //         width: MediaQuery.of(context).size.width / 2,
                                    //         child: Text(
                                    //           "Trust Performance",
                                    //           style: TextStyle(color: Colors.black, fontSize: 15.0),
                                    //           textAlign: TextAlign.start,
                                    //         ),
                                    //       ),
                                    //       Spacer(),
                                    //       Text(
                                    //         "0.000000 USDT",
                                    //         style: TextStyle(color: Color(0xFF273b54), fontSize: 15.0, fontWeight: FontWeight.bold),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
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
                  // _buildCardRow(_performanceAttrList[3]),
                  // _buildCardRow(_performanceAttrList[4]),
                  // _buildCardRow(_performanceAttrList[5]),
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