import 'package:flutter/material.dart';
import 'package:aes_exchange/utils/app_localizations.dart';

class TermsAndConditionsPage extends StatefulWidget {
  TermsAndConditionsPage({Key key}) : super(key: key);

  @override
  _TermsAndConditionsPageState createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          elevation: 1.0,
          title: Text(
            AppLocalizations.of(context).translate('terms_and_conditions'),
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0, bottom: 40.0),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('t_and_c_first_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('eligibility'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('eligibility_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('prohibition_of_use'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('prohibition_of_use_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('description_of_services'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('description_of_services_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('aes_deposit_account_registration_and_requirement'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('registration'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('registration_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('user_identity_verification'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('user_identity_verification_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('account_usage_requirement'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('account_usage_requirement_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('account_security'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('account_security_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('dispute_resolution'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('dispute_resolution_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('guideline_for_usage_of_services_on_aes_deposit'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('guideline_for_usage_of_services_on_aes_deposit_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('service_fee'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('service_fee_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('liability'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('provision_of_service'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('provision_of_service_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('limitation_of_liability'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('limitation_of_liability_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('indemnification'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('indemnification_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('termination_of_account'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('termination_of_account_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('remaining_fund_after_account_termination_normal'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('remaining_fund_after_account_termination_normal_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('remaining_fund_after_account_termination_fraud'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('remaining_fund_after_account_termination_fraud_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('compliance_with_local_laws'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('compliance_with_local_laws_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('privacy_policy'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('privacy_policy_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('indemnity_and_disclaimer'),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocalizations.of(context).translate('indemnity_and_disclaimer_para'),
                  style: TextStyle(fontSize: 15.0,),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
