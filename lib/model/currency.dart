// Currency Model
// TODO: Get it from API
class Currency {
  final String currencyName;
  final double currencyCurrentValue;
  final double currencyQuoteChange;
  final String currencyLogoUrl;

  Currency(this.currencyName, this.currencyCurrentValue, this.currencyQuoteChange, this.currencyLogoUrl);
}