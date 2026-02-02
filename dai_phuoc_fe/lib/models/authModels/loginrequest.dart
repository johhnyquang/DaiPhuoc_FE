class LoginRequest 
{
  final String cccd;
  final String password;
  final String? ipAddress;
  final String? deviceId;

  LoginRequest({
    required this.cccd,
    required this.password,
    this.ipAddress,
    this.deviceId
  });

  Map<String, dynamic> toJson(){
    return{
      "cccd": cccd,
      "password": password,
      "ipAddress": ipAddress??"",
      "deviceId": deviceId??""
    };
  }
}