// Trust Transaction List model
class TransactionRecord {
  String date;
  String time;
  String typeOfTransaction;
  var transactionAmount, day, year, month;
  bool isTransferIn = false;
  String status;
  String transactionId;

  TransactionRecord(this.date, this.time, this.typeOfTransaction, this.transactionAmount, this.isTransferIn, this.status, this.day, this.year, this.month, this.transactionId);
}