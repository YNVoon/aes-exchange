import 'package:aes_exchange/utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'property_widget.dart';
import 'trust_widget.dart';
import 'discover_widget.dart';
import 'userprofile_widget.dart';
import 'login_widget.dart';
import 'splash_screen_widget.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_cupertino_localizations/flutter_cupertino_localizations.dart';

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
      home: _isUserLoggedin ? MyHomePage() : SplashScreenPage(),
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale.fromSubtags(languageCode: 'zh'), // generic Chinese 'zh'
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'), // generic simplified Chinese 'zh_Hans'
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'), // generic traditional Chinese 'zh_Hant'
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'), // 'zh_Hans_CN'
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'), // 'zh_Hant_TW'
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'HK'), // 'zh_Hant_HK'
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'MY'), // 'zh_Hant_HK'
        // Locale('zh', 'CN'), 
        // Locale('zh', 'TW'),
        // Locale('zh', 'HK'),
        // Locale('zh', 'SG'), 
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);


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
        // appBarTitle = "AES | Deposit";
        appBarTitle = AppLocalizations.of(context).translate('aes_deposit');
      } else if (_selectedIndex == 1) {
        // appBarTitle = "AES | Deposit";
        appBarTitle = AppLocalizations.of(context).translate('aes_deposit');
      } else if (_selectedIndex == 2) {
        // appBarTitle = "Discover";
        appBarTitle = AppLocalizations.of(context).translate('discover');
      } else if (_selectedIndex == 3) {
        // appBarTitle = "Profile";
        appBarTitle = AppLocalizations.of(context).translate('profile');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        appBarTitle = AppLocalizations.of(context).translate('aes_deposit');
      });
    });
    // appBarTitle = AppLocalizations.of(context).translate('aes_deposit');
    
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
      // Bottom Navigation Bar
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            title: Text(AppLocalizations.of(context).translate('funds'))
          ),
            
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            title: Text(AppLocalizations.of(context).translate('trusts'))
          ),
            
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            title: Text(AppLocalizations.of(context).translate('discover'))
          ),
            
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity),
            title: Text(AppLocalizations.of(context).translate('me'))
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
