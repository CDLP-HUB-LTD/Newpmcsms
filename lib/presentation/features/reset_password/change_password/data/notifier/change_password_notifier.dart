import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/presentation/features/reset_password/change_password/data/model/change_password_request.dart';
import 'package:pmcsms/presentation/features/reset_password/change_password/data/repository/profile_repository.dart';

class ChangePasswordState {
  final bool isLoading;
  const ChangePasswordState({this.isLoading = false});

  ChangePasswordState copyWith({bool? isLoading}) =>
      ChangePasswordState(isLoading: isLoading ?? this.isLoading);
}

class ChangePasswordController extends StateNotifier<ChangePasswordState> {
  final ProfileRepository _repository;

  ChangePasswordController(this._repository)
      : super(const ChangePasswordState());

  Future<void> changePassword({
    required ChangePasswordRequest data,
    required void Function(String error) onError,
    required void Function(String message) onSuccess,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _repository.changePassword(data);
      state = state.copyWith(isLoading: false);

      if (response.status) {
        onSuccess(response.serverMessage.isNotEmpty
            ? response.serverMessage
            : 'Password changed successfully');
      } else {
        // Surfaces messages like "Incorrect current password supplied"
        onError(response.serverMessage.isNotEmpty
            ? response.serverMessage
            : 'Unable to change password');
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
      onError('Something went wrong. Please try again.');
    }
  }
}

final changePasswordNotifier =
    StateNotifierProvider<ChangePasswordController, ChangePasswordState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ChangePasswordController(repository);
});
