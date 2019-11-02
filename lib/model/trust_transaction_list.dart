// Trust Transaction List model
class TrustTransaction {
  String date;
  String time;
  String currencyType;
  var transactionAmount, day, year, month;
  bool isTransferIn = false;
  String status;
  String transactionId;

  TrustTransaction(this.date, this.time, this.currencyType, this.transactionAmount, this.isTransferIn, this.status, this.day, this.year, this.month, this.transactionId);
}