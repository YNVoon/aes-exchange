import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:aes_exchange/utils/app_localizations.dart';

class DiscoverWidget extends StatefulWidget {
  DiscoverWidget({Key key}) : super(key: key);

  _DiscoverWidgetState createState() => _DiscoverWidgetState();
}

class _DiscoverWidgetState extends State<DiscoverWidget> {

  var shoppingListTitle = ["AES Pay"];
  var shoppingListDescription = ["Pay bill"];
  var blockChainListTitle = ["BTC", "ETH", "USDT"];
  var blockChainListWebPath = [
    "https://coinmarketcap.com/currencies/bitcoin/",
    "https://coinmarketcap.com/currencies/ethereum/",
    "https://coinmarketcap.com/currencies/tether/"
  ];
  var shoppingListImagePath = ["assets/aessignatum.png"];
  var blockChainListImagePath = ["assets/bitcoin.png", "assets/ethereum.png", "assets/tether.png"];

  void _launchURL(String path) async {
    var url = path;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch URL';
    }
  }

  void _showMaterialDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            AppLocalizations.of(context).translate('coming_soon'),
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        shoppingListDescription = [];
        shoppingListDescription.add(AppLocalizations.of(context).translate('pay_bill'));
      });
    });
  }

  Widget _buildCard(String imagePath, int index) {
    return Container(
      margin: index % 2 == 0 ? EdgeInsets.only(left: 15.0) : EdgeInsets.only(right: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(const Radius.circular(10.0)),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width / 2,
      // height: 85.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _launchURL(blockChainListWebPath[index]);
          },
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Text("T", style: TextStyle(fontSize: 30.0)),
                Image(
                  image: AssetImage(blockChainListImagePath[index]),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 120.0,
                        child: Text(blockChainListTitle[index] + AppLocalizations.of(context).translate('explorer'), textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      Container(
                        width: 120.0,
                        child: Text(AppLocalizations.of(context).translate('browse_the') + blockChainListTitle[index] + AppLocalizations.of(context).translate('latest_info'), style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.start)
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

  }

  Widget _buildShoppingCard(String imagePath, int index) {
    return Container(
      margin: index % 2 == 0 ? EdgeInsets.only(left: 15.0) : EdgeInsets.only(right: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(const Radius.circular(10.0)),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width / 2,
      // height: 85.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showMaterialDialog();
          },
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Text("T", style: TextStyle(fontSize: 30.0)),
                Image(
                  image: AssetImage(shoppingListImagePath[index]),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 120.0,
                        child: Text(shoppingListTitle[index], textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      Container(
                        width: 120.0,
                        child: Text(shoppingListDescription[index], style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.start)
                      )
                    ],
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
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF323c83),
                borderRadius: BorderRadius.all(const Radius.circular(10.0))
              ),
              height: 150.0,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "AES",
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 60.0,
                      letterSpacing: 5.0
                    ),
                  ),
                  Text(
                    "DEPOSIT",
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 16.0,
                      letterSpacing: 9.0
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipOval(
                            child: Material(
                              color: Color(0xFFefefed),
                              child: InkWell(
                                splashColor: Colors.grey,
                                child: SizedBox(
                                  width: 56.0,
                                  height: 56.0,
                                  child: Icon(Icons.toys),                            
                                ),
                                onTap: () {
                                  _showMaterialDialog();
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: Text(
                              AppLocalizations.of(context).translate('convenient'),
                              style: TextStyle(
                                fontSize: 12.0
                              ),
                            ) ,
                          )
                        ],
                      ),
                    )
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipOval(
                            child: Material(
                              color: Color(0xFFefefed),
                              child: InkWell(
                                splashColor: Colors.grey,
                                child: SizedBox(
                                  width: 56.0,
                                  height: 56.0,
                                  child: Icon(Icons.shopping_cart),                            
                                ),
                                onTap: () {
                                  _showMaterialDialog();
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: Text(
                              AppLocalizations.of(context).translate('shopping_center'),
                              style: TextStyle(
                                fontSize: 12.0
                              ),
                            ) ,
                          )
                        ],
                      ),
                    )
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipOval(
                            child: Material(
                              color: Color(0xFFefefed),
                              child: InkWell(
                                splashColor: Colors.grey,
                                child: SizedBox(
                                  width: 56.0,
                                  height: 56.0,
                                  child: Icon(Icons.ondemand_video),                            
                                ),
                                onTap: () {
                                  _showMaterialDialog();
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: Text(
                              AppLocalizations.of(context).translate('webcast'),
                              style: TextStyle(
                                fontSize: 12.0
                              ),
                            ) ,
                          )
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 12.0, bottom: 20.0),
              margin: EdgeInsets.only(top: 25.0),
              child: Text(
                AppLocalizations.of(context).translate('shopping_center'),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
              childAspectRatio: 2.0
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _buildShoppingCard("testing", index);
              },
              childCount: 1
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 12.0, bottom: 20.0),
              margin: EdgeInsets.only(top: 25.0),
              child: Text(
                AppLocalizations.of(context).translate('explorer'),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
              childAspectRatio: 2.0
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _buildCard("testing", index);
              },
              childCount: 3
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}