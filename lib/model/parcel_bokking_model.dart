import 'package:cabme_driver/model/admin_commission.dart';
import 'package:cabme_driver/model/booking_mode.dart';
import 'package:cabme_driver/model/tax_model.dart';

class ParcelBookingModel {
  String? success;
  int? code;
  String? message;
  ParcelBookingData? data;

  ParcelBookingModel({this.success, this.code, this.message, this.data});

  ParcelBookingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? ParcelBookingData.fromJson(json['data']) : null;
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

class ParcelBookingData {
  String? id;
  String? bookingNumber;
  String? idUserApp;
  String? idConducteur;
  String? source;
  String? destination;
  String? latSource;
  String? lngSource;
  String? latDestination;
  String? lngDestination;
  String? senderName;
  String? senderPhone;
  String? receiverName;
  String? receiverPhone;
  String? parcelWeight;
  String? parcelDimension;
  List<String>? parcelImage;
  String? parcelType;
  String? parcelDate;
  String? parcelTime;
  String? receiveDate;
  String? receiveTime;
  String? status;
  String? reason;
  String? note;
  String? paymentStatus;
  String? idPaymentMethod;
  String? distance;
  String? distanceUnit;
  String? amount;
  String? discount;
  AdminCommission? discountType;
  List<TaxModel>? tax;
  String? tip;
  String? adminCommission;
  AdminCommission? adminCommissionType;
  String? otp;
  String? assignedDriverId;
  String? rejectedDriverId;
  String? transactionId;
  String? ownerId;
  String? createdAt;
  String? updatedAt;
  String? paymentMethod;
  String? parcelTypeImage;
  Driver? driver;
  User? user;
  ComplainDetails? complainDetails;
  bool? complaint;

  ParcelBookingData(
      {this.id,
      this.bookingNumber,
      this.idUserApp,
      this.idConducteur,
      this.source,
      this.destination,
      this.latSource,
      this.lngSource,
      this.latDestination,
      this.lngDestination,
      this.senderName,
      this.senderPhone,
      this.receiverName,
      this.receiverPhone,
      this.parcelWeight,
      this.parcelDimension,
      this.parcelImage,
      this.parcelType,
      this.parcelDate,
      this.parcelTime,
      this.receiveDate,
      this.receiveTime,
      this.status,
      this.reason,
      this.note,
      this.paymentStatus,
      this.idPaymentMethod,
      this.distance,
      this.distanceUnit,
      this.amount,
      this.discount,
      this.discountType,
      this.tax,
      this.tip,
      this.adminCommission,
      this.adminCommissionType,
      this.otp,
      this.assignedDriverId,
      this.rejectedDriverId,
      this.transactionId,
      this.ownerId,
      this.createdAt,
      this.updatedAt,
      this.paymentMethod,
      this.parcelTypeImage,
      this.driver,
      this.user,
      this.complaint,
      this.complainDetails});

  ParcelBookingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingNumber = json['booking_number'];
    idUserApp = json['id_user_app'];
    idConducteur = json['id_conducteur'];
    source = json['source'];
    destination = json['destination'];
    latSource = json['lat_source'];
    lngSource = json['lng_source'];
    latDestination = json['lat_destination'];
    lngDestination = json['lng_destination'];
    senderName = json['sender_name'];
    senderPhone = json['sender_phone'];
    receiverName = json['receiver_name'];
    receiverPhone = json['receiver_phone'];
    parcelWeight = json['parcel_weight'];
    parcelDimension = json['parcel_dimension'];
    parcelImage = json['parcel_image'].cast<String>();
    parcelType = json['parcel_type'];
    parcelDate = json['parcel_date'];
    parcelTime = json['parcel_time'];
    receiveDate = json['receive_date'];
    receiveTime = json['receive_time'];
    status = json['status'];
    reason = json['reason'];
    note = json['note'];
    paymentStatus = json['payment_status'];
    idPaymentMethod = json['id_payment_method'];
    distance = json['distance'];
    distanceUnit = json['distance_unit'];
    amount = json['amount'];
    discount = json['discount'];
    discountType = json['discount_type'] != null ? AdminCommission.fromJson(json['discount_type']) : null;
    if (json['tax'] != null) {
      tax = <TaxModel>[];
      json['tax'].forEach((v) {
        tax!.add(TaxModel.fromJson(v));
      });
    }
    tip = json['tip'];
    adminCommission = json['admin_commission'];
    adminCommissionType = json['admin_commission_type'] != null ? AdminCommission.fromJson(json['admin_commission_type']) : null;
    otp = json['otp'];
    assignedDriverId = json['assigned_driver_id'];
    rejectedDriverId = json['rejected_driver_id'];
    transactionId = json['transaction_id'];
    ownerId = json['ownerId'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paymentMethod = json['payment_method'];
    parcelTypeImage = json['parcel_type_image'];
    driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    complainDetails = json['complaint_detail'] != null ? ComplainDetails.fromJson(json['complaint_detail']) : null;
    complaint = json['complaint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_user_app'] = idUserApp;
    data['id_conducteur'] = idConducteur;
    data['source'] = source;
    data['destination'] = destination;
    data['lat_source'] = latSource;
    data['lng_source'] = lngSource;
    data['lat_destination'] = latDestination;
    data['lng_destination'] = lngDestination;
    data['sender_name'] = senderName;
    data['sender_phone'] = senderPhone;
    data['receiver_name'] = receiverName;
    data['receiver_phone'] = receiverPhone;
    data['parcel_weight'] = parcelWeight;
    data['parcel_dimension'] = parcelDimension;
    data['parcel_image'] = parcelImage;
    data['parcel_type'] = parcelType;
    data['parcel_date'] = parcelDate;
    data['parcel_time'] = parcelTime;
    data['receive_date'] = receiveDate;
    data['receive_time'] = receiveTime;
    data['status'] = status;
    data['reason'] = reason;
    data['note'] = note;
    data['payment_status'] = paymentStatus;
    data['id_payment_method'] = idPaymentMethod;
    data['distance'] = distance;
    data['distance_unit'] = distanceUnit;
    data['amount'] = amount;
    data['discount'] = discount;
    if (discountType != null) {
      data['discount_type'] = discountType!.toJson();
    }
    if (tax != null) {
      data['tax'] = tax!.map((v) => v.toJson()).toList();
    }
    data['tip'] = tip;
    data['admin_commission'] = adminCommission;
    if (adminCommissionType != null) {
      data['admin_commission_type'] = adminCommissionType!.toJson();
    }
    data['otp'] = otp;
    data['assigned_driver_id'] = assignedDriverId;
    data['rejected_driver_id'] = rejectedDriverId;
    data['transaction_id'] = transactionId;
    data['ownerId'] = ownerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['payment_method'] = paymentMethod;
    data['parcel_type_image'] = parcelTypeImage;
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
