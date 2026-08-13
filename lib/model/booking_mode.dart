import 'package:cabme_driver/model/admin_commission.dart';
import 'package:cabme_driver/model/tax_model.dart';

class BookingModel {
  String? success;
  String? error;
  String? message;
  BookingData? data;

  BookingModel({this.success, this.error, this.message, this.data});

  BookingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? BookingData.fromJson(json['data']) : null;
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

class BookingData {
  String? id;
  String? bookingNumber;
  String? idUserApp;
  String? idConducteur;
  String? departName;
  String? destinationName;
  String? latitudeDepart;
  String? longitudeDepart;
  String? latitudeArrivee;
  String? longitudeArrivee;
  List<Stops>? stops;
  String? numberPoeple;
  String? distance;
  String? distanceUnit;
  String? duree;
  String? montant;
  List<TaxModel>? tax;
  String? discount;
  String? statutPaiement;
  String? idPaymentMethod;
  String? creer;
  String? feelSafe;
  String? feelSafeDriver;
  String? otp;
  String? otpCreated;
  String? rideType;
  String? statut;
  String? vehicleTypeId;
  String? assignedDriverId;
  String? totalChildren;
  String? paymentMethod;
  String? adminCommission;
  Driver? driver;
  User? user;
  AdminCommission? adminCommissionType;
  AdminCommission? discountType;
  ComplainDetails? complainDetails;
  bool? complaint;
  String? bumpAmount;

  BookingData(
      {this.id,
      this.bookingNumber,
      this.idUserApp,
      this.idConducteur,
      this.departName,
      this.destinationName,
      this.latitudeDepart,
      this.longitudeDepart,
      this.latitudeArrivee,
      this.longitudeArrivee,
      this.stops,
      this.numberPoeple,
      this.distance,
      this.distanceUnit,
      this.duree,
      this.montant,
      this.tax,
      this.discount,
      this.statutPaiement,
      this.idPaymentMethod,
      this.creer,
      this.feelSafe,
      this.feelSafeDriver,
      this.otp,
      this.otpCreated,
      this.rideType,
      this.statut,
      this.vehicleTypeId,
      this.assignedDriverId,
      this.totalChildren,
      this.paymentMethod,
      this.driver,
      this.user,
      this.adminCommission,
      this.adminCommissionType,
      this.discountType,
      this.complaint,
      this.complainDetails,
      this.bumpAmount});

  BookingData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    bookingNumber = json['booking_number'].toString();
    idUserApp = json['id_user_app'].toString();
    idConducteur = json['id_conducteur'].toString();
    departName = json['depart_name'];
    destinationName = json['destination_name'];
    latitudeDepart = json['latitude_depart'];
    longitudeDepart = json['longitude_depart'];
    latitudeArrivee = json['latitude_arrivee'];
    longitudeArrivee = json['longitude_arrivee'];
    if (json['stops'] != null) {
      stops = <Stops>[];
      json['stops'].forEach((v) {
        stops!.add(Stops.fromJson(v));
      });
    }
    numberPoeple = json['number_poeple'];
    distance = json['distance'];
    distanceUnit = json['distance_unit'];
    duree = json['duree'];
    montant = json['montant'];
    if (json['tax'] != null) {
      tax = <TaxModel>[];
      json['tax'].forEach((v) {
        tax!.add(TaxModel.fromJson(v));
      });
    }
    discount = json['discount'].toString();
    statutPaiement = json['statut_paiement'];
    idPaymentMethod = json['id_payment_method'].toString();
    creer = json['creer'];
    feelSafe = json['feel_safe'];
    feelSafeDriver = json['feel_safe_driver'];
    otp = json['otp'];
    otpCreated = json['otp_created'];
    rideType = json['ride_type'];
    statut = json['statut'];
    vehicleTypeId = json['vehicle_type_id'].toString();
    assignedDriverId = json['assigned_driver_id'];
    totalChildren = json['total_children'];
    paymentMethod = json['payment_method'];
    adminCommission = json['admin_commission'];
    driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    adminCommissionType = json['admin_commission_type'] != null ? AdminCommission.fromJson(json['admin_commission_type']) : null;
    discountType = json['discount_type'] != null ? AdminCommission.fromJson(json['discount_type']) : null;
    complainDetails = json['complaint_detail'] != null ? ComplainDetails.fromJson(json['complaint_detail']) : null;
    complaint = json['complaint'];
    bumpAmount = json['bump_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_number'] = bookingNumber;
    data['id_user_app'] = idUserApp;
    data['id_conducteur'] = idConducteur;
    data['depart_name'] = departName;
    data['destination_name'] = destinationName;
    data['latitude_depart'] = latitudeDepart;
    data['longitude_depart'] = longitudeDepart;
    data['latitude_arrivee'] = latitudeArrivee;
    data['longitude_arrivee'] = longitudeArrivee;
    if (stops != null) {
      data['stops'] = stops!.map((v) => v.toJson()).toList();
    }
    data['number_poeple'] = numberPoeple;
    data['distance'] = distance;
    data['distance_unit'] = distanceUnit;
    data['duree'] = duree;
    data['montant'] = montant;
    if (tax != null) {
      data['tax'] = tax!.map((v) => v.toJson()).toList();
    }
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['statut_paiement'] = statutPaiement;
    data['id_payment'] = idPaymentMethod;
    data['creer'] = creer;
    data['feel_safe'] = feelSafe;
    data['feel_safe_driver'] = feelSafeDriver;
    data['otp'] = otp;
    data['otp_created'] = otpCreated;
    data['ride_type'] = rideType;
    data['statut'] = statut;
    data['vehicle_type_id'] = vehicleTypeId;
    data['assigned_driver_id'] = assignedDriverId;
    data['total_children'] = totalChildren;
    data['payment_method_name'] = paymentMethod;
    data['admin_commission'] = adminCommissionType;
    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (adminCommissionType != null) {
      data['admin_commission_type'] = adminCommissionType!.toJson();
    }
    if (discountType != null) {
      data['discount_type'] = discountType!.toJson();
    }
    if (complainDetails != null) {
      data['complaint_detail'] = complainDetails!.toJson();
    }
    data['complaint'] = complaint;
    data['bump_amount'] = bumpAmount;
    return data;
  }
}

