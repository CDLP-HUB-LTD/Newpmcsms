import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/exception/logger.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/data/data/local_data_source/local_storage_impl.dart';
import 'package:pmcsms/presentation/features/login/data/model/login_request.dart';
import 'package:pmcsms/presentation/features/login/data/repository/login_repository.dart';
import 'package:pmcsms/presentation/features/login/presentation/notifier/login_state.dart';

class LoginNotifierNotifier extends AutoDisposeNotifier<LoginNotifierState> {
  LoginNotifierNotifier();

  late LoginRepository _loginRepository;
  late SecureStorage _storage; // ← add this

  @override
  LoginNotifierState build() {
    _loginRepository = ref.read(loginRepositoryProvider);
    _storage = ref.read(localStorageProvider); // ← add this
    return LoginNotifierState.initial();
  }

  Future<void> login({
    required LoginRequest data,
    required void Function(String error) onError,
    required void Function(String message) onSuccess,
  }) async {
    state = state.copyWith(loginState: LoadState.loading);
    try {
      final value = await _loginRepository.login(data);
      debugLog(data);
      if (!value.status) throw value.serverMessage.toString();

      // ✅ Use _storage (from provider) instead of SecureStorage() directly
      await _storage.saveUserApiKey(value.data!.data!.apiKey!);
      await _storage.saveUserEmail(value.data!.data!.userSettings!.email!);
      await _storage
          .saveUserFirstName(value.data!.data!.userSettings!.firstname!);
      await _storage
          .saveUserFullName(value.data!.data!.userSettings!.fullname!);
      await _storage.saveLoginResponse(value.data!);

      state = state.copyWith(
        loginState: LoadState.idle,
        loginResponse: value.data,
      );
      onSuccess(value.data!.serverMessage!);
    } catch (e) {
      onError(e.toString());
      state = state.copyWith(loginState: LoadState.idle);
    }
  }
}

final loginNotifier =
    NotifierProvider.autoDispose<LoginNotifierNotifier, LoginNotifierState>(
  LoginNotifierNotifier.new,
);
