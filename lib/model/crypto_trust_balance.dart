class CryptoTrustBalance {
  final String btcTrustBalance;
  final String ethTrustBalance;
  final String usdtTrustBalance;
  final String aesTrustBalance;
  final String btcCurrentPrice;
  final String ethCurrentPrice;
  final String usdtCurrentPrice;
  final String aesCurrentPrice;
  final String btcTrustToUsdt;
  final String ethTrustToUsdt;
  final String usdtTrustToUsdt;
  final String aesTrustToUsdt;
  final String totalAssetInUsdt;

  CryptoTrustBalance({
    this.btcTrustBalance,
    this.ethTrustBalance,
    this.usdtTrustBalance,
    this.aesTrustBalance,
    this.btcCurrentPrice,
    this.ethCurrentPrice,
    this.usdtCurrentPrice,
    this.aesCurrentPrice,
    this.btcTrustToUsdt,
    this.ethTrustToUsdt,
    this.usdtTrustToUsdt,
    this.aesTrustToUsdt,
    this.totalAssetInUsdt
  });

  factory CryptoTrustBalance.fromJson(Map<String, dynamic> json) {
    return CryptoTrustBalance(
      btcTrustBalance: json['btcTrustBalance'].toString(),
      ethTrustBalance: json['ethTrustBalance'].toString(),
      usdtTrustBalance: json['usdtTrustBalance'].toString(),
      aesTrustBalance: json['aesTrustBalance'].toString(),
      btcCurrentPrice: json['btcCurrentPrice'].toString(),
      ethCurrentPrice: json['ethCurrentPrice'].toString(),
      usdtCurrentPrice: json['usdtCurrentPrice'].toString(),
      aesCurrentPrice: json['aesCurrentPrice'].toString(),
      btcTrustToUsdt: json['btcTrustToUsdt'].toString(),
      ethTrustToUsdt: json['ethTrustToUsdt'].toString(),
      usdtTrustToUsdt: json['usdtTrustToUsdt'].toString(),
      aesTrustToUsdt: json['aesTrustToUsdt'].toString(),
      totalAssetInUsdt: json['totalAssetInUsdt'].toString()
    );
  }

}