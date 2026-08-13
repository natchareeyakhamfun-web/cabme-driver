class OwnerDashBoardModel {
  String? success;
  int? code;
  String? message;
  OwnerDashBoardData? data;

  OwnerDashBoardModel({this.success, this.code, this.message, this.data});

  OwnerDashBoardModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? OwnerDashBoardData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OwnerDashBoardData {
  String? totalDrivers;
  String? totalVehicles;
  String? totalBookings;
  String? totalEarnings;

  OwnerDashBoardData(
      {this.totalDrivers,
        this.totalVehicles,
        this.totalBookings,
        this.totalEarnings});

  OwnerDashBoardData.fromJson(Map<String, dynamic> json) {
    totalDrivers = json['total_drivers'];
    totalVehicles = json['total_vehicles'];
    totalBookings = json['total_bookings'];
    totalEarnings = json['total_earnings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_drivers'] = totalDrivers;
    data['total_vehicles'] = totalVehicles;
    data['total_bookings'] = totalBookings;
    data['total_earnings'] = totalEarnings;
    return data;
  }
}
