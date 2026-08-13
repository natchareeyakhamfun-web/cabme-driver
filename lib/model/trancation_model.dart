class TransactionModel {
  String? success;
  int? code;
  String? message;
  List<TransactionData>? data;

  TransactionModel({this.success, this.code, this.message, this.data});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TransactionData>[];
      json['data'].forEach((v) {
        data!.add(TransactionData.fromJson(v));
      });
    }
  }

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

class TransactionData {
  String? id;
  String? userId;
  String? userType;
  String? paymentMethod;
  String? amount;
  String? isCredited;
  String? bookingId;
  String? bookingType;
  String? note;
  String? transactionId;
  String? createdAt;
  String? updatedAt;

  TransactionData(
      {this.id,
        this.userId,
        this.userType,
        this.paymentMethod,
        this.amount,
        this.isCredited,
        this.bookingId,
        this.bookingType,
        this.note,
        this.transactionId,
        this.createdAt,
        this.updatedAt});

  TransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userType = json['user_type'];
    paymentMethod = json['payment_method'];
    amount = json['amount'];
    isCredited = json['is_credited'];
    bookingId = json['booking_id'];
    bookingType = json['booking_type'];
    note = json['note'];
    transactionId = json['transaction_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_type'] = userType;
    data['payment_method'] = paymentMethod;
    data['amount'] = amount;
    data['is_credited'] = isCredited;
    data['booking_id'] = bookingId;
    data['booking_type'] = bookingType;
    data['note'] = note;
    data['transaction_id'] = transactionId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
