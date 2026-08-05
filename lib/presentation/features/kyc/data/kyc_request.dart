// lib/presentation/features/kyc/data/model/kyc_status_request.dart
class KycStatusRequest {
  final String process;
  final String action;

  KycStatusRequest({
    this.process = 'pm_kyc',
    this.action = 'get_kyc_status',
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
      };
}

// lib/presentation/features/kyc/data/model/kyc_status_response.dart
// lib/presentation/features/kyc/data/kyc_request.dart

class KycStatusResponse {
  final String? serverMessage;
  final bool? status;
  final KycDataDetails? data; // ✅ Maps to the 'data' key block in your log

  KycStatusResponse({this.serverMessage, this.status, this.data});

  factory KycStatusResponse.fromJson(Map<String, dynamic> json) {
    return KycStatusResponse(
      serverMessage: json['server_message'] as String?,
      status: json['status'] as bool?,
      data: json['data'] != null ? KycDataDetails.fromJson(json['data']) : null,
    );
  }
}

class KycDataDetails {
  final bool? kycCompleted;
  final bool? hasFullKyc;
  final String? bvnStatus;
  final String? ninStatus;
  final bool? hasBvn;
  final bool? hasNin;
  final String? verificationType;
  final bool? hasAccountNumber;
  final bool? showKycPrompt;

  KycDataDetails({
    this.kycCompleted,
    this.hasFullKyc,
    this.bvnStatus,
    this.ninStatus,
    this.hasBvn,
    this.hasNin,
    this.verificationType,
    this.hasAccountNumber,
    this.showKycPrompt,
  });

  factory KycDataDetails.fromJson(Map<String, dynamic> json) {
    return KycDataDetails(
      kycCompleted: json['kyc_completed'] as bool?,
      hasFullKyc: json['has_full_kyc'] as bool?,
      bvnStatus: json['bvn_status'] as String?,
      ninStatus: json['nin_status'] as String?,
      hasBvn: json['has_bvn'] as bool?,
      hasNin: json['has_nin'] as bool?,
      verificationType: json['verification_type'] as String?,
      hasAccountNumber: json['has_account_number'] as bool?,
      showKycPrompt: json['show_kyc_prompt'] as bool?,
    );
  }
}

class KycData {
  final String? kycState;
  final String? accountNumber;
  final bool? promptFlag;

  KycData({this.kycState, this.accountNumber, this.promptFlag});

  factory KycData.fromJson(Map<String, dynamic> json) {
    return KycData(
      kycState: json['kycState'] as String?,
      accountNumber: json['account_number'] as String?,
      promptFlag: json['prompt_flag'] as bool?,
    );
  }
}
