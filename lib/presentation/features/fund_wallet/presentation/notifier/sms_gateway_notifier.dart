// lib/presentation/features/fund_wallet/presentation/notifier/sms_gateway_notifier.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/fund_wallet/data/model/sms_gateway_response.dart';

class GatewayState {
  final bool isLoading;
  final List<SmsGateway> activeGateways;
  final List<GatewayPricing> walletPricing;
  final String? errorMessage;

  GatewayState({
    this.isLoading = false,
    this.activeGateways = const [],
    this.walletPricing = const [],
    this.errorMessage,
  });

  GatewayState copyWith({
    bool? isLoading,
    List<SmsGateway>? activeGateways,
    List<GatewayPricing>? walletPricing,
    String? errorMessage,
  }) {
    return GatewayState(
      isLoading: isLoading ?? this.isLoading,
      activeGateways: activeGateways ?? this.activeGateways,
      walletPricing: walletPricing ?? this.walletPricing,
      errorMessage: errorMessage,
    );
  }
}

final smsGatewayNotifierProvider =
    StateNotifierProvider<SmsGatewayNotifier, GatewayState>((ref) {
  final dio = ref.watch(appDioProvider);
  return SmsGatewayNotifier(dio);
});

class SmsGatewayNotifier extends StateNotifier<GatewayState> {
  final Dio _dio;
  SmsGatewayNotifier(this._dio) : super(GatewayState());

  String get _endpoint =>
      '${_dio.options.baseUrl.replaceAll(RegExp(r'/$'), '')}/pmcsms.php';

  Future<void> fetchActiveGateways() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _dio.post(
        _endpoint,
        data: {"process": "pm_gateways", "action": "get_active_sms_gateways"},
      );

      if (response.data?['status'] == true) {
        final List rawList = response.data['data'] ?? [];
        final gateways = rawList.map((e) => SmsGateway.fromJson(e)).toList();
        state = state.copyWith(isLoading: false, activeGateways: gateways);
      } else {
        throw Exception(response.data?['server_message'] ??
            'Failed to load active gateways');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> fetchWalletPricing() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _dio.post(
        _endpoint,
        data: {"process": "pm_gateways", "action": "get_sms_wallet_pricing"},
      );

      if (response.data?['status'] == true) {
        final List rawList = response.data['data'] ?? [];
        final pricing = rawList.map((e) => GatewayPricing.fromJson(e)).toList();
        state = state.copyWith(isLoading: false, walletPricing: pricing);
      } else {
        throw Exception(response.data?['server_message'] ??
            'Failed to load wallet pricing configs');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
