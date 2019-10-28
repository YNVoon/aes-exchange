import 'package:flutter/material.dart';

class TransferTrustPage extends StatefulWidget {
  TransferTrustPage({Key key}) : super(key: key);

  @override
  _TransferTrustPageState createState() => _TransferTrustPageState();
}

class _TransferTrustPageState extends State<TransferTrustPage> {

  bool accept = false;

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         backgroundColor: Colors.white,
         appBar: PreferredSize(
           preferredSize: Size.fromHeight(50.0),
           child: AppBar(
             centerTitle: true,
             elevation: 0.0,
             title: Text(
               "Transfer",
               style: Theme.of(context).textTheme.title,
             ),
           ),
         ),
         body: Container(
           padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
           child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 12.0),
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
                    'BTC',
                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  height: 0.0,
                ),
                Container(
                  margin: EdgeInsets.only(top: 25.0, bottom: 15.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Quantity',
                    style: TextStyle(color: Color(0xFF5f696b), fontSize: 14.0),
                    textAlign: TextAlign.start,
                  ),
                ),
                TextFormField(
                  onFieldSubmitted: (term) {

                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFfafafa))
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                    ),
                    hintText: 'Input Quantity',
                    hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.w300),
                    border: OutlineInputBorder(),
                    suffixIcon: Container(
                      width: 75.0,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'BTC  |',
                            style: TextStyle(fontSize: 12.0, color: Color(0xFFc4c5c7)),
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
                    style: TextStyle(color: Color(0xFFc4c5c7), fontSize: 12.0),
                    textAlign: TextAlign.start,
                  ),
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
                        'Note: When the total value of Trust is turned on, it will automatically turn on Trust to generate revenue (additional fee is charged for Re-turning out.',
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
                            'Confirm Transfer',
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