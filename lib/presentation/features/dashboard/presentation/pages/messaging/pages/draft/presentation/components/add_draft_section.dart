import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/add_draft_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/draft_service_tab.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/components/add_drafts_text_widget.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/notifier/add_draft_notifier.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/view/draft_view.dart';
import 'package:pmcsms/presentation/general_widgets/app_send_button.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/page_loader.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class AddDraftSection extends ConsumerStatefulWidget {
  const AddDraftSection({super.key});
  static const String routeName = '/addDraft';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddDraftSectionState();
}

class _AddDraftSectionState extends ConsumerState<AddDraftSection> {
  final ValueNotifier<bool> _isAddDraftEnabled = ValueNotifier(false);

  late TextEditingController _titleController;
  late TextEditingController _messageController;

  DraftServiceTab _service = DraftServiceTab.sms;
  bool _serviceResolved = false;

  @override
  void initState() {
    _titleController = TextEditingController()..addListener(_validateInput);
    _messageController = TextEditingController()..addListener(_validateInput);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_serviceResolved) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is DraftServiceTab) _service = arg;
      _serviceResolved = true;
    }
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
    final isLoading =
        ref.watch(addDraftsNotifier.select((v) => v.addDraftsState.isLoading));
    return PageLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: CustomAppBar(
          title: _service == DraftServiceTab.voice ? 'Add Voice Draft' : 'Add',
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
                          _addDraft();
                        },
                        title: 'Add to draft');
                  }),
            ],
          ),
        )),
      ),
    );
  }

  void _addDraft() {
    ref.read(addDraftsNotifier.notifier).addDrafts(
          data: AddDraftsRequests(
              process: 'pm_drafts',
              action: _service.addAction,
              title: _titleController.text.trim(),
              message: _messageController.text.trim()),
          onError: (error) {
            context.showError(message: error);
          },
          onSuccess: (message) {
            context.hideOverLay();
            context.showSuccess(message: message);
            context.pushNamed(DraftView.routeName);
          },
        );
  }
}
