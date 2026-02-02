class RotationModel 
{
  final String accessToken;
  final String refreshToken;
  final String? ipAddress;
  final String? deviceId;

  RotationModel({
    required this.accessToken,
    required this.refreshToken,
    this.deviceId,
    this.ipAddress
  });

  Map<String, dynamic> toJson(){
    return {
      "refreshToken": refreshToken,
      "accessToken": accessToken,
      "ipAddress": ipAddress ?? "",
      "deviceId": deviceId ?? ""
    };
  }
}