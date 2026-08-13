class WithdrawalTransactionModel {
  String? success;
  int? code;
  String? message;
  List<WithdrawalTransactionData>? data;

  WithdrawalTransactionModel(
      {this.success, this.code, this.message, this.data});

  WithdrawalTransactionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WithdrawalTransactionData>[];
      json['data'].forEach((v) {
        data!.add(WithdrawalTransactionData.fromJson(v));
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

class WithdrawalTransactionData {
  String? id;
  String? amount;
  String? creer;
  String? modifier;
  String? statut;
  String? note;
  String? idConducteur;
  String? bankName;
  String? branchName;
  String? accountNo;
  String? otherInfo;
  String? ifscCode;

  WithdrawalTransactionData(
      {this.id,
        this.amount,
        this.creer,
        this.modifier,
        this.statut,
        this.note,
        this.idConducteur,
        this.bankName,
        this.branchName,
        this.accountNo,
        this.otherInfo,
        this.ifscCode});

  WithdrawalTransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    creer = json['creer'];
    modifier = json['modifier'];
    statut = json['statut'];
    note = json['note'];
    idConducteur = json['id_conducteur'];
    bankName = json['bank_name'];
    branchName = json['branch_name'];
    accountNo = json['account_no'];
    otherInfo = json['other_info'];
    ifscCode = json['ifsc_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['statut'] = statut;
    data['note'] = note;
    data['id_conducteur'] = idConducteur;
    data['bank_name'] = bankName;
    data['branch_name'] = branchName;
    data['account_no'] = accountNo;
    data['other_info'] = otherInfo;
    data['ifsc_code'] = ifscCode;
    return data;
  }
}
