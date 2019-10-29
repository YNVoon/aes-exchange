import 'package:flutter/material.dart';

class TrustWithdrawPage extends StatefulWidget {
  TrustWithdrawPage({Key key}) : super(key: key);

  @override
  _TrustWithdrawPageState createState() => _TrustWithdrawPageState();
}

class _TrustWithdrawPageState extends State<TrustWithdrawPage> {

  bool accept = false;

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         backgroundColor: Color(0xFFFAFAFA),
         appBar: PreferredSize(
           preferredSize: Size.fromHeight(50.0),
           child: AppBar(
             centerTitle: true,
             elevation: 0.0,
             title: Text(
               "Withdraw",
               style: Theme.of(context).textTheme.title,
             ),
           ),
         ),
         body: Container(
           color: Colors.white,
           padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
           child: Column(
             children: <Widget>[
               Container(
                 height: 70.0,
                 decoration: BoxDecoration(
                   border: Border.all(color: Color(0xFFfcfcfc))
                 ),
                 child: Column(
                   children: <Widget>[
                     Container(
                       height: 34.0,
                       color: Colors.white,
                       margin: EdgeInsets.only(left: 10.0, right: 10.0),
                       child: Row(
                         children: <Widget>[
                           ClipOval(
                             child: Container(
                               color: Color(0xFF1c71ad),
                               width: 8.0,
                               height: 8.0,
                             ),
                           ),
                           Container(
                             margin: EdgeInsets.only(left: 15.0),
                             child: Text(
                                "Trust in date",
                                style: TextStyle(color: Color(0xFFbec0bf)),
                              ),
                           ),
                           Container(
                             margin: EdgeInsets.only(left: 15.0),
                             child: Text(
                                "2019-10-28",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                           )
                         ],
                       ),
                     ),
                     Divider(
                       color: Colors.grey,
                       thickness: 0.3,
                       height: 0.0,
                     ),
                     Container(
                       height: 34.0,
                       color: Colors.white,
                       margin: EdgeInsets.only(left: 10.0, right: 10.0),
                       child: Row(
                         children: <Widget>[
                           ClipOval(
                             child: Container(
                               color: Color(0xFFd14970),
                               width: 8.0,
                               height: 8.0,
                             ),
                           ),
                           Container(
                             margin: EdgeInsets.only(left: 15.0),
                             child: Text(
                                "Duration",
                                style: TextStyle(color: Color(0xFFbec0bf)),
                              ),
                           ),
                           Container(
                             margin: EdgeInsets.only(left: 15.0),
                             child: Text(
                                "0 day",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                           )
                         ],
                       ),
                     ),
                   ],
                 ),
               ),
               Container(
                 margin: EdgeInsets.only(top: 30.0, bottom: 12.0),
                 width: MediaQuery.of(context).size.width,
                 child: Text(
                   'Coin',
                   style: TextStyle(color: Color(0xFF5f696b), fontSize: 14.0),
                   textAlign: TextAlign.start,
                 ),
               ),
               Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Bitcoin',
                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  height: 0.0,
                ),
                Container(
                 margin: EdgeInsets.only(top: 30.0, bottom: 12.0),
                 width: MediaQuery.of(context).size.width,
                 child: Text(
                   'Amount',
                   style: TextStyle(color: Color(0xFF5f696b), fontSize: 14.0),
                   textAlign: TextAlign.start,
                 ),
               ),
               Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    '0.000195',
                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  height: 0.0,
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  padding: EdgeInsets.all(15.0),
                  color: Color(0xFFf7f6fb),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'If you stop storing FD at AES Wallet within 28 days, you will be charged a 5% fee.\nAfter 28 days, it can be realized at any time, only 1% of the handling fee is deducted.\nProcessing fees: ' + '0.020037 AES',
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                          value: accept,
                          onChanged: (bool value) {
                            setState(() {
                              accept = value; 
                            });
                          },
                        ),
                        Container(
                        //  margin: EdgeInsets.only(left: 10.0),
                          child: Text(
                            'I agree '
                          ),
                        ),
                        Container(
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              
                            },
                            child: Text(
                              'Trust Trading Rules',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () {

                          },
                          child: Text(
                            'Confirm Withdraw',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                      ),
                      )
                    ),
                  ),
                )
             ],
           ),
         ),
       ),
    );
  }
}