class TransferTrustFeesAndAmount {
  final String btcBalance;
  final String ethBalance;
  final String aesBalance;
  final String usdtBalance;

  TransferTrustFeesAndAmount({this.btcBalance, this.ethBalance, this.aesBalance, this.usdtBalance});

  factory TransferTrustFeesAndAmount.fromJson(Map<String, dynamic> json) {
    return TransferTrustFeesAndAmount(
      btcBalance: json['btcBalance'].toString(),
      ethBalance: json['ethBalance'].toString(),
      aesBalance: json['aesBalance'].toString(),
      usdtBalance: json['usdtBalance'].toString()
    );
  }
}