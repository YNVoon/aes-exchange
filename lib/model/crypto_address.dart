class CryptoAddress {
  final String privateKey;
  final String address;

  CryptoAddress({this.privateKey, this.address});

  factory CryptoAddress.fromJson(Map<String, dynamic> json) {
    return CryptoAddress(
      privateKey: json['private'],
      address: json['address'],
    );
  }
}