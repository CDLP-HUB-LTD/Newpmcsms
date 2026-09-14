// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:pmcsms/core/extensions/build_context_extension.dart';
// import 'package:pmcsms/core/extensions/overlay_extension.dart';
// import 'package:pmcsms/core/extensions/text_theme_extension.dart';
// import 'package:pmcsms/core/theme/app_colors.dart';
// import 'package:pmcsms/core/utils/enums.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/delete_draft_request.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/draft_service_tab.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/components/edit_draft_section.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/components/show_message_option.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/notifier/delete_draft_notifier.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/notifier/get_draft_by_id_notifier.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/view/draft_view.dart';
// import 'package:pmcsms/presentation/general_widgets/app_send_button.dart';
// import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
// import 'package:pmcsms/presentation/general_widgets/page_loader.dart';
// import 'package:pmcsms/presentation/general_widgets/spacing.dart';

// class DraftDetails extends ConsumerStatefulWidget {
//   const DraftDetails({
//     required this.draftId,
//     required this.service,
//     required this.action,
//     super.key,
//   });
//   final String draftId;
//   final DraftServiceTab service;
//   final String action;

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _DraftDetailsState();
// }

// class _DraftDetailsState extends ConsumerState<DraftDetails> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await ref.read(getDraftByIdNotifier.notifier).getDraftById(
//             draftId: int.parse(widget.draftId),
//             action: widget.service.viewAction,
//           );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final draft = ref.watch(
//         getDraftByIdNotifier.select((v) => v.getDraftByIdResponse?.data));

//     final isLoading = ref.watch(
//         getDraftByIdNotifier.select((v) => v.getDraftByIdState.isLoading));

