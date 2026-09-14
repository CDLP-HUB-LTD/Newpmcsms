import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/draft_service_tab.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/update_draft_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/components/add_drafts_text_widget.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/notifier/update_draft_notifier.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/view/draft_view.dart';
import 'package:pmcsms/presentation/general_widgets/app_send_button.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/page_loader.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class EditDraftSection extends ConsumerStatefulWidget {
  const EditDraftSection({
    required this.title,
    required this.message,
    required this.draftId,
    required this.service,
    super.key,
  });
  final String title;
  final String message;
  final int draftId;
  final DraftServiceTab service;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditDraftSectionState();
}

class _EditDraftSectionState extends ConsumerState<EditDraftSection> {
  final ValueNotifier<bool> _isAddDraftEnabled = ValueNotifier(false);

  late TextEditingController _titleController;

  late TextEditingController _messageController;

  @override
  void initState() {
    _titleController = TextEditingController()..addListener(_validateInput);

    _messageController = TextEditingController()..addListener(_validateInput);

    _titleController.text = widget.title;
    _messageController.text = widget.message;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _validateInput() {
    _isAddDraftEnabled.value =
        _titleController.text.isNotEmpty && _messageController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(updateDraftNotifier.select((v) => v.updateDraftState.isLoading));
    return PageLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Edit Draft',
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              AddDraftTextWidget(
                controller: _titleController,
                title: 'Title',
                hintText: 'e.g Staff members',
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              const VerticalSpacing(24),
              AddDraftTextWidget(
                controller: _messageController,
                title: 'Message',
                hintText: 'Type message here',
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              const VerticalSpacing(30),
              ValueListenableBuilder(
                  valueListenable: _isAddDraftEnabled,
                  builder: (context, re, c) {
                    return AppSendButton(
                        isEnabled: re,
                        onTap: () {
                          _updateDraft();
                        },
                        title: 'Update draft');
                  }),
            ],
          ),
        )),
      ),
    );
  }

  void _updateDraft() {
    ref.read(updateDraftNotifier.notifier).updateDrafts(
          data: UpdateDraftRequest(
              process: 'pm_drafts',
              action: widget.service.editAction,
              draftId: widget.draftId,
              title: _titleController.text.trim(),
              message: _messageController.text.trim()),
          onError: (error) {
            context.showError(message: error);
          },
          onSuccess: (message) {
            context.hideOverLay();
            context.showSuccess(message: message);
            context.popAndPushNamed(DraftView.routeName);
          },
        );
  }
}
