import 'package:cabme_driver/model/settings_model.dart';
import 'package:cabme_driver/model/subscription_plan_model.dart';

class UserModel {
  String? success;
  String? error;
  String? message;
  UserData? userData;

  UserModel({this.success, this.error, this.message, this.userData});

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    error = json['error'].toString();
    message = json['message'].toString();
    userData = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (userData != null) {
      data['data'] = userData!.toJson();
    }
    return data;
  }
}

class UserData {
  String? id;
  String? nom;
  String? prenom;
  String? cnib;
  String? countryCode;
  String? countryISOCode;
  String? phone;
  String? latitude;
  String? longitude;
  String? rotation;
  String? email;
  String? statut;
  String? statutLicence;
  String? statutNic;
  String? statutVehicule;
  String? isVerified;
  String? statutCarServiceBook;
  String? statutRoadWorthy;
  String? statusCarImage;
  String? online;
  String? loginType;
  String? photo;
  String? photoPath;
  String? photoLicence;
  String? photoLicencePath;
  String? photoNic;
  String? photoNicPath;
  String? photoCarServiceBook;
  String? photoCarServiceBookPath;
  String? photoRoadWorthy;
  String? photoRoadWorthyPath;
  String? tonotify;
  String? deviceId;
  String? fcmId;

  String? creer;
  String? modifier;
  String? updatedAt;
  String? amount;
  String? resetPasswordOtp;
  String? resetPasswordOtpModifier;
  String? deletedAt;
  String? userCat;
  String? country;
  String? brand;
  String? model;
  String? color;
  String? numberplate;
  String? accesstoken;
  List<dynamic>? serviceType;

  String? subscriptionPlanId;
  String? subscriptionExpiryDate;
  String? subscriptionTotalOrders;
  SubscriptionPlanData? subscriptionPlan;
  AdminCommission? adminCommission;

  String? companyName;
  String? role;
  String? isOwner;
  String? ownerId;
  String? vehicleId;
  String? vehicleTypeId;
  List<dynamic>? zoneId;

  String? subscriptionTotalVehicle;
  String? subscriptionTotalDriver;

  UserData(
      {this.id,
      this.nom,
      this.prenom,
      this.cnib,
      this.phone,
      this.countryCode,
      this.countryISOCode,
      this.latitude,
      this.longitude,
      this.rotation,
      this.email,
      this.statut,
      this.statutLicence,
      this.statutNic,
      this.statutVehicule,
      this.isVerified,
      this.statutCarServiceBook,
      this.statutRoadWorthy,
      this.statusCarImage,
      this.online,
      this.loginType,
      this.photo,
      this.photoPath,
      this.photoLicence,
      this.photoLicencePath,
      this.photoNic,
      this.photoNicPath,
      this.photoCarServiceBook,
      this.photoCarServiceBookPath,
      this.photoRoadWorthy,
      this.photoRoadWorthyPath,
      this.tonotify,
      this.deviceId,
      this.fcmId,
      this.creer,
      this.modifier,
      this.updatedAt,
      this.amount,
      this.resetPasswordOtp,
      this.resetPasswordOtpModifier,
      this.deletedAt,
      this.userCat,
      this.country,
      this.brand,
      this.model,
      this.color,
      this.numberplate,
      this.accesstoken,
      this.serviceType,
      this.subscriptionPlanId,
      this.subscriptionExpiryDate,
      this.subscriptionTotalOrders,
      this.subscriptionPlan,
      this.adminCommission,
      this.ownerId,
      this.vehicleId,
      this.companyName,
      this.isOwner,
      this.role,
      this.zoneId,
      this.subscriptionTotalVehicle,
      this.subscriptionTotalDriver,
      this.vehicleTypeId});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    nom = json['nom'].toString();
    prenom = json['prenom'].toString();
    cnib = json['cnib'].toString();
    phone = json['phone'].toString();
    countryCode = json['country_code'].toString();
    countryISOCode = json['countryISOCode'];
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    rotation = json['rotation'].toString();
    email = json['email'].toString();
    statut = json['statut'].toString();
    statutLicence = json['statut_licence'].toString();
    statutNic = json['statut_nic'].toString();
    statutVehicule = json['statut_vehicule'].toString();
    isVerified = json['is_verified'].toString();
    statutCarServiceBook = json['statut_car_service_book'].toString();
    statutRoadWorthy = json['statut_road_worthy'].toString();
    statusCarImage = json['status_car_image'].toString();
    online = json['online'].toString();
    loginType = json['login_type'].toString();
    photo = json['photo'].toString();
    photoPath = json['photo_path'] ?? '';
    photoLicence = json['photo_licence'].toString();
    photoLicencePath = json['photo_licence_path'].toString();
    photoNic = json['photo_nic'].toString();
    photoNicPath = json['photo_nic_path'].toString();
    photoCarServiceBook = json['photo_car_service_book'].toString();
    photoCarServiceBookPath = json['photo_car_service_book_path'].toString();
    photoRoadWorthy = json['photo_road_worthy'].toString();
    photoRoadWorthyPath = json['photo_road_worthy_path'].toString();
    tonotify = json['tonotify'].toString();
    deviceId = json['device_id'].toString();
    fcmId = json['fcm_id'].toString();
    creer = json['creer'].toString();
    modifier = json['modifier'].toString();
    updatedAt = json['updated_at'].toString();
    amount = json['amount'] ?? '0';
    resetPasswordOtp = json['reset_password_otp'].toString();
    resetPasswordOtpModifier = json['reset_password_otp_modifier'].toString();
    deletedAt = json['deleted_at'].toString();
    userCat = json['user_cat'].toString();
    country = json['country'].toString();
    brand = json['brand'].toString();
    model = json['model'].toString();
    color = json['color'].toString();
    numberplate = json['numberplate'].toString();
    accesstoken = json['accesstoken'].toString();
    serviceType = json['service_type'] ?? [];
    adminCommission = json['adminCommission'] != null ? AdminCommission.fromJson(json['adminCommission']) : null;
    subscriptionPlanId = json['subscriptionPlanId'];
    subscriptionExpiryDate = json['subscriptionExpiryDate'];
    subscriptionTotalOrders = json['subscriptionTotalOrders'];
    subscriptionPlan = json['subscription_plan'] != null ? SubscriptionPlanData.fromJson(json['subscription_plan']) : null;

