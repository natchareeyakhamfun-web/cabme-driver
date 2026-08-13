class SettingsModel {
  String? success;
  String? error;
  String? message;
  Data? data;

  SettingsModel({this.success, this.error, this.message, this.data});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? title;
  String? footer;
  String? email;
  String? websiteColor;
  String? driverappColor;
  String? adminpanelColor;
  String? adminpanelSecColor;
  String? appLogo;
  String? appLogoSmall;
  String? googleMapApiKey;
  String? isSocialMedia;
  String? driverRadios;
  String? userRideScheduleTimeMinute;
  String? tripAcceptRejectDriverTimeSec;
  String? showRideWithoutDestination;
  String? showRideOtp;
  String? showRideLater;
  String? deliveryDistance;
  String? appVersion;
  String? webVersion;
  String? contactUsAddress;
  String? contactUsPhone;
  String? contactUsEmail;
  String? minimumDepositAmount;
  String? minimumWithdrawalAmount;
  String? referralAmount;
  String? mapType;
  String? driverLocationUpdate;
  String? deliveryChargeParcel;
  String? parcelPerWeightCharge;
  String? creer;
  String? modifier;
  String? senderId;
  String? serviceJson;
  String? mapForApplication;
  String? homeScreenType;
  String? subscriptionModel;
  List<String>? activeServices;
  String? driverDocVerification;
  String? ownerDocVerification;
  PusherSettings? pusherSettings;
  String? currency;
  String? decimalDigit;
  String? symbolAtRight;
  List<Tax>? tax;
  AdminCommission? adminCommission;
  String? isDriverMaintenanceMode;
  String? defaultCountryCode;

  Data(
      {this.id,
      this.title,
      this.footer,
      this.email,
      this.websiteColor,
      this.driverappColor,
      this.adminpanelColor,
      this.adminpanelSecColor,
      this.appLogo,
      this.appLogoSmall,
      this.googleMapApiKey,
      this.isSocialMedia,
      this.driverRadios,
      this.userRideScheduleTimeMinute,
      this.tripAcceptRejectDriverTimeSec,
      this.showRideWithoutDestination,
      this.showRideOtp,
      this.showRideLater,
      this.deliveryDistance,
      this.appVersion,
      this.webVersion,
      this.contactUsAddress,
      this.contactUsPhone,
      this.contactUsEmail,
      this.minimumDepositAmount,
      this.minimumWithdrawalAmount,
      this.referralAmount,
      this.mapType,
      this.driverLocationUpdate,
      this.deliveryChargeParcel,
      this.parcelPerWeightCharge,
      this.creer,
      this.modifier,
      this.senderId,
      this.serviceJson,
      this.mapForApplication,
      this.homeScreenType,
      this.subscriptionModel,
      this.activeServices,
      this.driverDocVerification,
      this.ownerDocVerification,
      this.pusherSettings,
      this.currency,
      this.decimalDigit,
      this.symbolAtRight,
      this.tax,
      this.adminCommission,
      this.isDriverMaintenanceMode,
      this.defaultCountryCode});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    footer = json['footer'];
    email = json['email'];
    websiteColor = json['website_color'];
    driverappColor = json['driverapp_color'];
    adminpanelColor = json['adminpanel_color'];
    adminpanelSecColor = json['adminpanel_sec_color'];
    appLogo = json['app_logo'];
    appLogoSmall = json['app_logo_small'];
    googleMapApiKey = json['google_map_api_key'];
    isSocialMedia = json['is_social_media'];
    driverRadios = json['driver_radios'].toString();
    userRideScheduleTimeMinute = json['user_ride_schedule_time_minute'];
    tripAcceptRejectDriverTimeSec = json['trip_accept_reject_driver_time_sec'];
    showRideWithoutDestination = json['show_ride_without_destination'];
    showRideOtp = json['show_ride_otp'];
    showRideLater = json['show_ride_later'];
    deliveryDistance = json['delivery_distance'].toString();
    appVersion = json['app_version'];
    webVersion = json['web_version'];
    contactUsAddress = json['contact_us_address'];
    contactUsPhone = json['contact_us_phone'];
    contactUsEmail = json['contact_us_email'];
    minimumDepositAmount = json['minimum_deposit_amount'].toString();
    minimumWithdrawalAmount = json['minimum_withdrawal_amount'].toString();
    referralAmount = json['referral_amount'].toString();
    mapType = json['mapType'];
    driverLocationUpdate = json['driverLocationUpdate'].toString();
    deliveryChargeParcel = json['delivery_charge_parcel'];
    parcelPerWeightCharge = json['parcel_per_weight_charge'];
    creer = json['creer'];
    modifier = json['modifier'];
    senderId = json['senderId'];
    serviceJson = json['serviceJson'];
    mapForApplication = json['map_for_application'];
    homeScreenType = json['home_screen_type'];
    subscriptionModel = json['subscription_model'];
    activeServices = json['active_services'].cast<String>();
    driverDocVerification = json['driver_doc_verification'];
    ownerDocVerification = json['owner_doc_verification'];
    pusherSettings = json['pusher_settings'] != null ? PusherSettings.fromJson(json['pusher_settings']) : null;
    currency = json['currency'];
    decimalDigit = json['decimal_digit'];
    symbolAtRight = json['symbol_at_right'];
    if (json['tax'] != null) {
      tax = <Tax>[];
      json['tax'].forEach((v) {
        tax!.add(Tax.fromJson(v));
      });
    }
    adminCommission = json['admin_commission'] != null ? AdminCommission.fromJson(json['admin_commission']) : null;
    isDriverMaintenanceMode = json['is_driver_maintenance_mode'];
    defaultCountryCode = json['default_country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['footer'] = footer;
    data['email'] = email;
    data['website_color'] = websiteColor;
    data['driverapp_color'] = driverappColor;
    data['adminpanel_color'] = adminpanelColor;
    data['adminpanel_sec_color'] = adminpanelSecColor;
    data['app_logo'] = appLogo;
    data['app_logo_small'] = appLogoSmall;
    data['google_map_api_key'] = googleMapApiKey;
    data['is_social_media'] = isSocialMedia;
    data['driver_radios'] = driverRadios;
    data['user_ride_schedule_time_minute'] = userRideScheduleTimeMinute;
    data['trip_accept_reject_driver_time_sec'] = tripAcceptRejectDriverTimeSec;
    data['show_ride_without_destination'] = showRideWithoutDestination;
    data['show_ride_otp'] = showRideOtp;
    data['show_ride_later'] = showRideLater;
    data['delivery_distance'] = deliveryDistance;
    data['app_version'] = appVersion;
    data['web_version'] = webVersion;
    data['contact_us_address'] = contactUsAddress;
    data['contact_us_phone'] = contactUsPhone;
    data['contact_us_email'] = contactUsEmail;
    data['minimum_deposit_amount'] = minimumDepositAmount;
    data['minimum_withdrawal_amount'] = minimumWithdrawalAmount;
    data['referral_amount'] = referralAmount;
    data['mapType'] = mapType;
    data['driverLocationUpdate'] = driverLocationUpdate;
    data['delivery_charge_parcel'] = deliveryChargeParcel;
    data['parcel_per_weight_charge'] = parcelPerWeightCharge;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['senderId'] = senderId;
    data['serviceJson'] = serviceJson;
    data['map_for_application'] = mapForApplication;
    data['home_screen_type'] = homeScreenType;
    data['subscription_model'] = subscriptionModel;
    data['active_services'] = activeServices;
    data['driver_doc_verification'] = driverDocVerification;
    data['owner_doc_verification'] = ownerDocVerification;
    if (pusherSettings != null) {
      data['pusher_settings'] = pusherSettings!.toJson();
    }
    data['currency'] = currency;
    data['decimal_digit'] = decimalDigit;
    data['symbol_at_right'] = symbolAtRight;
    if (tax != null) {
      data['tax'] = tax!.map((v) => v.toJson()).toList();
    }
    if (adminCommission != null) {
      data['admin_commission'] = adminCommission!.toJson();
    }
    data['is_driver_maintenance_mode'] = isDriverMaintenanceMode;
    data['default_country_code'] = defaultCountryCode;
    return data;
  }
}

