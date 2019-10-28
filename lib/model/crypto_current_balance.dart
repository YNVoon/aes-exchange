class CryptoCurrentBalance {
  final String btcBalance; //Available Balance
  final String ethBalance;
  final String usdtBalance;
  final String aesBalance;
  final String totalBtcBalance;
  final String totalEthBalance;
  final String totalUsdtBalance;
  final String totalAesBalance;
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
  final String totalBtcToUsdt;
  final String totalEthToUsdt;
  final String totalUsdtToUsdt;
  final String totalAesToUsdt;
  final String totalAssetInUsdt;

  CryptoCurrentBalance({this.btcBalance, this.ethBalance, this.usdtBalance, this.aesBalance,
                        this.btcCurrentPrice, this.ethCurrentPrice, this.usdtCurrentPrice, this.aesCurrentPrice,
                        this.btcPercentChange, this.ethPercentChange, this.usdtPercentChange, this.aesPercentChange,
                        this.btcToUsdt, this.ethToUsdt, this.usdtToUsdt, this.aesToUsdt, this.totalAssetInUsdt,
                        this.totalBtcBalance, this.totalEthBalance, this.totalUsdtBalance, this.totalAesBalance,
                        this.totalBtcToUsdt, this.totalEthToUsdt, this.totalUsdtToUsdt, this.totalAesToUsdt});

  factory CryptoCurrentBalance.fromJson(Map<String, dynamic> json) {
    return CryptoCurrentBalance(
      btcBalance: json['btcBalance'].toString(),
      ethBalance: json['ethBalance'].toString(),
      usdtBalance: json['usdtBalance'].toString(),
      aesBalance: json['aesBalance'].toString(),
      totalBtcBalance: json['totalBtcBalance'].toString(),
      totalEthBalance: json['totalEthBalance'].toString(),
      totalUsdtBalance: json['totalUsdtBalance'].toString(),
      totalAesBalance: json['totalAesBalance'].toString(),
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
      totalBtcToUsdt: json['totalBtcToUsdt'].toString(),
      totalEthToUsdt: json['totalEthToUsdt'].toString(),
      totalUsdtToUsdt: json['totalUsdtToUsdt'].toString(),
      totalAesToUsdt: json['totalAesToUsdt'].toString(),
      totalAssetInUsdt: json['totalAssetInUsdt'].toString()
    );
  }
}