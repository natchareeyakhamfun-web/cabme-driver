class RentalPackageModel {
  String? success;
  String? error;
  String? message;
  List<RentalPackageData>? data;

  RentalPackageModel({this.success, this.error, this.message, this.data});

  RentalPackageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RentalPackageData>[];
      json['data'].forEach((v) {
        data!.add(RentalPackageData.fromJson(v));
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

class RentalPackageData {
  String? id;
  String? title;
  String? description;
  String? image;
  String? published;
  String? ordering;
  String? baseFare;
  String? includedHours;
  String? includedDistance;
  String? extraKmFare;
  String? extraMinuteFare;
  String? vehicleTypeId;
  String? createdAt;
  String? updatedAt;
  String? vehicleTypeName;

  RentalPackageData(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.published,
        this.ordering,
        this.baseFare,
        this.includedHours,
        this.includedDistance,
        this.extraKmFare,
        this.extraMinuteFare,
        this.vehicleTypeId,
        this.createdAt,
        this.updatedAt,
        this.vehicleTypeName});

  RentalPackageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    published = json['published'];
    ordering = json['ordering'];
    baseFare = json['baseFare'];
    includedHours = json['includedHours'];
    includedDistance = json['includedDistance'];
    extraKmFare = json['extraKmFare'];
    extraMinuteFare = json['extraMinuteFare'];
    vehicleTypeId = json['vehicleTypeId'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vehicleTypeName = json['vehicleTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['published'] = published;
    data['ordering'] = ordering;
    data['baseFare'] = baseFare;
    data['includedHours'] = includedHours;
    data['includedDistance'] = includedDistance;
    data['extraKmFare'] = extraKmFare;
    data['extraMinuteFare'] = extraMinuteFare;
    data['vehicleTypeId'] = vehicleTypeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['vehicleTypeName'] = vehicleTypeName;
    return data;
  }
}
