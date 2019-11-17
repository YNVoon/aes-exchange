class TransferTrustFeesAndAmount {
  final String btcBalance;
  final String ethBalance;
  final String aesBalance;
  final String usdtBalance;
  final String withdrawalProcessingFeeRate;

  TransferTrustFeesAndAmount({this.btcBalance, this.ethBalance, this.aesBalance, this.usdtBalance, this.withdrawalProcessingFeeRate});

  factory TransferTrustFeesAndAmount.fromJson(Map<String, dynamic> json) {
    return TransferTrustFeesAndAmount(
      btcBalance: json['btcBalance'].toString(),
      ethBalance: json['ethBalance'].toString(),
      aesBalance: json['aesBalance'].toString(),
      usdtBalance: json['usdtBalance'].toString(),
      withdrawalProcessingFeeRate: json['withdrawalProcessingFeeRate'].toString()
    );
  }
}