import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'property_widget.dart';
import 'trust_widget.dart';
import 'discover_widget.dart';
import 'userprofile_widget.dart';
import 'login_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final _isUserLoggedin = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark
      )
    );
    return MaterialApp(
      title: 'AES Exchange',
      theme: ThemeData(
        primaryColor: Colors.white,
      ), 
      // home: MyHomePage(title: 'AES Exchange'),
      home: _isUserLoggedin ? MyHomePage(title: 'AES Exchange') : LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String appBarTitle = "";

  final List<Widget> _children = [
    PropertyWidget(),
    TrustWidget(),
    DiscoverWidget(),
    UserProfileWidget()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        appBarTitle = "AES | Deposit";
      } else if (_selectedIndex == 1) {
        appBarTitle = "AES | Deposit";
      } else if (_selectedIndex == 2) {
        appBarTitle = "Discover";
      } else if (_selectedIndex == 3) {
        appBarTitle = "Profile";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    appBarTitle = "AES | Deposit";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: _selectedIndex == 0 || _selectedIndex == 1 ? Size.fromHeight(50.0) : Size.fromHeight(0.0),
        child: AppBar(
          centerTitle: true,
          elevation: 0.0,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(
            appBarTitle,
            style: Theme.of(context).textTheme.title,
            ),
        ),
      ),
      body: _children[_selectedIndex],
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            title: Text('Funds')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            title: Text('Trust')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            title: Text('Discover')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity),
            title: Text('Me')
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
