import 'package:flutter/material.dart';

class DiscoverWidget extends StatefulWidget {
  DiscoverWidget({Key key}) : super(key: key);

  _DiscoverWidgetState createState() => _DiscoverWidgetState();
}

class _DiscoverWidgetState extends State<DiscoverWidget> {

  void _showMaterialDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            'Coming Soon',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        );
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                  "EXCHANGE",
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 16.0,
                    letterSpacing: 5.0
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
                            "Convenient",
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
                            "Shopping center",
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
                            "Webcast",
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
            padding: EdgeInsets.only(left: 12.0, bottom: 15.0),
            margin: EdgeInsets.only(top: 25.0),
            child: Text(
              "Shopping Center",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              textAlign: TextAlign.start,
            ),
          ),
        )
      ],
    );
  }
}