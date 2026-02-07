class UserResponse {
  final int id;
  final String hoTen;
  final String soCMND;
  final String sdt;
  final DateTime? ngaySinh;
  final String phai;
  final String danToc;
  final String quocTich;
  final String tinhThanh;
  final String phuongXa;

  UserResponse({
    required this.id,
    required this.hoTen,
    required this.soCMND,
    required this.sdt,
    this.ngaySinh,
    required this.phai,
    required this.danToc,
    required this.quocTich,
    required this.tinhThanh,
    required this.phuongXa
  });

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'hoten': hoTen,
      'socmnd': soCMND,
      'sdt': sdt,
      'ngaysinh':ngaySinh != null ? ngaySinh!.toIso8601String() : DateTime.now().toIso8601String(),
      'phai':phai,
      'dantoc':danToc,
      'quoctich': quocTich,
      'tinhthanh':tinhThanh,
      'phuongxa':phuongXa
    };
  }

  factory UserResponse.fromJson(Map<String, dynamic> json)
  {
    return UserResponse(
      id: json['id'] ?? 0,
      hoTen: json['hoten'] ?? '',
      soCMND: json['socmnd'] ?? '',
      sdt: json['sdt'] ?? '',
      ngaySinh: DateTime.parse(json['ngaysinh']),
      phai: json['phai'] ?? '',
      danToc: json['dantoc'] ?? '',
      quocTich: json['quoctich'] ?? '',
      tinhThanh: json['tinhthanh'] ?? '',
      phuongXa: json['phuongxa'] ?? ''
    );
  }
}