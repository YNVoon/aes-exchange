class CryptoCurrentBalance {
  final String btcBalance;
  final String ethBalance;
  final String usdtBalance;
  final String aesBalance;
  final String btcCurrentPrice;
  final String ethCurrentPrice;
  final String usdtCurrentPrice;
  final String aesCurrentPrice;
  final String btcPercentChange;
  final String ethPercentChange;
  final String usdtPercentChange;
  final String aesPercentChange;
  final String btcToUsdt;
  final String ethToUsdt;
  final String usdtToUsdt;
  final String aesToUsdt;
  final String totalAssetInUsdt;

  CryptoCurrentBalance({this.btcBalance, this.ethBalance, this.usdtBalance, this.aesBalance,
                        this.btcCurrentPrice, this.ethCurrentPrice, this.usdtCurrentPrice, this.aesCurrentPrice,
                        this.btcPercentChange, this.ethPercentChange, this.usdtPercentChange, this.aesPercentChange,
                        this.btcToUsdt, this.ethToUsdt, this.usdtToUsdt, this.aesToUsdt, this.totalAssetInUsdt});

  factory CryptoCurrentBalance.fromJson(Map<String, dynamic> json) {
    return CryptoCurrentBalance(
      btcBalance: json['btcBalance'].toString(),
      ethBalance: json['ethBalance'].toString(),
      usdtBalance: json['usdtBalance'].toString(),
      aesBalance: json['aesBalance'].toString(),
      btcCurrentPrice: json['btcCurrentPrice'].toString(),
      ethCurrentPrice: json['ethCurrentPrice'].toString(),
      usdtCurrentPrice: json['usdtCurrentPrice'].toString(),
      aesCurrentPrice: json['aesCurrentPrice'].toString(),
      btcPercentChange: json['btcPercentChange'].toString(),
      ethPercentChange: json['ethPercentChange'].toString(),
      usdtPercentChange: json['usdtPercentChange'].toString(),
      aesPercentChange: json['aesPercentChange'].toString(),
      btcToUsdt: json['btcToUsdt'].toString(),
      ethToUsdt: json['ethToUsdt'].toString(),
      usdtToUsdt: json['usdtToUsdt'].toString(),
      aesToUsdt: json['aesToUsdt'].toString(),
      totalAssetInUsdt: json['totalAssetInUsdt'].toString()
    );
  }
}