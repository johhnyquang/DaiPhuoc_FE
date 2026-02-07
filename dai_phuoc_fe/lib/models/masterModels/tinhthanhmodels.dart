class TinhThanhModel{
  final String matinhthanh;
  final String tentinhthanh;
  final bool hide;

  TinhThanhModel({
    required this.matinhthanh,
    required this.tentinhthanh,
    required this.hide
  });

  factory TinhThanhModel.fromJson(Map<String,dynamic> json)
  {
    return TinhThanhModel(
      matinhthanh: json['matinhthanh'] ?? '',
      tentinhthanh: json['tentinhthanh'] ?? '',
      hide: json['hide'] ?? ''
    );
  }
}