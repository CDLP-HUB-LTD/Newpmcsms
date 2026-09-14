// lib/presentation/features/referral/data/model/referral_response.dart
class ReferralItem {
  final String referralId;
  final String referredBy;
  final String regDate;
  final String username;
  final bool confirmed;

  ReferralItem({
    required this.referralId,
    required this.referredBy,
    required this.regDate,
    required this.username,
    required this.confirmed,
  });

  factory ReferralItem.fromJson(Map<String, dynamic> json) => ReferralItem(
        referralId: (json['referral_id'] ?? '').toString(),
        referredBy: (json['referred_by'] ?? '').toString(),
        regDate: (json['reg_date'] ?? '').toString(),
        username: (json['username'] ?? '').toString(),
        confirmed: json['confirmed'] == 1 || json['confirmed'] == true,
      );
}

class MyReferralsResponse {
  final String? serverMessage;
  final bool? status;
  final List<ReferralItem>? data;
  final List<dynamic>? dataResult;
  final List<dynamic>? errorData;
  final String? textStatus;
  final dynamic error;

  MyReferralsResponse({
    this.serverMessage,
    this.status,
    this.data,
    this.dataResult,
    this.errorData,
    this.textStatus,
    this.error,
  });

  factory MyReferralsResponse.fromJson(Map<String, dynamic> json) =>
      MyReferralsResponse(
        serverMessage: json['server_message'],
        status: json['status'],
        data: json['data'] == null
            ? []
            : List<ReferralItem>.from(
                (json['data'] as List).map((x) => ReferralItem.fromJson(x))),
        dataResult: json['data_result'] == null
            ? []
            : List<dynamic>.from(json['data_result']),
        errorData: json['error_data'] == null
            ? []
            : List<dynamic>.from(json['error_data']),
        textStatus: json['text_status'],
        error: json['error'],
      );
}
