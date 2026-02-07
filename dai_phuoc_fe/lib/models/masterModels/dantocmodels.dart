class DanTocModel
{
  final String madantoc;
  final String tendantoc;
  final bool hide;

  DanTocModel({
    required this.madantoc,
    required this.tendantoc,
    required this.hide
  });

  factory DanTocModel.fromJson(Map<String, dynamic>json)
  {
    return DanTocModel(
      madantoc: json['madantoc'] ?? '',
      tendantoc: json['dantoc'] ?? '',
      hide: json['hide'] ?? false
    );
  }
}