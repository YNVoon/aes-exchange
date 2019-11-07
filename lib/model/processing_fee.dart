class ProcessingFee {
  final double highProcessing;
  final double lowProcessing;
  var aesBalance;
  var ethBalance;
  final String status;
  var currentBalance;
  var processingFee;

  ProcessingFee({this.highProcessing, this.lowProcessing, this.aesBalance, this.ethBalance, this.status, this.processingFee, this.currentBalance});

  factory ProcessingFee.fromJson(Map<String, dynamic> json) {
    return ProcessingFee(
      highProcessing: json['highProcessing'],
      lowProcessing: json['lowProcessing'],
      aesBalance: json['aesBalance'],
      ethBalance: json['ethBalance'],
      status: json['status'],
      processingFee: json['processingFee'],
      currentBalance: json['currentBalance']
    );
  }
}