class PusherSettings {
  String? pusherAppId;
  String? pusherKey;
  String? pusherSecret;
  String? pusherCluster;

  PusherSettings({this.pusherAppId, this.pusherKey, this.pusherSecret, this.pusherCluster});

  PusherSettings.fromJson(Map<String, dynamic> json) {
    pusherAppId = json['pusher_app_id'];
    pusherKey = json['pusher_key'];
    pusherSecret = json['pusher_secret'];
    pusherCluster = json['pusher_cluster'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pusher_app_id'] = pusherAppId;
    data['pusher_key'] = pusherKey;
    data['pusher_secret'] = pusherSecret;
    data['pusher_cluster'] = pusherCluster;
    return data;
  }
}

class Tax {
  String? id;
  String? libelle;
  String? value;
  String? type;
  String? statut;
  String? country;
  String? creer;
  String? modifier;

  Tax({this.id, this.libelle, this.value, this.type, this.statut, this.country, this.creer, this.modifier});

  Tax.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    value = json['value'];
    type = json['type'];
    statut = json['statut'];
    country = json['country'];
    creer = json['creer'];
    modifier = json['modifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['value'] = value;
    data['type'] = type;
    data['statut'] = statut;
    data['country'] = country;
    data['creer'] = creer;
    data['modifier'] = modifier;
    return data;
  }
}

class AdminCommission {
  int? id;
  String? libelle;
  String? value;
  String? type;
  String? statut;
  String? creer;
  String? modifier;
  String? updatedAt;

  AdminCommission({this.id, this.libelle, this.value, this.type, this.statut, this.creer, this.modifier, this.updatedAt});

  AdminCommission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    value = json['value'];
    type = json['type'];
    statut = json['statut'];
    creer = json['creer'];
    modifier = json['modifier'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['value'] = value;
    data['type'] = type;
    data['statut'] = statut;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['updated_at'] = updatedAt;
    return data;
  }
}