class Stops {
  String? latitude;
  String? longitude;
  String? location;

  Stops({this.latitude, this.longitude, this.location});

  Stops.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['location'] = location;
    return data;
  }
}

class ComplainDetails {
  String? id;
  String? title;
  String? description;
  String? status;
  String? bookingId;
  String? bookingType;
  String? createdAt;
  String? updatedAt;

  ComplainDetails({this.id, this.title, this.description, this.status, this.bookingId, this.bookingType, this.createdAt, this.updatedAt});

  ComplainDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    bookingId = json['booking_id'];
    bookingType = json['booking_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['status'] = status;
    data['booking_id'] = bookingId;
    data['booking_type'] = bookingType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Driver {
  String? id;
  String? nom;
  String? prenom;
  String? phone;
  String? latitude;
  String? longitude;
  String? reviewSum;
  String? reviewCount;
  String? averageRating;
  String? image;
  VehicleDetails? vehicleDetails;

  Driver({this.id, this.nom, this.prenom, this.phone, this.latitude, this.longitude, this.reviewSum, this.reviewCount, this.averageRating, this.image, this.vehicleDetails});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prenom = json['prenom'];
    phone = json['phone'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    reviewSum = json['review_sum'] ?? '0.0';
    reviewCount = json['review_count'] ?? '0.0';
    averageRating = json['average_rating'] ?? '0.0';
    image = json['image'];
    vehicleDetails = json['vehicle_details'] != null ? VehicleDetails.fromJson(json['vehicle_details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['phone'] = phone;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['review_sum'] = reviewSum;
    data['review_count'] = reviewCount;
    data['average_rating'] = averageRating;
    data['image'] = image;
    if (vehicleDetails != null) {
      data['vehicle_details'] = vehicleDetails!.toJson();
    }
    return data;
  }
}

class VehicleDetails {
  String? brand;
  String? model;
  String? carMake;
  String? numberplate;
  String? type;
  String? image;

  VehicleDetails({this.brand, this.model, this.carMake, this.numberplate, this.type, this.image});

  VehicleDetails.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    model = json['model'];
    carMake = json['car_make'];
    numberplate = json['numberplate'];
    type = json['type'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brand'] = brand;
    data['model'] = model;
    data['car_make'] = carMake;
    data['numberplate'] = numberplate;
    data['type'] = type;
    data['image'] = image;
    return data;
  }
}

class User {
  String? id;
  String? nom;
  String? prenom;
  String? email;
  String? phone;
  String? reviewSum;
  String? reviewCount;
  String? averageRating;
  String? image;

  User({this.id, this.nom, this.prenom, this.email, this.phone, this.reviewSum, this.reviewCount, this.averageRating, this.image});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prenom = json['prenom'];
    email = json['email'];
    phone = json['phone'];
    reviewSum = json['review_sum'] ?? '0.0';
    reviewCount = json['review_count'] ?? '0.0';
    averageRating = json['average_rating'] ?? '0.0';
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['email'] = email;
    data['phone'] = phone;
    data['review_sum'] = reviewSum;
    data['review_count'] = reviewCount;
    data['average_rating'] = averageRating;
    data['image'] = image;
    return data;
  }
}
