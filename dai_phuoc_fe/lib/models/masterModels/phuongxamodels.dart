class PhuongXaModel
{
  final String maphuongxa;
  final String tenphuongxa;
  final bool hide;

  PhuongXaModel({
    required this.maphuongxa,
    required this.tenphuongxa,
    required this.hide
  });

  factory PhuongXaModel.fromJson(Map<String,dynamic> json){
    return PhuongXaModel(
      maphuongxa: json['maphuongxa'] ?? '',
      tenphuongxa: json['tenphuongxa'] ?? '',
      hide: json['hide'] ?? false
    );
  }
}