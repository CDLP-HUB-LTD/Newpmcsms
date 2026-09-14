// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/utils/enums.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/draft_service_tab.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/get_all_drafts_request.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/repository/get_all_drafts_repository.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/notifier/get_all_drafts_state.dart';

// class GetAllDraftsNotifier
//     extends AutoDisposeNotifier<GetAllDraftsNotifierState> {
//   GetAllDraftsNotifier();

//   late GetAllDraftsRepository _getAllDraftsRepository;

//   @override
//   GetAllDraftsNotifierState build() {
//     _getAllDraftsRepository = ref.read(getAllDraftsRepositoryProvider);

//     return GetAllDraftsNotifierState.initial();
//   }

//   // lib/.../draft/presentation/notifier/get_all_drafts_notifier.dart
// // notifier
//   Future<void> getAllDrafts({
//     required DraftServiceTab service,
//     int start = 1,
//     int length = 20,
//   }) async {
//     state = state.copyWith(getAllDraftsState: LoadState.loading);
//     try {
//       final value = await _getAllDraftsRepository.getAllDrafts(
//         action: service.listAction,
//         start: start,
//         length: length,
//       );
//       if (!value.status) throw value.serverMessage.toString();
//       state = state.copyWith(
//         getAllDraftsState: LoadState.idle,
//         getAllDraftsResponse: value.data,
//       );
//     } catch (e) {
//       state = state.copyWith(getAllDraftsState: LoadState.idle);
//     }
//   }
// }

// final getAllDraftsNotifier = NotifierProvider.autoDispose<GetAllDraftsNotifier,
//     GetAllDraftsNotifierState>(
//   GetAllDraftsNotifier.new,
// );
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/draft_service_tab.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/get_all_drafts_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/repository/get_all_drafts_repository.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/notifier/get_all_drafts_state.dart';

class GetAllDraftsNotifier
    extends AutoDisposeNotifier<GetAllDraftsNotifierState> {
  GetAllDraftsNotifier();

  late GetAllDraftsRepository _getAllDraftsRepository;

  @override
  GetAllDraftsNotifierState build() {
    _getAllDraftsRepository = ref.read(getAllDraftsRepositoryProvider);

    return GetAllDraftsNotifierState.initial();
  }

  Future<void> getAllDrafts({
    required DraftServiceTab service,
    int start = 1,
    int length = 20,
  }) async {
    state = state.copyWith(getAllDraftsState: LoadState.loading);
    try {
      final value = await _getAllDraftsRepository.getAllDrafts(
        action: service.listAction,
        start: start,
        length: length,
      );
      if (!value.status) throw value.serverMessage.toString();
      state = state.copyWith(
        getAllDraftsState: LoadState.idle,
        getAllDraftsResponse: value.data,
      );
    } catch (e, stackTrace) {
      // TEMPORARY DIAGNOSTIC — this catch previously swallowed everything
      // silently, which is why drafts could disappear with zero visible
      // error even when the request itself succeeded or failed loudly on
      // the server. Remove this debugPrint once the root cause is found.
      debugPrint('💡💡[GET ALL DRAFTS ERROR]💡💡 $e');
      debugPrint('$stackTrace');
      state = state.copyWith(getAllDraftsState: LoadState.idle);
    }
  }
}

final getAllDraftsNotifier = NotifierProvider.autoDispose<GetAllDraftsNotifier,
    GetAllDraftsNotifierState>(
  GetAllDraftsNotifier.new,
);
