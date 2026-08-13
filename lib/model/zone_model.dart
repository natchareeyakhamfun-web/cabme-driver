class ZoneModel {
  String? success;
  String? error;
  String? message;
  List<ZoneData>? data;

  ZoneModel({this.success, this.error, this.message, this.data});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ZoneData>[];
      json['data'].forEach((v) {
        data!.add(ZoneData.fromJson(v));
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

class ZoneData {
  int? id;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;

  ZoneData({this.id, this.name, this.status, this.createdAt, this.updatedAt});

  ZoneData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
