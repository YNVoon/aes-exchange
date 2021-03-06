class TransferTrustFeesAndAmount {
  final String btcBalance;
  final String ethBalance;
  final String aesBalance;
  final String usdtBalance;
  final String withdrawalProcessingFeeRate;
  final String aesWithdrawalProcessingFeeRate;

  TransferTrustFeesAndAmount({this.btcBalance, this.ethBalance, this.aesBalance, this.usdtBalance, this.withdrawalProcessingFeeRate, this.aesWithdrawalProcessingFeeRate});

  factory TransferTrustFeesAndAmount.fromJson(Map<String, dynamic> json) {
    return TransferTrustFeesAndAmount(
      btcBalance: json['btcBalance'].toString(),
      ethBalance: json['ethBalance'].toString(),
      aesBalance: json['aesBalance'].toString(),
      usdtBalance: json['usdtBalance'].toString(),
      withdrawalProcessingFeeRate: json['withdrawalProcessingFeeRate'].toString(),
      aesWithdrawalProcessingFeeRate: json['aesWithdrawalProcessingFeeRate'].toString()
    );
  }
}