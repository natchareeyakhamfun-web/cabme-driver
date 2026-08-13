

import 'package:cabme_driver/model/admin_commission.dart';
import 'package:cabme_driver/model/booking_mode.dart';
import 'package:cabme_driver/model/rental_package_model.dart';
import 'package:cabme_driver/model/tax_model.dart';

class RentalBookingModel {
  String? success;
  int? code;
  String? message;
  List<RentalBookingData>? data;

  RentalBookingModel({this.success, this.code, this.message, this.data});

  RentalBookingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RentalBookingData>[];
      json['data'].forEach((v) {
        data!.add(RentalBookingData.fromJson(v));
      });
    }  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RentalBookingData {
  String? id;
  String? bookingNumber;
  String? idUserApp;
  String? idConducteur;
  String? departName;
  String? latSource;
  String? lngSource;
  String? status;
  String? paymentStatus;
  String? idRentalPackage;
  String? idVehicleType;
  String? idPaymentMethod;
  String? distanceUnit;
  String? amount;
  String? discount;
  AdminCommission? discountType;
  List<TaxModel>? tax;
  String? adminCommission;
  AdminCommission? adminCommissionType;
  String? transactionId;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? otp;
  String? currentKm;
  String? completeKm;
  String? createdAt;
  String? updatedAt;
  String? paymentMethod;
  String? vehicleName;
  String? vehicleImage;
  RentalPackageData? packageDetails;
  Driver? driver;
  User? user;
  ComplainDetails? complainDetails;
  bool? complaint;

  RentalBookingData(
      {this.id,
        this.bookingNumber,
        this.idUserApp,
        this.idConducteur,
        this.departName,
        this.latSource,
        this.lngSource,
        this.status,
        this.paymentStatus,
        this.idRentalPackage,
        this.idVehicleType,
        this.idPaymentMethod,
        this.distanceUnit,
        this.amount,
        this.discount,
        this.discountType,
        this.tax,
        this.adminCommission,
        this.adminCommissionType,
        this.transactionId,
        this.startDate,
        this.endDate,
        this.startTime,
        this.endTime,
        this.otp,
        this.currentKm,
        this.completeKm,
        this.createdAt,
        this.updatedAt,
        this.paymentMethod,
        this.vehicleName,
        this.vehicleImage,
        this.packageDetails,
        this.driver,
        this.user,this.complaint,
        this.complainDetails});

  RentalBookingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingNumber = json['booking_number'];
    idUserApp = json['id_user_app'];
    idConducteur = json['id_conducteur'];
    departName = json['depart_name'];
    latSource = json['lat_source'];
    lngSource = json['lng_source'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    idRentalPackage = json['id_rental_package'];
    idVehicleType = json['id_vehicle_type'];
    idPaymentMethod = json['id_payment_method'];
    distanceUnit = json['distance_unit'];
    amount = json['amount'];
    discount = json['discount'];
    discountType = json['discount_type'] != null
        ? AdminCommission.fromJson(json['discount_type'])
        : null;
    if (json['tax'] != null) {
      tax = <TaxModel>[];
      json['tax'].forEach((v) {
        tax!.add(TaxModel.fromJson(v));
      });
    }
    adminCommission = json['admin_commission'];
    adminCommissionType = json['admin_commission_type'] != null
        ? AdminCommission.fromJson(json['admin_commission_type'])
        : null;
    transactionId = json['transaction_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    otp = json['otp'];
    currentKm = json['current_km'];
    completeKm = json['complete_km'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paymentMethod = json['payment_method'];
    vehicleName = json['vehicle_name'];
    vehicleImage = json['vehicle_image'];
    packageDetails = json['package_details'] != null
        ? RentalPackageData.fromJson(json['package_details'])
        : null;
    driver =
    json['driver'] != null ? Driver.fromJson(json['driver']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    complainDetails = json['complaint_detail'] != null ? ComplainDetails.fromJson(json['complaint_detail']) : null;
    complaint = json['complaint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_number'] = bookingNumber;
    data['id_user_app'] = idUserApp;
    data['id_conducteur'] = idConducteur;
    data['depart_name'] = departName;
    data['lat_source'] = latSource;
    data['lng_source'] = lngSource;
    data['status'] = status;
    data['payment_status'] = paymentStatus;
    data['id_rental_package'] = idRentalPackage;
    data['id_vehicle_type'] = idVehicleType;
    data['id_payment_method'] = idPaymentMethod;
    data['distance_unit'] = distanceUnit;
    data['amount'] = amount;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    if (tax != null) {
      data['tax'] = tax!.map((v) => v.toJson()).toList();
    }
    data['admin_commission'] = adminCommission;
    if (adminCommissionType != null) {
      data['admin_commission_type'] = adminCommissionType!.toJson();
    }
    data['transaction_id'] = transactionId;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['otp'] = otp;
    data['current_km'] = currentKm;
    data['complete_km'] = completeKm;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['payment_method'] = paymentMethod;
    data['vehicle_name'] = vehicleName;
    data['vehicle_image'] = vehicleImage;
    if (packageDetails != null) {
      data['package_details'] = packageDetails!.toJson();
    }
    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (complainDetails != null) {
      data['complaint_detail'] = complainDetails!.toJson();
    }
    data['complaint'] = complaint;
    return data;
  }
}