//     final isDeleteDraftLoading = ref
//         .watch(deleteDraftNotifier.select((v) => v.deleteDraftState.isLoading));
//     return PageLoader(
//       isLoading: isDeleteDraftLoading,
//       child: PageLoader(
//         isLoading: isLoading,
//         child: Scaffold(
//           appBar: CustomAppBar(
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 16),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                         onTap: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => EditDraftSection(
//                                   title: draft?.draftTitle ?? '',
//                                   message: draft?.draftMessage ?? '',
//                                   draftId: draft?.draftId ?? 0,
//                                   service: widget.service,
//                                 ),
//                               ),
//                             ),
//                         child: SvgPicture.asset('assets/icons/edit.svg')),
//                     const HorizontalSpacing(10),
//                     GestureDetector(
//                         onTap: () {
//                           _deleteDraft();
//                         },
//                         child: SvgPicture.asset('assets/icons/delete.svg')),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           body: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Title',
//                     style: context.textTheme.s14w400.copyWith(
//                       color: AppColors.primary141414,
//                     ),
//                   ),
//                   const VerticalSpacing(12),
//                   Text(
//                     draft?.draftTitle ?? '',
//                     style: context.textTheme.s14w400.copyWith(
//                       color: AppColors.primary494949,
//                     ),
//                   ),
//                   const VerticalSpacing(16),
//                   const Divider(
//                     color: AppColors.primaryE8E8E8,
//                   ),
//                   Text(
//                     'Message',
//                     style: context.textTheme.s14w400.copyWith(
//                       color: AppColors.primary141414,
//                     ),
//                   ),
//                   const VerticalSpacing(12),
//                   Text(
//                     draft?.draftMessage ?? '',
//                     style: context.textTheme.s14w400.copyWith(
//                       color: AppColors.primary494949,
//                     ),
//                   ),
//                   const VerticalSpacing(60),
//                   AppSendButton(
//                     onTap: () {
//                       showModalBottomSheet(
//                           context: context,
//                           builder: (_) {
//                             return const ShowMessageOption();
//                           });
//                     },
//                     title: 'Send message',
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _deleteDraft() {
//     final data = DeleteDraftRequest(
//         process: 'pm_drafts',
//         action: widget.service.deleteAction,
//         draftId: int.parse(widget.draftId));
//     ref.read(deleteDraftNotifier.notifier).deleteDraft(
//         data: data,
//         onError: (error) {
//           context.showError(message: error);
//         },
//         onSuccess: (String message) {
//           context.showSuccess(message: message);
//           context.popAndPushNamed(DraftView.routeName);
//         });
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/delete_draft_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/draft_service_tab.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/components/edit_draft_section.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/components/show_message_option.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/notifier/delete_draft_notifier.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/notifier/get_draft_by_id_notifier.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/view/draft_view.dart';
import 'package:pmcsms/presentation/general_widgets/app_send_button.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/page_loader.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class DraftDetails extends ConsumerStatefulWidget {
  const DraftDetails({
    required this.draftId,
    required this.service,
    required this.action,
    super.key,
  });
  final String draftId;
  final DraftServiceTab service;
  final String action;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DraftDetailsState();
}

class _DraftDetailsState extends ConsumerState<DraftDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(getDraftByIdNotifier.notifier).getDraftById(
            draftId: int.parse(widget.draftId),
            action: widget.service.viewAction,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(
        getDraftByIdNotifier.select((v) => v.getDraftByIdResponse?.data));

    final isLoading = ref.watch(
        getDraftByIdNotifier.select((v) => v.getDraftByIdState.isLoading));

    final isDeleteDraftLoading = ref
        .watch(deleteDraftNotifier.select((v) => v.deleteDraftState.isLoading));
    return PageLoader(
      isLoading: isDeleteDraftLoading,
      child: PageLoader(
        isLoading: isLoading,
        child: Scaffold(
          appBar: CustomAppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditDraftSection(
                                  title: draft?.draftTitle ?? '',
                                  message: draft?.draftMessage ?? '',
                                  draftId: draft?.draftId ?? 0,
                                  service: widget.service,
                                ),
                              ),
                            ),
                        child: SvgPicture.asset('assets/icons/edit.svg')),
                    const HorizontalSpacing(10),
                    GestureDetector(
                        onTap: () {
                          _deleteDraft();
                        },
                        child: SvgPicture.asset('assets/icons/delete.svg')),
                  ],
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title',
                    style: context.textTheme.s14w400.copyWith(
                      color: AppColors.primary141414,
                    ),
                  ),
                  const VerticalSpacing(12),
                  Text(
                    draft?.draftTitle ?? '',
                    style: context.textTheme.s14w400.copyWith(
                      color: AppColors.primary494949,
                    ),
                  ),
                  const VerticalSpacing(16),
                  const Divider(
                    color: AppColors.primaryE8E8E8,
                  ),
                  Text(
                    'Message',
                    style: context.textTheme.s14w400.copyWith(
                      color: AppColors.primary141414,
                    ),
                  ),
                  const VerticalSpacing(12),
                  Text(
                    draft?.draftMessage ?? '',
                    style: context.textTheme.s14w400.copyWith(
                      color: AppColors.primary494949,
                    ),
                  ),
                  const VerticalSpacing(60),
                  AppSendButton(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (_) {
                            // Pass the loaded draft's content through so the
                            // chosen option (SMS/Email) knows what to send —
                            // previously this was a parameterless const
                            // widget with no way to carry the draft along.
                            return ShowMessageOption(
                              draftTitle: draft?.draftTitle,
                              draftMessage: draft?.draftMessage,
                            );
                          });
                    },
                    title: 'Send message',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _deleteDraft() {
    final data = DeleteDraftRequest(
        process: 'pm_drafts',
        action: widget.service.deleteAction,
        draftId: int.parse(widget.draftId));
    ref.read(deleteDraftNotifier.notifier).deleteDraft(
        data: data,
        onError: (error) {
          context.showError(message: error);
        },
        onSuccess: (String message) {
          context.showSuccess(message: message);
          context.popAndPushNamed(DraftView.routeName);
        });
  }
}
