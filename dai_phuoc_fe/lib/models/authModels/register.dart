class Register
{
  final String cccd;
  final String hoten;
  final String sdt;
  final String password;
  final DateTime? ngaysinh;
  final bool phai;
  final String quoctich;
  final String dantoc;
  final String tinhthanh;
  final String phuongxa;
  final String? email;
  final String? ipAddress;
  final String? deviceId;

  Register({
    required this.cccd,
    required this.hoten,
    required this.sdt,
    required this.password,
    this.ngaysinh,
    required this.phai,
    required this.quoctich,
    required this.dantoc,
    required this.tinhthanh,
    required this.phuongxa,
    this.email,
    this.ipAddress,
    this.deviceId
  });  

  Map<String, dynamic> toJson(){
    return{
        "cccd": cccd,
        "hoten": hoten,
        "sdt": sdt,
        "password": password,
        "ngaySinh": ngaysinh?.toIso8601String(),
        "phai": phai,
        "quocTich": quoctich,
        "danToc": dantoc,
        "tinhThanh": tinhthanh,
        "phuongXa": phuongxa,
        "email": email?? "",
        "ipAddress": ipAddress??"",
        "deviceId":deviceId??"" 
    };
  }
}