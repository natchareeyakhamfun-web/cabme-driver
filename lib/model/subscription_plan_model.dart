class SubscriptionPlanModel {
  String? success;
  String? error;
  String? message;
  List<SubscriptionPlanData>? data;

  SubscriptionPlanModel({this.success, this.error, this.message, this.data});

  SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SubscriptionPlanData>[];
      json['data'].forEach((v) {
        data!.add(SubscriptionPlanData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubscriptionPlanData {
  String? id;
  String? bookingLimit;
  String? vehicleLimit;
  String? driverLimit;
  String? dispatcherAccess;
  String? description;
  String? expiryDay;
  String? image;
  String? isEnable;
  String? name;
  String? place;
  List<String>? planPoints;
  String? price;
  String? type;
  String? createdAt;
  String? updatedAt;
  bool? status;

  SubscriptionPlanData(
      {this.id,
      this.bookingLimit,
      this.vehicleLimit,
      this.driverLimit,
      this.dispatcherAccess,
      this.description,
      this.expiryDay,
      this.image,
      this.isEnable,
      this.name,
      this.place,
      this.planPoints,
      this.price,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.status});

  SubscriptionPlanData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingLimit = json['bookingLimit'];
    vehicleLimit = json['vehicle_limit'];
    driverLimit = json['driver_limit'];
    dispatcherAccess = json['dispatcher_access'];
    description = json['description'];
    expiryDay = json['expiryDay'];
    image = json['image'];
    isEnable = json['isEnable'];
    name = json['name'];
    place = json['place'];
    planPoints = json['plan_points'].cast<String>();
    price = json['price'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bookingLimit'] = bookingLimit;
    data['vehicle_limit'] = vehicleLimit;
    data['driver_limit'] = driverLimit;
    data['dispatcher_access'] = dispatcherAccess;
    data['description'] = description;
    data['expiryDay'] = expiryDay;
    data['image'] = image;
    data['isEnable'] = isEnable;
    data['name'] = name;
    data['place'] = place;
    data['plan_points'] = planPoints;
    data['price'] = price;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    return data;
  }
}
