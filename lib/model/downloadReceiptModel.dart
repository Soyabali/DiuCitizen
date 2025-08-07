
class DownloadReceiptModel {
  final String sReceiptURL;
  final String sReceiptCode;
  final double fReceiptAmount;
  final String dReceiptDate;

  DownloadReceiptModel({
    required this.sReceiptURL,
    required this.sReceiptCode,
    required this.fReceiptAmount,
    required this.dReceiptDate
  });

  // Factory method to create a Transaction from JSON
  factory DownloadReceiptModel.fromJson(Map<String, dynamic> json) {
    return DownloadReceiptModel(
      sReceiptURL: json['sReceiptURL'],
      sReceiptCode: json['sReceiptCode'],
      fReceiptAmount: json['fReceiptAmount'],
      dReceiptDate : json['dReceiptDate']
    );
  }
  // Method to convert a Transaction instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'sReceiptURL': sReceiptURL,
      'sReceiptCode': sReceiptCode,
      'fReceiptAmount': fReceiptAmount,
      'dReceiptDate': dReceiptDate
    };
  }
}
