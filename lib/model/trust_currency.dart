// Currency Model
// TODO: Get it from API
class TrustCurrency {
  String currencyName;
  double currencyCurrentValue;
  // double currencyQuoteChange;
  String currencyLogoUrl;
  double equalityToUsdt;
  String currencyBalance; // you have how many btc? how many eth? ...
  double equalityToUsdtTotal;
  String currencyBalanceTotal = "0.000000";

  TrustCurrency(this.currencyName, this.currencyCurrentValue, this.currencyBalance, this.currencyLogoUrl, this.equalityToUsdt);
}