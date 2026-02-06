class PropertyTaxSearchResponse {
  final int result;
  final String message;
  final List<Map<String, dynamic>>? data;

  PropertyTaxSearchResponse({
    required this.result,
    required this.message,
    this.data,
  });

  factory PropertyTaxSearchResponse.fromJson(Map<String, dynamic> json) {
    return PropertyTaxSearchResponse(
      result: _parseResult(json['Result']),
      message: json['Msg']?.toString() ?? '',
      data: json['Data'] != null
          ? List<Map<String, dynamic>>.from(json['Data'])
          : null,
    );
  }

  /// 🔹 SAFE parser
  static int _parseResult(dynamic value) {
    if (value == null) return -1;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? -1;
    return -1;
  }
}