    ownerId = json['ownerId'];
    vehicleId = json['vehicle_id'];
    companyName = json['companyName'];
    role = json['role'];
    isOwner = json['isOwner'];
    zoneId = json['zone_id'] ?? [];

    subscriptionTotalVehicle = json['subscriptionTotalVehicle'] ?? '0';
    subscriptionTotalDriver = json['subscriptionTotalDriver'] ?? '0';
    vehicleTypeId = json['id_type_vehicule'] ?? '0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['cnib'] = cnib;
    data['country_code'] = countryCode;
    data['countryISOCode'] = countryISOCode;
    data['phone'] = phone;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['rotation'] = rotation;
    data['email'] = email;
    data['statut'] = statut;
    data['statut_licence'] = statutLicence;
    data['statut_nic'] = statutNic;
    data['statut_vehicule'] = statutVehicule;
    data['is_verified'] = isVerified;
    data['statut_car_service_book'] = statutCarServiceBook;
    data['statut_road_worthy'] = statutRoadWorthy;
    data['status_car_image'] = statusCarImage;
    data['online'] = online;
    data['login_type'] = loginType;
    data['photo'] = photo;
    data['photo_path'] = photoPath;
    data['photo_licence'] = photoLicence;
    data['photo_licence_path'] = photoLicencePath;
    data['photo_nic'] = photoNic;
    data['photo_nic_path'] = photoNicPath;
    data['photo_car_service_book'] = photoCarServiceBook;
    data['photo_car_service_book_path'] = photoCarServiceBookPath;
    data['photo_road_worthy'] = photoRoadWorthy;
    data['photo_road_worthy_path'] = photoRoadWorthyPath;
    data['tonotify'] = tonotify;
    data['device_id'] = deviceId;
    data['fcm_id'] = fcmId;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['updated_at'] = updatedAt;
    data['amount'] = amount;
    data['reset_password_otp'] = resetPasswordOtp;
    data['reset_password_otp_modifier'] = resetPasswordOtpModifier;
    data['deleted_at'] = deletedAt;
    data['user_cat'] = userCat;
    data['country'] = country;
    data['brand'] = brand;
    data['model'] = model;
    data['color'] = color;
    data['numberplate'] = numberplate;
    data['accesstoken'] = accesstoken;
    data['service_type'] = serviceType;
    data['subscriptionPlanId'] = subscriptionPlanId;
    data['subscriptionExpiryDate'] = subscriptionExpiryDate;
    data['subscriptionTotalOrders'] = subscriptionTotalOrders;
    if (subscriptionPlan != null) {
      data['subscription_plan'] = subscriptionPlan!.toJson();
    }
    if (adminCommission != null) {
      data['adminCommission'] = adminCommission!.toJson();
    }

    data['ownerId'] = ownerId;
    data['vehicleId'] = vehicleId;
    data['companyName'] = companyName;
    data['role'] = role;
    data['isOwner'] = isOwner;
    data['zone_id'] = zoneId;

    data['subscriptionTotalVehicle'] = subscriptionTotalVehicle;
    data['subscriptionTotalDriver'] = subscriptionTotalDriver;
    data['id_type_vehicule'] = vehicleTypeId;
    return data;
  }
}
