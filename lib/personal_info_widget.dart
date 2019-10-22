import 'package:flutter/material.dart';
import 'model/personal_info.dart';

class PersonalInfoPage extends StatefulWidget {
  PersonalInfoPage({Key key}) : super(key: key);

  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {

  List<List<PersonalInfo>> _personalInfoList = [
    [PersonalInfo("Nickname", "icon", "nickname"), PersonalInfo("ID", "ABC12345", "id")],
    [PersonalInfo("Performance level", "VIP 0", "performance_level"), PersonalInfo("Membership level", "non-node", "membership_level")],
    [PersonalInfo("Gender", "icon", "gender"), PersonalInfo("Personalized signature", "icon", "personalize_signature")]
  ];

  Widget _buildPersonalInfoRow(PersonalInfo personalInfo, int index) {
    return GestureDetector(
      onTap: () {
        print(personalInfo.title);
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 52.0,
            child: Row(
              children: <Widget>[
                Container(
                  width: 200.0,
                  child: Text(personalInfo.title, textAlign: TextAlign.start),
                ),
                Spacer(),
                personalInfo.value == "icon" ? Icon(Icons.chevron_right) : Text(personalInfo.value, textAlign: TextAlign.end),
              ],
            ),
          ),
          _personalInfoList[index].indexOf(personalInfo) != _personalInfoList[index].length - 1 ? Divider(
            color: Colors.grey,
            thickness: 0.3,
            height: 0.0,
          ) : Container(padding: index == _personalInfoList.length - 1 ? EdgeInsets.all(0.0) : EdgeInsets.all(4.0), color: Color(0xFFEEEEEE),)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          // leading: IconButton(icon:Icon(Icons.arrow_back),
          //   onPressed:() => Navigator.pop(context),
          // ),
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            "Personal Information",
            style: Theme.of(context).textTheme.title
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              color: Color(0xFFEEEEEE),
              padding: EdgeInsets.all(3.0),
            ),
          ),
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {
                print("Head portrait");
              },
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: 65.0,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 200.0,
                          // margin: EdgeInsets.only(left: 20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text("Head portrait", textAlign: TextAlign.start),
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 20.0,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              child: Icon(Icons.chevron_right),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.2,
                    height: 0.0,
                  )
                ],
              )
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildPersonalInfoRow(_personalInfoList[0][0], 0),
                _buildPersonalInfoRow(_personalInfoList[0][1], 0),
              ]
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildPersonalInfoRow(_personalInfoList[1][0], 1),
                _buildPersonalInfoRow(_personalInfoList[1][1], 1),
              ]
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildPersonalInfoRow(_personalInfoList[2][0], 2),
                _buildPersonalInfoRow(_personalInfoList[2][1], 2),
              ]
            ),
          )
        ],
      )
    );
  }
}