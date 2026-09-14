import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/data/model/repository/personalised_sms_repository.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/data/model/submit_personalised_sms_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/data/model/submit_personalised_sms_response.dart';

class PersonalizedSmsState {
  final bool isLoading;
  const PersonalizedSmsState({this.isLoading = false});

  PersonalizedSmsState copyWith({bool? isLoading}) =>
      PersonalizedSmsState(isLoading: isLoading ?? this.isLoading);
}

class PersonalizedSmsController extends StateNotifier<PersonalizedSmsState> {
  final PersonalizedSmsRepository _repository;

  PersonalizedSmsController(this._repository)
      : super(const PersonalizedSmsState());

  Future<void> submit({
    required SubmitPersonalizedSmsRequest data,
    required void Function(String error) onError,
    required void Function(SubmitPersonalizedSmsResponse response) onSuccess,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _repository.submit(data);
      state = state.copyWith(isLoading: false);

      if (response.status) {
        onSuccess(response);
      } else {
        onError(response.serverMessage.isNotEmpty
            ? response.serverMessage
            : 'Unable to send message');
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
      onError('Something went wrong. Please try again.');
    }
  }
}

final personalizedSmsNotifierProvider = StateNotifierProvider.autoDispose<
    PersonalizedSmsController, PersonalizedSmsState>((ref) {
  final repository = ref.watch(personalizedSmsRepositoryProvider);
  return PersonalizedSmsController(repository);
});
