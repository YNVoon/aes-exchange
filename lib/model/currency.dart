// Currency Model
// TODO: Get it from API
class Currency {
  String currencyName;
  double currencyCurrentValue;
  double currencyQuoteChange;
  String currencyLogoUrl;
  double equalityToUsdt;

  Currency(this.currencyName, this.currencyCurrentValue, this.currencyQuoteChange, this.currencyLogoUrl, this.equalityToUsdt);
}