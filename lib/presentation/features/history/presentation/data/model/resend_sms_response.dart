class ResendSmsResponse {
  final bool status;
  final String serverMessage;

  const ResendSmsResponse({
    required this.status,
    required this.serverMessage,
  });

  factory ResendSmsResponse.fromJson(Map<String, dynamic> json) {
    return ResendSmsResponse(
      status: json['status'] == true,
      serverMessage: json['server_message']?.toString() ?? '',
    );
  }
}
