import 'package:flutter/material.dart';

class WalletTransferPage extends StatefulWidget {
  WalletTransferPage({Key key}) : super(key: key);

  @override
  _WalletTransferPageState createState() => _WalletTransferPageState();
}

class _WalletTransferPageState extends State<WalletTransferPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         backgroundColor: Colors.white,
         appBar: PreferredSize(
           preferredSize: Size.fromHeight(50.0),
           child: AppBar(elevation: 0.0,),
         ),
         body: SingleChildScrollView(
           child: Container(
             padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
             child: Column(
               children: <Widget>[
                 Container(
                   width: MediaQuery.of(context).size.width,
                   child: Text(
                     'Transfer',
                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                     textAlign: TextAlign.start,
                   ),
                 ),
                 Container(
                   margin: EdgeInsets.only(top: 15.0),
                   padding: EdgeInsets.only(left: 20.0, top: 5.0, bottom: 5.0),
                   color: Color(0xFFf7f6fb),
                   height: 35.0,
                   child: Row(
                     children: <Widget>[
                       Image(image: AssetImage('assets/bitcoin.png'), width: 25.0,),
                       Container(
                         margin: EdgeInsets.only(left: 10.0),
                         child: Text(
                           'BTC',
                           style: TextStyle(fontWeight: FontWeight.bold),
                         ),
                       ),
                     ],
                   ),
                 ),
                 Container(
                  margin: EdgeInsets.only(top: 25.0, bottom: 15.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Other accounts',
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                    textAlign: TextAlign.start,
                  ),
                ),
                TextFormField(
                  onFieldSubmitted: (term) {

                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFe5e5e7))
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                    ),
                    hintText: "Please enter recipient's email address",
                    hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),
                    border: OutlineInputBorder(),
                    
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25.0, bottom: 15.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Quantity Transfer',
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                    textAlign: TextAlign.start,
                  ),
                ),
                TextFormField(
                  onFieldSubmitted: (term) {

                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFe5e5e7))
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                    ),
                    hintText: 'Please enter your quantity',
                    hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),
                    border: OutlineInputBorder(),
                    suffixIcon: Container(
                      width: 75.0,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'BTC',
                            style: TextStyle(fontSize: 12.0, color: Colors.grey),
                          ),
                          Text(
                            '  |',
                            style: TextStyle(fontSize: 25.0, color: Color(0xFFc4c5c7), fontWeight: FontWeight.w200),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {

                              },
                              child: Text(
                                "All",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Available amount 0.00000000 BTC',
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 12.0, top: 20.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Handling fee',
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 10.0, top: 12.0),
                  child: Text(
                    '0.00000000 AES',
                    style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  height: 0.0,
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                  color: Color(0xFFf7f6fb),
                  height: 35.0,
                  child: Row(
                    children: <Widget>[
                      Text(
                       "Miner's Fee " + "0.000400 BTC",
                       style: TextStyle(color: Colors.grey, fontSize: 12.0),
                     )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Transfer Amount',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Spacer(),
                      Text(
                        '0.00000000 BTC',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 15.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {

                    },
                    child: Text(
                      'Transfer',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
               ],
             ),
           ),
         ),
       ),
    );
  }
}