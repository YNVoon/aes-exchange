class CryptoCurrentBalance {
  final String btcBalance;
  final String ethBalance;
  final String usdtBalance;
  final String aesBalance;

  CryptoCurrentBalance({this.btcBalance, this.ethBalance, this.usdtBalance, this.aesBalance});

  factory CryptoCurrentBalance.fromJson(Map<String, dynamic> json) {
    return CryptoCurrentBalance(
      btcBalance: json['btcBalance'].toString(),
      ethBalance: json['ethBalance'].toString(),
      usdtBalance: json['usdtBalance'].toString(),
      aesBalance: json['aesBalance'].toString()
    );
  }
}