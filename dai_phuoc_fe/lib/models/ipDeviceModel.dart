class IpDeviceModel {
  final String ipAddress;
  final String deviceId;

  IpDeviceModel({
    required this.ipAddress,
    required this.deviceId
  });

  factory IpDeviceModel.fromJson(Map<String, dynamic> json) {
    return IpDeviceModel(
      ipAddress: json['ipAddress'],
      deviceId: json['deviceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ipAddress': ipAddress,
      'deviceId': deviceId,
    };
  }
}