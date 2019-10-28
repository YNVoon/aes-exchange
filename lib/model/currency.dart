// Currency Model
// TODO: Get it from API
class Currency {
  String currencyName;
  double currencyCurrentValue;
  double currencyQuoteChange;
  String currencyLogoUrl;
  double equalityToUsdt;
  String currencyBalance = "0.000000";
  double equalityToUsdtTotal;
  String currencyBalanceTotal = "0.000000";

  Currency(this.currencyName, this.currencyCurrentValue, this.currencyQuoteChange, this.currencyLogoUrl, this.equalityToUsdt);
}