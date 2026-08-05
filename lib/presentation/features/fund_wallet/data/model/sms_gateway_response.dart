// lib/presentation/features/fund_wallet/data/model/sms_gateway_response.dart

class SmsGateway {
  final int id;
  final String name;
  final bool isActive;

  SmsGateway({required this.id, required this.name, required this.isActive});

  factory SmsGateway.fromJson(Map<String, dynamic> json) {
    return SmsGateway(
      id: json['gateway_id'] ?? json['id'] ?? 0,
      name: json['gateway_name'] ?? json['name'] ?? '',
      isActive: json['status'] == 'active' || json['is_active'] == true,
    );
  }
}

class GatewayPricing {
  final String gatewayName;
  final double pricePerSms;

  GatewayPricing({required this.gatewayName, required this.pricePerSms});

  factory GatewayPricing.fromJson(Map<String, dynamic> json) {
    return GatewayPricing(
      gatewayName: json['gateway_name'] ?? '',
      pricePerSms:
          double.tryParse(json['price_per_sms']?.toString() ?? '0.0') ?? 0.0,
    );
  }
}
