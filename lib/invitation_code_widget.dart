import 'package:aes_exchange/model/user_information.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:aes_exchange/utils/app_localizations.dart';

class InvitationCodePage extends StatefulWidget {

  final UserInformation userInformation;

  InvitationCodePage({Key key, @required this.userInformation}) : super(key: key);

  @override
  _InvitationCodePageState createState() => _InvitationCodePageState();
}

class _InvitationCodePageState extends State<InvitationCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF33468a),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            AppLocalizations.of(context).translate('invitation_code'),
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 30.0, right: 30.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
              width: MediaQuery.of(context).size.width,
              child: Text(
                AppLocalizations.of(context).translate('blockchain_based'),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 500.0,
              padding: EdgeInsets.all(10.0),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Image(image: AssetImage('assets/aes_deposit_full.png'), width: 150.0,),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      AppLocalizations.of(context).translate('sharing'),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'https://aes-wallet.web.app/signup?referral=' + widget.userInformation.userInvitationCode,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(0.0),
                    child: RaisedButton(
                      color: Color(0xFF33468a),
                      onPressed: () {
                        Clipboard.setData(new ClipboardData(text: 'https://aes-wallet.web.app/signup?referral=' + widget.userInformation.userInvitationCode));
                        Fluttertoast.showToast(
                            msg:  AppLocalizations.of(context).translate('copied_to_clipboard'),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context).translate('copy_link'),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      AppLocalizations.of(context).translate('a_digital_asset_bank'),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(
                    height: 15.0,
                    thickness: 0.3,
                    color: Colors.grey,
                  ),
                  Container(
                    child: QrImage(
                       data: 'https://aes-wallet.web.app/signup?referral=' + widget.userInformation.userInvitationCode,
                       version: 4,
                       size: 165.0,
                     ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      AppLocalizations.of(context).translate('scan_qr_code_registration_download'),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}