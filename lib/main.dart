import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'property_widget.dart';
import 'trust_widget.dart';
import 'discover_widget.dart';
import 'userprofile_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white
      )
    );
    return MaterialApp(
      title: 'AES Exchange',
      theme: ThemeData(
        primaryColor: Colors.white,
      ), 
      home: MyHomePage(title: 'AES Exchange'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
        appBarTitle = "AES Exchange";
      } else if (_selectedIndex == 1) {
        appBarTitle = "Trust";
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
    appBarTitle = "AES Exchange";
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
            title: Text('Property')
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
