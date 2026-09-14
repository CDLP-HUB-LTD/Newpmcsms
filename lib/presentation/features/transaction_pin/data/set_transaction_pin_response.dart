class TransactionPinResponse {
  final bool status;
  final String serverMessage;

  const TransactionPinResponse({
    required this.status,
    required this.serverMessage,
  });

  factory TransactionPinResponse.fromJson(Map<String, dynamic> json) {
    return TransactionPinResponse(
      status: json['status'] == true,
      serverMessage: json['server_message']?.toString() ?? '',
    );
  }
}
