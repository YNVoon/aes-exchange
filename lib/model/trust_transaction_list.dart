// Trust Transaction List model
class TrustTransaction {
  String date;
  String time;
  String currencyType;
  double transactionAmount;
  bool isTransferIn = false;

  TrustTransaction(this.date, this.time, this.currencyType, this.transactionAmount, this.isTransferIn);
}