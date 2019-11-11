import 'package:flutter/material.dart';

class SecurityPage extends StatefulWidget {
  SecurityPage({Key key}) : super(key: key);

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final FocusNode _nodePass1 = FocusNode();
  final FocusNode _nodePass2 = FocusNode();
  final FocusNode _nodePass3 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          elevation: 1.0,
          title: Text(
            'Security',
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15.0),
              child: Text(
                  'All new user will have a default transaction password which is 888888. Please change the password as soon as possiible for security reason.'),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.0),
              child: TextFormField(
                
                obscureText: true,
                focusNode: _nodePass1,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _nodePass1.unfocus();
                  FocusScope.of(context).requestFocus(_nodePass2);
                },
                decoration: InputDecoration(
                  hintText: 'Insert old transaction password'
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Required to fill up';
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
