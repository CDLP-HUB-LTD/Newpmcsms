import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/contact/presentation/view/add_group_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/draft_service_tab.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/get_all_drafts_response.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/notifier/get_all_drafts_notifier.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/data/csv_record_parser.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/data/model/notifier/personalised_sms_notifier.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/data/model/send_sms_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/data/model/submit_personalised_sms_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/data/model/submit_personalised_sms_response.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/data/utils/phone_number_utils.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/presentation/notifier/sms_notifier.dart';
import 'package:pmcsms/presentation/features/history/views/history_view.dart';
import 'package:pmcsms/presentation/features/phonebook/presentation/view/phonebook_view.dart';
import 'package:pmcsms/presentation/features/senderid/presentation/model/sender_id_response.dart';
import 'package:pmcsms/presentation/features/senderid/presentation/notifier/sender_id_list_notifier.dart';
import 'package:pmcsms/presentation/features/senderid/views/create_sender_id_view.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

/// Where the recipient list is coming from.
enum _RecipientSource { newEntry, phonebook, uploadFile }

/// Where the message body is coming from.
enum _MessageSource { newEntry, draft }

/// Which bulk-upload template the user picked.
/// template1 -> submit_autocompose_sms (sender_id per row, message per row)
/// template2 -> submit_personalized_sms (single sender_id, message per row
/// with a typed fallback when a row has no message of its own)
enum _UploadTemplate { template1, template2 }

/// Step within the upload-template wizard.
enum _UploadStep { chooseTemplate, uploadFile, message, timing }

class SmsView extends ConsumerStatefulWidget {
  const SmsView({
    super.key,
    this.initialDraftTitle,
    this.initialDraftMessage,
  });
  static const String routeName = '/sms';

  /// Optional pre-fill — used when arriving here via "Send message as SMS"
  /// on a saved draft (see DraftDetails -> ShowMessageOption). Populates
  /// the Subject/Message fields directly rather than going through the
  /// in-screen "pick a draft" flow, since the draft object loaded on
  /// DraftDetails (from get_draft_by_id) uses a different model than the
  /// one this screen's draft picker expects (from get_all_drafts).
  final String? initialDraftTitle;
  final String? initialDraftMessage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SmsViewState();
}

class _SmsViewState extends ConsumerState<SmsView> {
  final _formKey = GlobalKey<FormState>();

  bool _isUploadTab = false;

  final _subjectController = TextEditingController();
  final _recipientsController = TextEditingController();
  final _messageController = TextEditingController();

  String? _selectedSenderId;
  _RecipientSource _recipientSource = _RecipientSource.newEntry;
  _MessageSource _messageSource = _MessageSource.newEntry;

  // The actually-selected draft (not just its title) so the real message
  // body can be sent, not the title string.
  AllDraftsData? _selectedDraft;

  // bool _resendDndOnly = false;
  // bool _refundDndCredits = false;
  // bool _saveAsDraft = false;
  // bool _scheduleMessage = false;

  int? _activeGatewayId;
  bool _gatewayLoading = true;

  _UploadStep _uploadStep = _UploadStep.chooseTemplate;
  _UploadTemplate? _selectedUploadTemplate;
  PlatformFile? _uploadedFile;
  bool _isPickingFile = false;
  final _uploadMessageController = TextEditingController();
  bool _generateWithAi = false;
  bool _uploadSendNow = false;
  DateTime? _uploadScheduleDate;
  TimeOfDay? _uploadScheduleTime;
  String _uploadRepeat = 'Never';
  bool _isSendingUpload = false;

  // Only needed for Template 2 (submit_personalized_sms), which takes a
  // single top-level sender_id rather than one per CSV row.
  String? _uploadSenderId;

  static const List<String> _repeatOptions = [
    'Never',
    'Daily',
    'Weekly',
    'Monthly'
  ];

