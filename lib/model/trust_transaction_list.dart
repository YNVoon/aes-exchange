// Trust Transaction List model
class TrustTransaction {
  String date;
  String time;
  String currencyType;
  var transactionAmount;
  bool isTransferIn = false;
  String status;

  TrustTransaction(this.date, this.time, this.currencyType, this.transactionAmount, this.isTransferIn, this.status);
}