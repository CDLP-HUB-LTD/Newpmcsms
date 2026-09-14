import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/get_draft_by_id_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/repository/get_draft_by_id_repository.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/notifier/get_draft_by_id_state.dart';

class GetDraftByIdNotifier
    extends AutoDisposeNotifier<GetDraftByIdNotifierState> {
  GetDraftByIdNotifier();

  late GetDraftByIdRepository _getDraftByIdRepository;

  @override
  GetDraftByIdNotifierState build() {
    _getDraftByIdRepository = ref.read(getDraftByIdRepositoryProvider);

    return GetDraftByIdNotifierState.initial();
  }

  Future<void> getDraftById(
      {required int draftId, required String action}) async {
    state = state.copyWith(getDraftByIdState: LoadState.loading);
    final data = GetDraftByIdRequest(
        process: 'pm_drafts', action: 'view_draft', draftId: draftId);
    try {
      final value =
          await _getDraftByIdRepository.getDraftById(getDraftByIdRequest: data);

      if (!value.status) throw value.serverMessage.toString();

      state = state.copyWith(
          getDraftByIdState: LoadState.idle, getDraftByIdResponse: value.data);
    } catch (e) {
      // onError(e.toString());
      state = state.copyWith(getDraftByIdState: LoadState.idle);
    }
  }
}

final getDraftByIdNotifier = NotifierProvider.autoDispose<GetDraftByIdNotifier,
    GetDraftByIdNotifierState>(
  GetDraftByIdNotifier.new,
);
