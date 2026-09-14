class ChangePasswordResponse {
  final bool status;
  final String serverMessage;

  const ChangePasswordResponse({
    required this.status,
    required this.serverMessage,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      status: json['status'] == true,
      serverMessage: json['server_message']?.toString() ?? '',
    );
  }
}
