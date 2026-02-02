class QuocGiaModel{
  final String maquocgia;
  final String tenquocgia;

  QuocGiaModel({
    required this.maquocgia,
    required this. tenquocgia
  });

  factory QuocGiaModel.fromJson(Map<String, dynamic>json){
    return QuocGiaModel(
      maquocgia: json['maQuocGia'] ?? '',
      tenquocgia: json['tenQuocGia'] ?? ''
    );
  }
}