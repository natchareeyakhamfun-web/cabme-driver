class SubscriptionHistoryModel {
  String? success;
  String? error;
  String? message;
  List<SubscriptionData>? data;

  SubscriptionHistoryModel({this.success, this.error, this.message, this.data});

  SubscriptionHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SubscriptionData>[];
      json['data'].forEach((v) {
        data!.add(SubscriptionData.fromJson(v));
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

class  SubscriptionData {
  String? id;
  String? expiryDate;
  String? paymentType;
  String? paymentMethod;
  SubscriptionPlan? subscriptionPlan;
  String? userId;
  String? subscriptionPlanId;
  String? createdAt;
  String? updatedAt;
  String? status;

  SubscriptionData(
      {this.id,
        this.expiryDate,
        this.paymentType,
        this.subscriptionPlan,
        this.userId,
        this.subscriptionPlanId,
        this.createdAt,
        this.updatedAt,this.paymentMethod,this.status,});

  SubscriptionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expiryDate = json['expiry_date'];
    paymentType = json['payment_type'];
    subscriptionPlan = json['subscription_plan'] != null
        ? SubscriptionPlan.fromJson(json['subscription_plan'])
        : null;
    userId = json['user_id'];
    subscriptionPlanId = json['subscriptionPlanId'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paymentMethod = json['payment_method'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['expiry_date'] = expiryDate;
    data['payment_type'] = paymentType;
    if (subscriptionPlan != null) {
      data['subscription_plan'] = subscriptionPlan!.toJson();
    }
    data['user_id'] = userId;
    data['subscriptionPlanId'] = subscriptionPlanId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['payment_method'] = paymentMethod;
    data['status'] = status;
    return data;
  }
}

class SubscriptionPlan {
  String? id;
  String? name;
  String? type;
  String? image;
  String? place;
  String? price;
  String? isEnable;
  String? expiryDay;
  String? createdAt;
  String? updatedAt;
  String? description;
  List<String>? planPoints;
  String? bookingLimit;

  SubscriptionPlan(
      {this.id,
        this.name,
        this.type,
        this.image,
        this.place,
        this.price,
        this.isEnable,
        this.expiryDay,
        this.createdAt,
        this.updatedAt,
        this.description,
        this.planPoints,
        this.bookingLimit});

  SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    image = json['image'];
    place = json['place'];
    price = json['price'];
    isEnable = json['isEnable'];
    expiryDay = json['expiryDay'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    description = json['description'];
    planPoints = json['plan_points'].cast<String>();
    bookingLimit = json['bookingLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['image'] = image;
    data['place'] = place;
    data['price'] = price;
    data['isEnable'] = isEnable;
    data['expiryDay'] = expiryDay;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['description'] = description;
    data['plan_points'] = planPoints;
    data['bookingLimit'] = bookingLimit;
    return data;
  }
}
