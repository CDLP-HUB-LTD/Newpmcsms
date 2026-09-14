class SmsHistoryItem {
  final int smsId;
  final String publicId;
  final int userId;
  final String senderId;
  final String message;
  final String recipients;
  final String action;
  final String status;
  final String? scheduleDate;
  final String? walletTransId;
  final String prevBal;
  final String totalAmount;
  final String afterBal;
  final String? gatewayId;
  final String? gatewayApiRoute;
  final String reference;
  final String walletType;
  final String? errorResponse;
  final String channel;
  final String? callbackDlr;
  final String createdAt;
  final String updatedAt;

  const SmsHistoryItem({
    required this.smsId,
    required this.publicId,
    required this.userId,
    required this.senderId,
    required this.message,
    required this.recipients,
    required this.action,
    required this.status,
    this.scheduleDate,
    this.walletTransId,
    required this.prevBal,
    required this.totalAmount,
    required this.afterBal,
    this.gatewayId,
    this.gatewayApiRoute,
    required this.reference,
    required this.walletType,
    this.errorResponse,
    required this.channel,
    this.callbackDlr,
    required this.createdAt,
    required this.updatedAt,
  });

  static int _asInt(dynamic v) {
    if (v is int) return v;
    return int.tryParse('$v') ?? 0;
  }

  static String _asString(dynamic v) => v?.toString() ?? '';

  factory SmsHistoryItem.fromJson(Map<String, dynamic> json) {
    return SmsHistoryItem(
      smsId: _asInt(json['sms_id']),
      publicId: _asString(json['public_id']),
      userId: _asInt(json['userid']),
      senderId: _asString(json['sender_id']),
      message: _asString(json['message']),
      recipients: _asString(json['recipients']),
      action: _asString(json['action']),
      status: _asString(json['status']),
      scheduleDate: json['schedule_date']?.toString(),
      walletTransId: json['wallet_trans_id']?.toString(),
      prevBal: _asString(json['prev_bal']),
      totalAmount: _asString(json['total_amount']),
      afterBal: _asString(json['after_bal']),
      gatewayId: json['gateway_id']?.toString(),
      gatewayApiRoute: json['gateway_api_route']?.toString(),
      reference: _asString(json['reference']),
      walletType: _asString(json['wallet_type']),
      errorResponse: json['error_response']?.toString(),
      channel: _asString(json['channel']),
      callbackDlr: json['callback_dlr']?.toString(),
      createdAt: _asString(json['created_at']),
      updatedAt: _asString(json['updated_at']),
    );
  }

  /// Recipients can be a comma separated string of numbers/emails.
  List<String> get recipientList => recipients
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  int get recipientCount => recipientList.length;

  /// First recipient, used for the avatar/title in list rows.
  String get primaryRecipient =>
      recipientList.isNotEmpty ? recipientList.first : recipients;

  /// Normalizes backend status strings ('processing', 'success', etc.)
  /// into the labels the UI already expects.
  String get displayStatus {
    switch (status.toLowerCase()) {
      case 'processing':
      case 'pending':
      case 'queued':
        return 'Pending';
      case 'success':
      case 'successful':
      case 'sent':
      case 'delivered':
        return 'Successful';
      case 'failed':
      case 'error':
      case 'undelivered':
        return 'Failed';
      default:
        return status.isEmpty ? 'Unknown' : status;
    }
  }

  DateTime? get createdAtDate => DateTime.tryParse(createdAt);
}