  @override
  void initState() {
    super.initState();

    // Pre-fill from a draft passed in via ShowMessageOption's "SMS" option.
    if ((widget.initialDraftMessage ?? '').isNotEmpty) {
      _subjectController.text = widget.initialDraftTitle ?? '';
      _messageController.text = widget.initialDraftMessage!;
      _messageSource = _MessageSource.newEntry;
    }

    // NOTE: _loadGateway() and _fetchDrafts() both end up calling
    // `state = state.copyWith(...)` on a notifier as their very first
    // synchronous line (before any `await`). Calling them directly here
    // — instead of deferring like the senderId fetch below already does —
    // mutates a provider while the widget tree is still building, which
    // Riverpod throws on ("Tried to modify a provider while the widget
    // tree was building"). That exception aborted this whole callback
    // before the my_drafts network request was ever sent, which is why
    // the draft picker always looked empty with no request in the logs.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGateway();
      _fetchDrafts();
      ref.read(senderIdListNotifier.notifier).getSenderIds(
            service: 'sms',
            onError: (error) {
              if (mounted) context.showError(message: error);
            },
          );
    });
  }

  Future<void> _loadGateway() async {
    final id =
        await ref.read(smsNotifierProvider.notifier).fetchActiveGateway();
    if (!mounted) return;
    setState(() {
      _activeGatewayId = id;
      _gatewayLoading = false;
    });
  }

  // Reuses the same notifier DraftView already uses.
  void _fetchDrafts() {
    ref
        .read(getAllDraftsNotifier.notifier)
        .getAllDrafts(service: DraftServiceTab.sms, start: 1, length: 20);
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _recipientsController.dispose();
    _messageController.dispose();
    _uploadMessageController.dispose();
    super.dispose();
  }

  void _sendSms() {
    if (!_formKey.currentState!.validate()) return;

    if (_activeGatewayId == null) {
      context.showError(
          message: 'No active SMS gateway found. Please try again.');
      return;
    }

    if (_selectedSenderId == null) {
      context.showError(message: 'Please select a sender ID.');
      return;
    }

    String recipientsValue;
    if (_recipientSource == _RecipientSource.newEntry) {
      final normalized = normalizeRecipientList(_recipientsController.text);
      if (normalized.valid.isEmpty) {
        context.showError(
            message: 'Please add at least one valid recipient number.');
        return;
      }
      if (normalized.invalid.isNotEmpty) {
        context.showError(
          message:
              'Skipped invalid number(s): ${normalized.invalid.join(', ')}',
        );
      }
      recipientsValue = normalized.valid.join(',');
    } else {
      recipientsValue = _recipientsController.text.trim();
      if (recipientsValue.isEmpty) {
        context.showError(message: 'Please add at least one recipient number.');
        return;
      }
    }

    if (_messageSource == _MessageSource.newEntry &&
        _messageController.text.trim().isEmpty) {
      context.showError(message: 'Message content cannot be blank.');
      return;
    }

    if (_messageSource == _MessageSource.draft && _selectedDraft == null) {
      context.showError(message: 'Please select a draft message.');
      return;
    }

    final smsRequest = SendSmsRequest(
      senderId: _selectedSenderId!,
      message: _messageSource == _MessageSource.newEntry
          ? _messageController.text.trim()
          // NOTE: assumes AllDraftsData exposes the full draft body as
          // `.message` — adjust this field name if your model calls it
          // something else (e.g. `.draftMessage`, `.content`).
          : (_selectedDraft?.draftMessage ?? ''),
      recipients: recipientsValue,
      gatewayId: _activeGatewayId!,
    );

    ref.read(smsNotifierProvider.notifier).sendBulkSms(
          request: smsRequest,
          onSuccess: () {
            context.showSuccess(
                message: 'Bulk message dispatched successfully!');
            Navigator.pop(context);
          },
          onError: (errorMessage) {
            context.showError(message: errorMessage);
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    // Keep getAllDraftsNotifier alive for this screen's lifetime. It's an
    // autoDispose provider — without an active `watch` subscription
    // somewhere, Riverpod has no reason to keep it around, so it can get
    // disposed and silently recreated (back to null/empty) between the
    // background fetch in initState and a later read in _openDraftPicker,
    // even though the network call itself succeeded every time. This line
    // doesn't need the value directly; it just holds the subscription open.
    ref.watch(getAllDraftsNotifier);

    final smsState = ref.watch(smsNotifierProvider);
    final isLoading = smsState.isLoading || _gatewayLoading;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'SMS',
        leading: _isUploadTab && _uploadStep != _UploadStep.chooseTemplate
            ? GestureDetector(
                onTap: _goBackAStep,
                child: const Icon(Icons.arrow_back, color: AppColors.black),
              )
            : null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, HistoryView.routeName);
              },
              child: SvgPicture.asset('assets/icons/clock.svg'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VerticalSpacing(16),
              if (_uploadStep == _UploadStep.chooseTemplate) _buildTopTabs(),
              const VerticalSpacing(16),
              Expanded(
                child: _isUploadTab
                    ? _buildUploadTab()
                    : _buildComposeForm(isLoading),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goBackAStep() {
    setState(() {
      switch (_uploadStep) {
        case _UploadStep.uploadFile:
          _uploadStep = _UploadStep.chooseTemplate;
          _selectedUploadTemplate = null;
          break;
        case _UploadStep.message:
          _uploadStep = _UploadStep.uploadFile;
          break;
        case _UploadStep.timing:
          _uploadStep = _selectedUploadTemplate == _UploadTemplate.template2
              ? _UploadStep.message
              : _UploadStep.uploadFile;
          break;
        case _UploadStep.chooseTemplate:
          break;
      }
    });
  }

  Widget _buildTopTabs() {
    return Row(
      children: [
        Expanded(child: _buildTabButton('New message', !_isUploadTab)),
        const SizedBox(width: 8),
        Expanded(child: _buildTabButton('Upload', _isUploadTab)),
      ],
    );
  }

  Widget _buildTabButton(String label, bool selected) {
    return InkWell(
      onTap: () => setState(() {
        _isUploadTab = label == 'Upload';
        _resetUploadFlow();
      }),
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: context.textTheme.s14w500.copyWith(
            color: selected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  void _resetUploadFlow() {
    _uploadStep = _UploadStep.chooseTemplate;
    _selectedUploadTemplate = null;
    _uploadedFile = null;
    _uploadMessageController.clear();
    _generateWithAi = false;
    _uploadSendNow = false;
    _uploadScheduleDate = null;
    _uploadScheduleTime = null;
    _uploadRepeat = 'Never';
    _uploadSenderId = null;
  }

  Widget _buildUploadTab() {
    switch (_uploadStep) {
      case _UploadStep.chooseTemplate:
        return _buildTemplateChooser();
      case _UploadStep.uploadFile:
        return _buildTemplateWizard(_buildUploadFileStep());
      case _UploadStep.message:
        return _buildTemplateWizard(_buildMessageStep());
      case _UploadStep.timing:
        return _buildTemplateWizard(_buildTimingStep());
    }
  }

  Widget _buildTemplateChooser() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _templateCard(
            template: _UploadTemplate.template1,
            title: 'Template 1',
            description:
                'Upload file with sender ID(s), Recipients and generated content added to your needs',
            icon: Icons.description_outlined,
          ),
          const VerticalSpacing(12),
          _templateCard(
            template: _UploadTemplate.template2,
            title: 'Template 2',
            description:
                'Upload file with recipients and a personalized message per recipient',
            icon: Icons.description_outlined,
          ),
        ],
      ),
    );
  }

  Widget _templateCard({
    required _UploadTemplate template,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () => setState(() {
        _selectedUploadTemplate = template;
        _uploadStep = _UploadStep.uploadFile;
      }),
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryE6E6E6),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryF9BC1F.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primaryF9BC1F, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textTheme.s14w600),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: context.textTheme.s12w400
                        .copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateWizard(Widget stepContent) {
    final steps = _selectedUploadTemplate == _UploadTemplate.template2
        ? const [
            _UploadStep.uploadFile,
            _UploadStep.message,
            _UploadStep.timing
          ]
        : const [_UploadStep.uploadFile, _UploadStep.timing];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _selectedUploadTemplate == _UploadTemplate.template2
                ? 'Template 2'
                : 'Template 1',
            textAlign: TextAlign.center,
            style: context.textTheme.s14w600,
          ),
          const VerticalSpacing(12),
          Row(
            children: steps
                .map((step) => Expanded(
                      child: Column(
                        children: [
                          Text(
                            _stepLabel(step),
                            style: context.textTheme.s12w400.copyWith(
                              fontWeight: step == _uploadStep
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: step == _uploadStep
                                  ? AppColors.black
                                  : Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 3,
                            color: step == _uploadStep
                                ? AppColors.black
                                : AppColors.primaryE6E6E6,
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
          const VerticalSpacing(20),
          stepContent,
        ],
      ),
    );
  }

  String _stepLabel(_UploadStep step) {
    switch (step) {
      case _UploadStep.uploadFile:
        return 'Upload file';
      case _UploadStep.message:
        return 'Message';
      case _UploadStep.timing:
        return 'Timing';
      case _UploadStep.chooseTemplate:
        return '';
    }
  }

  Future<void> _pickFile() async {
    setState(() => _isPickingFile = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv', 'xlsx', 'xls'],
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() => _uploadedFile = result.files.single);
      }
    } finally {
      if (mounted) setState(() => _isPickingFile = false);
    }
  }

  Widget _buildUploadFileStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: _isPickingFile ? null : _pickFile,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryE6E6E6),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: _isPickingFile
                ? const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : Column(
                    children: [
                      const Icon(Icons.cloud_upload_outlined, size: 32),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: context.textTheme.s12w400
                              .copyWith(color: AppColors.black),
                          children: [
                            const TextSpan(text: 'Upload your file here '),
                            TextSpan(
                              text: 'browse',
                              style: context.textTheme.s12w500
                                  .copyWith(color: AppColors.primaryF9BC1F),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Max. File size 20MB',
                        style: context.textTheme.s12w400
                            .copyWith(color: Colors.grey[500]),
                      ),
                    ],
                  ),
          ),
        ),
        if (_uploadedFile != null) ...[
          const VerticalSpacing(12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryE6E6E6),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file_outlined, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_uploadedFile!.name} · ${_formatFileSize(_uploadedFile!.size)}',
                    style: context.textTheme.s12w400,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () => setState(() => _uploadedFile = null),
                  child: Text(
                    'Delete',
                    style:
                        context.textTheme.s12w500.copyWith(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
        const VerticalSpacing(12),
        InkWell(
          onTap: () {
            // TODO: point at the real hosted CSV/XLSX template file.
          },
          child: RichText(
            text: TextSpan(
              style:
                  context.textTheme.s12w400.copyWith(color: Colors.grey[600]),
              children: [
                const TextSpan(
                  text: 'Please note that the uploaded file should be in '
                      'the necessary format, i.e Full name, Phone number '
                      'and email(optional). ',
                ),
                TextSpan(
                  text: 'Download template',
                  style: context.textTheme.s12w500
                      .copyWith(color: AppColors.primaryF9BC1F),
                ),
              ],
            ),
          ),
        ),
        const VerticalSpacing(24),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: _uploadedFile == null
                ? null
                : () => setState(() {
                      _uploadStep =
                          _selectedUploadTemplate == _UploadTemplate.template2
                              ? _UploadStep.message
                              : _UploadStep.timing;
                    }),
            style: ElevatedButton.styleFrom(
              backgroundColor: _uploadedFile == null
                  ? AppColors.primaryF9BC1F.withOpacity(0.4)
                  : AppColors.primaryF9BC1F,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Text(
              'Proceed',
              style: context.textTheme.s14w600.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)}kb';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}mb';
  }

  Widget _buildMessageStep() {
    final senderIdState = ref.watch(senderIdListNotifier);
    final activeSenderIds =
        senderIdState.items.where((s) => s.status == 'Active').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // submit_personalized_sms takes a single sender_id, not one per
        // row — Template 1 doesn't need this since its rows carry their
        // own sender_id column.
        Text('Sender ID', style: context.textTheme.s14w500),
        const VerticalSpacing(8),
        _senderIdDropdown(
          items: activeSenderIds,
          value: _uploadSenderId,
          onChanged: (value) => setState(() => _uploadSenderId = value),
        ),
        const VerticalSpacing(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Message', style: context.textTheme.s14w500),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Generate with AI', style: context.textTheme.s12w400),
                Switch(
                  value: _generateWithAi,
                  activeColor: AppColors.primaryF9BC1F,
                  onChanged: (value) {
                    setState(() => _generateWithAi = value);
                    if (value) {
                      // TODO: call the AI content-generation endpoint and
                      // populate _uploadMessageController with the result.
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        const VerticalSpacing(4),
        Text(
          'Used as the message for any row in your file that doesn\'t '
          'already have its own message.',
          style: context.textTheme.s12w400.copyWith(color: Colors.grey[600]),
        ),
        const VerticalSpacing(8),
        TextFormField(
          controller: _uploadMessageController,
          maxLines: 6,
          decoration: _fieldDecoration(hintText: 'Type your message'),
        ),
        const VerticalSpacing(24),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () => setState(() => _uploadStep = _UploadStep.timing),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryF9BC1F,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Text(
              'Proceed',
              style: context.textTheme.s14w600.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  String _formatUploadDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _formatUploadTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  Future<void> _pickUploadDate() async {
    final now = DateTime.now();
    DateTime temp = _uploadScheduleDate ?? now;
    if (temp.isBefore(now)) temp = now;

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 280,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primaryE6E6E6,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  minimumDate: now,
                  initialDateTime: temp,
                  onDateTimeChanged: (value) => temp = value,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black),
                    onPressed: () {
                      setState(() => _uploadScheduleDate = temp);
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickUploadTime() async {
    TimeOfDay temp = _uploadScheduleTime ?? TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: temp);
    if (picked != null) setState(() => _uploadScheduleTime = picked);
  }

  Future<void> _pickUploadRepeat() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _repeatOptions
                .map((option) => ListTile(
                      title: Text(option),
                      trailing: option == _uploadRepeat
                          ? const Icon(Icons.check, color: AppColors.black)
                          : null,
                      onTap: () {
                        setState(() => _uploadRepeat = option);
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  bool get _canSubmitUpload =>
      _uploadSendNow ||
      (_uploadScheduleDate != null && _uploadScheduleTime != null);

  void _submitUpload() {
    if (!_canSubmitUpload || _uploadedFile == null) return;

    final parsed = parseAutocomposeCsv(_uploadedFile!);
    if (parsed.records.isEmpty) {
      context.showError(
        message: parsed.errors.isNotEmpty
            ? parsed.errors.first
            : 'No valid records found in the uploaded file.',
      );
      return;
    }

    if (_activeGatewayId == null) {
      context.showError(
          message: 'No active SMS gateway found. Please try again.');
      return;
    }

    if (_selectedUploadTemplate == _UploadTemplate.template2) {
      _submitPersonalized(parsed.records);
    } else {
      _submitAutocompose(parsed.records);
    }
  }

  // Template 1 -> submit_autocompose_sms: sender_id + message both come
  // from each CSV row.
  void _submitAutocompose(List<Map<String, String>> rawRecords) {
    final invalidPhones = <String>[];
    final records = <AutocomposeRecord>[];

    for (final r in rawRecords) {
      final normalizedPhone = normalizeNigerianPhone(r['phone'] ?? '');
      if (normalizedPhone == null) {
        invalidPhones
            .add(r['phone']?.isNotEmpty == true ? r['phone']! : '(blank)');
        continue;
      }
      records.add(AutocomposeRecord(
        senderId: r['sender_id']!,
        phone: normalizedPhone,
        message: r['message'] ?? '',
      ));
    }

    if (records.isEmpty) {
      context.showError(
          message: 'None of the uploaded phone numbers were valid.');
      return;
    }

    setState(() => _isSendingUpload = true);

    final request = SendAutocomposeSmsRequest(
      gatewayId: _activeGatewayId!,
      records: records,
    );

    ref.read(smsNotifierProvider.notifier).sendAutocomposeSms(
          request: request,
          onSuccess: () {
            setState(() => _isSendingUpload = false);
            _onUploadSendSuccess(skippedCount: invalidPhones.length);
          },
          onError: (errorMessage) {
            setState(() => _isSendingUpload = false);
            context.showError(message: errorMessage);
          },
        );
  }

  // Template 2 -> submit_personalized_sms: one sender_id for the whole
  // batch; each row keeps its own message where present, falling back to
  // the typed message only when a row has none.
  void _submitPersonalized(List<Map<String, String>> rawRecords) {
    if (_uploadSenderId == null) {
      context.showError(message: 'Please select a sender ID.');
      return;
    }

    final invalidPhones = <String>[];
    final records = <PersonalizedSmsRecord>[];

    for (final r in rawRecords) {
      final normalizedPhone = normalizeNigerianPhone(r['phone'] ?? '');
      if (normalizedPhone == null) {
        invalidPhones
            .add(r['phone']?.isNotEmpty == true ? r['phone']! : '(blank)');
        continue;
      }

      final rowMessage = (r['message'] ?? '').trim();
      final message = rowMessage.isNotEmpty
          ? rowMessage
          : _uploadMessageController.text.trim();

      records
          .add(PersonalizedSmsRecord(phone: normalizedPhone, message: message));
    }

    if (records.isEmpty) {
      context.showError(
          message: 'None of the uploaded phone numbers were valid.');
      return;
    }

    setState(() => _isSendingUpload = true);

    final request = SubmitPersonalizedSmsRequest(
      senderId: _uploadSenderId!,
      gatewayId: _activeGatewayId!,
      records: records,
    );

    ref.read(personalizedSmsNotifierProvider.notifier).submit(
          data: request,
          onSuccess: (SubmitPersonalizedSmsResponse response) {
            setState(() => _isSendingUpload = false);
            _onUploadSendSuccess(skippedCount: invalidPhones.length);
          },
          onError: (errorMessage) {
            setState(() => _isSendingUpload = false);
            context.showError(message: errorMessage);
          },
        );
  }

  void _onUploadSendSuccess({int skippedCount = 0}) {
    final skippedNote = skippedCount > 0
        ? ' ($skippedCount number${skippedCount == 1 ? '' : 's'} skipped for being invalid)'
        : '';
    context.showSuccess(
        message: 'Message dispatched successfully!$skippedNote');
    setState(() {
      _isUploadTab = false;
      _resetUploadFlow();
    });
  }

  Widget _buildTimingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RadioListTile<bool>(
          contentPadding: EdgeInsets.zero,
          value: true,
          groupValue: _uploadSendNow,
          activeColor: AppColors.primaryF9BC1F,
          title: Text('New', style: context.textTheme.s12w400),
          subtitle: Text(
            'Send the message to the recipients now',
            style: context.textTheme.s12w400.copyWith(color: Colors.grey[600]),
          ),
          onChanged: (value) => setState(() => _uploadSendNow = value!),
        ),
        RadioListTile<bool>(
          contentPadding: EdgeInsets.zero,
          value: false,
          groupValue: _uploadSendNow,
          activeColor: AppColors.primaryF9BC1F,
          title: Text('Schedule message',
              style: context.textTheme.s12w400
                  .copyWith(fontWeight: FontWeight.w600)),
          subtitle: Text(
            'Select a preferred time to have this message delivered',
            style: context.textTheme.s12w400.copyWith(color: Colors.grey[600]),
          ),
          onChanged: (value) => setState(() => _uploadSendNow = value!),
        ),
        if (!_uploadSendNow) ...[
          const VerticalSpacing(12),
          Text('Date', style: context.textTheme.s14w500),
          const VerticalSpacing(6),
          _dateTimeField(
            value: _uploadScheduleDate == null
                ? 'dd/mm/yyyy'
                : _formatUploadDate(_uploadScheduleDate!),
            onTap: _pickUploadDate,
            icon: Icons.calendar_today_outlined,
          ),
          const VerticalSpacing(16),
          Text('Time', style: context.textTheme.s14w500),
          const VerticalSpacing(6),
          _dateTimeField(
            value: _uploadScheduleTime == null
                ? 'hh:mm'
                : _formatUploadTime(_uploadScheduleTime!),
            onTap: _pickUploadTime,
            icon: Icons.access_time,
          ),
          const VerticalSpacing(16),
          Text('Repeat', style: context.textTheme.s14w500),
          const VerticalSpacing(6),
          InkWell(
            onTap: _pickUploadRepeat,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_uploadRepeat, style: context.textTheme.s12w400),
                const Icon(Icons.chevron_right, color: AppColors.black),
              ],
            ),
          ),
          // NOTE: _uploadScheduleDate/_uploadScheduleTime/_uploadRepeat are
          // collected here but not yet sent — neither
          // SendAutocomposeSmsRequest nor SubmitPersonalizedSmsRequest
          // carries schedule fields, and no "schedule this upload" action
          // has been confirmed by the backend yet.
        ],
        const VerticalSpacing(24),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed:
                (_canSubmitUpload && !_isSendingUpload) ? _submitUpload : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryF9BC1F,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
            child: _isSendingUpload
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    'Send message',
                    style:
                        context.textTheme.s14w600.copyWith(color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _dateTimeField({
    required String value,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryE6E6E6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(child: Text(value, style: context.textTheme.s12w400)),
            Icon(icon, size: 18, color: AppColors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildComposeForm(bool isLoading) {
    final senderIdState = ref.watch(senderIdListNotifier);
    final activeSenderIds =
        senderIdState.items.where((s) => s.status == 'Active').toList();
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fill the form below to send an sms message',
              style:
                  context.textTheme.s12w400.copyWith(color: Colors.grey[600]),
            ),
            const VerticalSpacing(24),
            Text('Sender ID', style: context.textTheme.s14w500),
            const VerticalSpacing(8),
            _senderIdDropdown(
              items: activeSenderIds,
              value: _selectedSenderId,
              onChanged: (value) => setState(() => _selectedSenderId = value),
              validate: true,
            ),
            const VerticalSpacing(6),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, CreateSenderIdView.routeName);
              },
              child: RichText(
                text: TextSpan(
                  style: context.textTheme.s12w400
                      .copyWith(color: Colors.grey[600]),
                  children: [
                    const TextSpan(text: "Don't have a sender ID? "),
                    TextSpan(
                      text: 'Create ID',
                      style: context.textTheme.s12w500
                          .copyWith(color: AppColors.primaryF9BC1F),
                    ),
                  ],
                ),
              ),
            ),
            const VerticalSpacing(20),
            Text('Subject', style: context.textTheme.s14w500),
            const VerticalSpacing(8),
            TextFormField(
              controller: _subjectController,
              decoration: _fieldDecoration(hintText: 'E.g Giveaway'),
            ),
            const VerticalSpacing(20),
            Text('Recipient', style: context.textTheme.s14w500),
            const VerticalSpacing(8),
            _buildRecipientSourcePicker(),
            const VerticalSpacing(8),
            _buildRecipientInput(),
            const VerticalSpacing(20),
            Text('Messages', style: context.textTheme.s14w500),
            const VerticalSpacing(8),
            _buildMessageSourcePicker(),
            const VerticalSpacing(8),
            _buildMessageInput(),
            const VerticalSpacing(24),
            // Text('DND Settings', style: context.textTheme.s14w500),
            // const VerticalSpacing(8),
            // _buildCheckboxRow(
            //   label: 'Resend only DND Affected numbers with corporate route',
            //   value: _resendDndOnly,
            //   onChanged: (v) => setState(() => _resendDndOnly = v ?? false),
            // ),
            // _buildCheckboxRow(
            //   label: 'Refund DND Credits',
            //   value: _refundDndCredits,
            //   onChanged: (v) => setState(() => _refundDndCredits = v ?? false),
            // ),
            // const VerticalSpacing(16),
            // Text('Draft and Schedule Message Settings',
            //     style: context.textTheme.s14w500),
            // const VerticalSpacing(8),
            // _buildCheckboxRow(
            //   label: 'Save message as Draft?',
            //   value: _saveAsDraft,
            //   onChanged: (v) => setState(() => _saveAsDraft = v ?? false),
            // ),
            // _buildCheckboxRow(
            //   label: 'Schedule Message?',
            //   value: _scheduleMessage,
            //   onChanged: (v) => setState(() => _scheduleMessage = v ?? false),
            // ),
            // NOTE: _resendDndOnly / _refundDndCredits / _saveAsDraft /
            // _scheduleMessage are all still collected but not sent —
            // SendSmsRequest has no fields for them yet. Needs backend
            // confirmation of the field names before wiring.
            const VerticalSpacing(32),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : _sendSms,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryF9BC1F,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Send message',
                        style: context.textTheme.s14w600
                            .copyWith(color: Colors.white),
                      ),
              ),
            ),
            if (!_gatewayLoading && _activeGatewayId == null) ...[
              const VerticalSpacing(12),
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.orange, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'No active SMS gateway found. Contact your administrator.',
                      style: context.textTheme.s12w400
                          .copyWith(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ],
            const VerticalSpacing(24),
          ],
        ),
      ),
    );
  }

  /// Shared sender-ID dropdown used by both the compose form and the
  /// Template 2 upload step. Only shows sender IDs with status 'Active' —
  /// pending/failed ones can't be used to send yet.
  Widget _senderIdDropdown({
    required List<SenderIdListItem> items,
    required String? value,
    required ValueChanged<String?> onChanged,
    bool validate = false,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: _fieldDecoration(
        hintText: items.isEmpty ? 'No active sender IDs' : 'Select a sender ID',
      ),
      items: items
          .map((s) =>
              DropdownMenuItem(value: s.senderId, child: Text(s.senderId)))
          .toList(),
      onChanged: items.isEmpty ? null : onChanged,
      validator:
          validate ? (v) => v == null ? 'Sender ID is required' : null : null,
    );
  }

  Widget _buildRecipientSourcePicker() {
    return Row(
      children: [
        _radioOption(
          label: 'New',
          selected: _recipientSource == _RecipientSource.newEntry,
          onTap: () =>
              setState(() => _recipientSource = _RecipientSource.newEntry),
        ),
        _radioOption(
          label: 'Phonebook',
          selected: _recipientSource == _RecipientSource.phonebook,
          onTap: () =>
              setState(() => _recipientSource = _RecipientSource.phonebook),
        ),
        _radioOption(
          label: 'Upload file',
          selected: _recipientSource == _RecipientSource.uploadFile,
          onTap: () =>
              setState(() => _recipientSource = _RecipientSource.uploadFile),
        ),
      ],
    );
  }

  Widget _buildRecipientInput() {
    switch (_recipientSource) {
      case _RecipientSource.newEntry:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _recipientsController,
              keyboardType: TextInputType.phone,
              maxLines: 3,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9, \n]')),
              ],
              decoration: _fieldDecoration(
                hintText: 'Enter phone numbers all separated by commas, ie '
                    '08012345708, 09123456708',
              ),
              validator: (value) {
                if (_recipientSource != _RecipientSource.newEntry) return null;
                if (value == null || value.trim().isEmpty) {
                  return 'Please add at least one recipient number';
                }
                return null;
              },
            ),
            const VerticalSpacing(6),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AddGroupView.routeName);
              },
              child: Text(
                'Create a group?',
                style: context.textTheme.s12w500
                    .copyWith(color: AppColors.primaryF9BC1F),
              ),
            ),
          ],
        );
      case _RecipientSource.phonebook:
        return OutlinedButton.icon(
          onPressed: _openPhonebookPicker,
          icon: const Icon(Icons.contacts_outlined),
          label: const Text('Add recipients from phone book'),
        );
      case _RecipientSource.uploadFile:
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 24.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryE6E6E6),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            children: [
              const Icon(Icons.cloud_upload_outlined, size: 32),
              const SizedBox(height: 8),
              Text('Upload your file here browse',
                  style: context.textTheme.s12w400),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  // TODO: provide/download the CSV template
                },
                child: Text(
                  'Download the csv format for upload here',
                  style: context.textTheme.s12w500
                      .copyWith(color: AppColors.primaryF9BC1F),
                ),
              ),
            ],
          ),
        );
    }
  }

  // NOTE: PhonebookView currently has no "selection mode" — it just shows
  // ContactComponent/GroupComponent with no way to pick contacts and pop
  // back with a result. This push/await will silently return null until
  // PhonebookView (and ContactComponent/GroupComponent) are updated to
  // support picking contacts and calling Navigator.pop(selectedNumbers).
  Future<void> _openPhonebookPicker() async {
    final result = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute(
          builder: (_) => const PhonebookView(isPickerMode: true)),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _recipientSource = _RecipientSource.newEntry;
        final existing = _recipientsController.text.trim();
        _recipientsController.text = [
          if (existing.isNotEmpty) existing,
          ...result,
        ].join(', ');
      });
    }
  }

  Widget _buildMessageSourcePicker() {
    return Row(
      children: [
        _radioOption(
          label: 'New',
          selected: _messageSource == _MessageSource.newEntry,
          onTap: () => setState(() => _messageSource = _MessageSource.newEntry),
        ),
        _radioOption(
          label: 'Draft',
          selected: _messageSource == _MessageSource.draft,
          onTap: () => setState(() => _messageSource = _MessageSource.draft),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    if (_messageSource == _MessageSource.newEntry) {
      return TextFormField(
        controller: _messageController,
        maxLines: 6,
        decoration:
            _fieldDecoration(hintText: 'Type your message text here...'),
        validator: (value) {
          if (_messageSource != _MessageSource.newEntry) return null;
          if (value == null || value.trim().isEmpty) {
            return 'Message content cannot be blank';
          }
          return null;
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: _isLoadingDraftPicker ? null : _openDraftPicker,
          icon: _isLoadingDraftPicker
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add),
          label: const Text('Select from draft'),
        ),
        const VerticalSpacing(8),
        Text(
          _selectedDraft?.draftTitle ?? 'No message selected',
          style: context.textTheme.s12w400.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  bool _isLoadingDraftPicker = false;

  Future<void> _openDraftPicker() async {
    // NOTE: previously this used ref.read(...) to grab whatever state
    // already existed — but _fetchDrafts() in initState is fire-and-forget,
    // so if this is tapped before that request finishes, it captures the
    // still-empty initial state and shows "No drafts saved yet" even when
    // the fetch succeeds moments later. Explicitly awaiting a fresh fetch
    // here closes that race condition.
    setState(() => _isLoadingDraftPicker = true);
    await ref.read(getAllDraftsNotifier.notifier).getAllDrafts(
          service: DraftServiceTab.sms,
          start: 1,
          length: 20,
        );
    if (!mounted) return;
    setState(() => _isLoadingDraftPicker = false);

    final drafts = ref.read(
        getAllDraftsNotifier.select((v) => v.getAllDraftsResponse?.data ?? []));

    final selected = await showModalBottomSheet<AllDraftsData>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        if (drafts.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(24.r),
            child: Text(
              'No drafts saved yet',
              style: context.textTheme.s12w400.copyWith(color: Colors.grey),
            ),
          );
        }
        return SafeArea(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: drafts.length,
            itemBuilder: (context, index) {
              final draft = drafts[index];
              return ListTile(
                title: Text(draft.draftTitle ?? 'Untitled draft'),
                onTap: () => Navigator.pop(context, draft),
              );
            },
          ),
        );
      },
    );

    if (selected != null) {
      setState(() => _selectedDraft = selected);
    }
  }

  Widget _radioOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<bool>(
              value: true,
              groupValue: selected ? true : null,
              onChanged: (_) => onTap(),
              activeColor: AppColors.primaryF9BC1F,
            ),
            Flexible(
              child: Text(label, style: context.textTheme.s12w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxRow({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primaryF9BC1F,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(label, style: context.textTheme.s12w400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(
      {required String hintText, String? helperText}) {
    return InputDecoration(
      hintText: hintText,
      helperText: helperText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AppColors.primaryE6E6E6),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AppColors.primaryF9BC1F),
      ),
    );
  }
}
