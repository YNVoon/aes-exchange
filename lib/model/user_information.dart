class UserInformation {
  final String userEmail;
  final String userInvitationCode;
  final String userId;
  final int userVIPStatus;

  UserInformation({this.userEmail, this.userInvitationCode, this.userId, this.userVIPStatus});

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    return UserInformation(
      userEmail: json['userEmail'],
      userInvitationCode: json['userInvitationCode'],
      userId: json['userId'],
      userVIPStatus: json['userVIPStatus'],
    );
  }

}