import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/draft_service_tab.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/get_all_drafts_response.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/notifier/get_all_drafts_notifier.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/email/logic/email_notifier.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/email_list_model.dart';
import 'package:pmcsms/presentation/features/history/views/history_view.dart';
import 'package:pmcsms/presentation/features/senderid/views/create_sender_id_view.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

/// Where the recipient list is coming from.
enum _RecipientSource { newEntry, emailList, uploadFile }

/// Where the message body is coming from.
enum _MessageSource { newEntry, draft }

/// Which bulk-upload template the user picked.
enum _UploadTemplate { template1, template2 }

/// Step within the upload-template wizard.
enum _UploadStep { chooseTemplate, uploadFile, message, timing }

class EmailView extends ConsumerStatefulWidget {
  const EmailView({
    super.key,
    this.initialDraftTitle,
    this.initialDraftMessage,
  });
  static const String routeName = '/emailView';
  final String? initialDraftTitle;
  final String? initialDraftMessage;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailViewState();
}

class _EmailViewState extends ConsumerState<EmailView> {
  final _formKey = GlobalKey<FormState>();

  // Top-level tab: compose a new message vs. bulk-upload via template.
  bool _isUploadTab = false;

  final _subjectController = TextEditingController();
  final _recipientsController = TextEditingController();
  final _messageController = TextEditingController();

  String? _selectedSenderId;
  _RecipientSource _recipientSource = _RecipientSource.newEntry;
  _MessageSource _messageSource = _MessageSource.newEntry;

  // ── EMAIL LIST recipient source state ──────────────────────────────────
  final Set<String> _selectedContactEmails = {};

  // ── UPLOAD FILE recipient source state (compose tab) ───────────────────
  PlatformFile? _recipientUploadFile;
  bool _isPickingRecipientFile = false;
  List<String> _recipientFileEmails = [];
  String? _recipientFileError;

  // ── DRAFT message source state ──────────────────────────────────────────
  String? _selectedDraftTitle;
  String? _selectedDraftBody;
  bool _isLoadingDrafts = false;

  bool _saveAsDraft = false;
  bool _scheduleMessage = false;

  bool _isSending = false;

  // ── UPLOAD-TEMPLATE WIZARD STATE ───────────────────────────────────────
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

  static const List<String> _repeatOptions = [
    'Never',
    'Daily',
    'Weekly',
    'Monthly'
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _recipientsController.dispose();
    _messageController.dispose();
    _uploadMessageController.dispose();
    super.dispose();
  }

  // ── SEND (compose form) ───────────────────────────────────────────────
  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSenderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a sender ID')),
      );
      return;
    }

    String recipients;
    switch (_recipientSource) {
      case _RecipientSource.newEntry:
        recipients = _recipientsController.text.trim();
        if (recipients.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please add at least one recipient')),
          );
          return;
        }
        break;

      case _RecipientSource.emailList:
        if (_selectedContactEmails.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select at least one contact')),
          );
          return;
        }
        recipients = _selectedContactEmails.join(',');
        break;

      case _RecipientSource.uploadFile:
        if (_recipientFileEmails.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_recipientFileError ??
                  'Please upload a file with at least one recipient'),
            ),
          );
          return;
        }
        recipients = _recipientFileEmails.join(',');
        break;
    }

    String message;
    if (_messageSource == _MessageSource.newEntry) {
      message = _messageController.text.trim();
      if (message.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message content cannot be blank')),
        );
        return;
      }
    } else {
      if (_selectedDraftTitle == null || _selectedDraftBody == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a draft')),
        );
        return;
      }
      message = _selectedDraftBody!;
    }

    setState(() => _isSending = true);

    final success =
        await ref.read(emailNotifierProvider.notifier).sendBulkEmail(
              senderId: _selectedSenderId!,
              subject: _subjectController.text.trim(),
              message: '<p>$message</p>',
              recipients: recipients,
            );

    if (!mounted) return;
    setState(() => _isSending = false);

    final errorMessage = ref.read(emailNotifierProvider).errorMessage;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? 'Email sent successfully'
            : (errorMessage ?? 'Failed to send email')),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      _formKey.currentState!.reset();
      _subjectController.clear();
      _recipientsController.clear();
      _messageController.clear();
      setState(() {
        _selectedContactEmails.clear();
        _recipientUploadFile = null;
        _recipientFileEmails = [];
        _recipientFileError = null;
        _selectedDraftTitle = null;
        _selectedDraftBody = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Email',
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
                child: _isUploadTab ? _buildUploadTab() : _buildComposeForm(),
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

  // ── TOP TABS: "New message" | "Upload" ────────────────────────────────
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
  }

  // ── UPLOAD TAB (template flow) ──────────────────────────────────────────
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
                'Upload file with sender ID(s), Recipients and use as generated content suited to your needs',
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

  // ── FILE PARSING HELPERS ────────────────────────────────────────────────
  //
  // Expected upload format (per the on-screen hint): "Full name, Email
  // address, phone(optional)". We parse plain CSV text client-side to
  // resolve recipient emails. XLS/XLSX files can't be parsed without an
  // extra package (e.g. `excel`) — if xlsx support is required end-to-end,
  // add that dependency and branch on file extension here.
  //
  // TODO: confirm with backend whether the server would rather receive the
  // raw file (multipart) and resolve recipients itself, instead of us
  // parsing client-side and sending a flat comma-separated string through
  // the existing sendBulkEmail(recipients: ...) contract.
  List<String> _extractEmailsFromCsvBytes(List<int>? bytes) {
    if (bytes == null) return [];
    final content = utf8.decode(bytes, allowMalformed: true);
    final lines = content
        .split(RegExp(r'\r\n|\r|\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    final emailRegex = RegExp(r'^[\w\.\-\+]+@[\w\-]+\.[\w\-\.]+$');
    final emails = <String>[];

    for (var i = 0; i < lines.length; i++) {
      final cols = lines[i].split(',').map((c) => c.trim()).toList();
      for (final col in cols) {
        if (emailRegex.hasMatch(col)) {
          emails.add(col);
          break; // one email per row
        }
      }
    }

    return emails.toSet().toList(); // de-dupe
  }

  // ── STEP 1: UPLOAD FILE (bulk-upload wizard) ────────────────────────────
  Future<void> _pickFile() async {
    setState(() => _isPickingFile = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv', 'xlsx', 'xls'],
        withData: true,
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
                      'the necessary format, i.e Full name, Email address '
                      'and phone(optional). ',
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

  // ── STEP 2 (Template 2 only): MESSAGE ───────────────────────────────────
  Widget _buildMessageStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                      // No such endpoint is wired up on emailNotifierProvider
                      // yet — flagging rather than guessing a contract.
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        const VerticalSpacing(8),
        TextFormField(
          controller: _uploadMessageController,
          maxLines: 6,
          onChanged: (_) => setState(() {}),
          decoration: _fieldDecoration(hintText: 'Type your message'),
        ),
        const VerticalSpacing(24),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: _uploadMessageController.text.trim().isEmpty
                ? null
                : () => setState(() => _uploadStep = _UploadStep.timing),
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

  // ── STEP 3: TIMING (New vs Schedule) ────────────────────────────────────
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

  Future<void> _submitUpload() async {
    if (!_canSubmitUpload || _uploadedFile == null) return;

    if (_selectedSenderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a sender ID first')),
      );
      return;
    }

    final recipients = _extractEmailsFromCsvBytes(_uploadedFile!.bytes);
    if (recipients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('No valid email addresses were found in the uploaded file'),
        ),
      );
      return;
    }

    // Template 2 has an explicit message; Template 1 relies on
    // server-side generated content, which isn't wired up yet.
    final message = _selectedUploadTemplate == _UploadTemplate.template2
        ? _uploadMessageController.text.trim()
        : null;

    if (_selectedUploadTemplate == _UploadTemplate.template2 &&
        (message == null || message.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message content cannot be blank')),
      );
      return;
    }

    if (_selectedUploadTemplate == _UploadTemplate.template1) {
      // TODO: Template 1 needs a backend endpoint that accepts the raw file
      // and generates per-recipient content server-side — sendBulkEmail
      // requires a single `message` string, so there's no safe way to
      // submit this template against the current contract without either
      // fabricating placeholder copy or guessing at a new endpoint shape.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Template 1 (auto-generated content) isn\'t wired up to a backend endpoint yet'),
        ),
      );
      return;
    }

    // TODO: _uploadScheduleDate / _uploadScheduleTime / _uploadRepeat are
    // collected but sendBulkEmail has no schedule/repeat params — confirm
    // the real scheduling contract (likely a separate endpoint/action)
    // before wiring these through.
    if (!_uploadSendNow) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Scheduled bulk sends aren\'t wired up to a backend endpoint yet — send now instead'),
        ),
      );
      return;
    }

    setState(() => _isSendingUpload = true);

    final success =
        await ref.read(emailNotifierProvider.notifier).sendBulkEmail(
              senderId: _selectedSenderId!,
              subject: _subjectController.text.trim(),
              message: '<p>$message</p>',
              recipients: recipients.join(','),
            );

    if (!mounted) return;

    final errorMessage = ref.read(emailNotifierProvider).errorMessage;
    setState(() => _isSendingUpload = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? 'Bulk email sent to ${recipients.length} recipient(s)'
            : (errorMessage ?? 'Failed to send bulk email')),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      setState(() {
        _isUploadTab = false;
        _resetUploadFlow();
      });
    }
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

  // ── COMPOSE FORM ─────────────────────────────────────────────────────────
  Widget _buildComposeForm() {
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
            _buildSenderIdDropdown(),
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
            Text('Draft and Schedule Message Settings',
                style: context.textTheme.s14w500),
            const VerticalSpacing(8),
            _buildCheckboxRow(
              label: 'Save message as Draft?',
              value: _saveAsDraft,
              onChanged: (v) => setState(() => _saveAsDraft = v ?? false),
            ),
            _buildCheckboxRow(
              label: 'Schedule Message?',
              value: _scheduleMessage,
              onChanged: (v) => setState(() => _scheduleMessage = v ?? false),
            ),
            const VerticalSpacing(32),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryF9BC1F,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                child: _isSending
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
            const VerticalSpacing(24),
          ],
        ),
      ),
    );
  }

  Widget _buildSenderIdDropdown() {
    final emailState = ref.watch(emailNotifierProvider);
    final senderIds = emailState.senderIds;

    return DropdownButtonFormField<String>(
      initialValue: _selectedSenderId,
      isExpanded: true,
      decoration: _fieldDecoration(
        hintText: emailState.isLoadingSenderIds
            ? 'Loading sender IDs...'
            : 'Select a sender ID',
      ),
      items: senderIds
          .map((id) => DropdownMenuItem(value: id, child: Text(id)))
          .toList(),
      onChanged: emailState.isLoadingSenderIds
          ? null
          : (value) => setState(() => _selectedSenderId = value),
      validator: (value) => value == null ? 'Sender ID is required' : null,
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
          label: 'Email list',
          selected: _recipientSource == _RecipientSource.emailList,
          onTap: () =>
              setState(() => _recipientSource = _RecipientSource.emailList),
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
              maxLines: 3,
              decoration: _fieldDecoration(
                hintText: 'Enter phone numbers all separated by commas, ie '
                    '08012345708, 09123456708',
              ),
              validator: (value) {
                if (_recipientSource != _RecipientSource.newEntry) return null;
                if (value == null || value.trim().isEmpty) {
                  return 'Please add at least one recipient';
                }
                return null;
              },
            ),
            const VerticalSpacing(6),
            InkWell(
              onTap: () {
                // TODO: route to create-a-group flow
              },
              child: Text(
                'Create a group?',
                style: context.textTheme.s12w500
                    .copyWith(color: AppColors.primaryF9BC1F),
              ),
            ),
          ],
        );

      case _RecipientSource.emailList:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton.icon(
              onPressed: _openContactPicker,
              icon: const Icon(Icons.contacts_outlined),
              label: Text(
                _selectedContactEmails.isEmpty
                    ? 'Add recipients from email list'
                    : '${_selectedContactEmails.length} contact(s) selected',
              ),
            ),
            if (_selectedContactEmails.isNotEmpty) ...[
              const VerticalSpacing(8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _selectedContactEmails
                    .map((email) => Chip(
                          label: Text(email, style: context.textTheme.s12w400),
                          onDeleted: () => setState(
                              () => _selectedContactEmails.remove(email)),
                        ))
                    .toList(),
              ),
            ],
          ],
        );

      case _RecipientSource.uploadFile:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _isPickingRecipientFile ? null : _pickRecipientFile,
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryE6E6E6),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: _isPickingRecipientFile
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
              ),
            ),
            if (_recipientUploadFile != null) ...[
              const VerticalSpacing(12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                        _recipientFileError ??
                            '${_recipientUploadFile!.name} · ${_recipientFileEmails.length} email(s) found',
                        style: context.textTheme.s12w400.copyWith(
                          color:
                              _recipientFileError != null ? Colors.red : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() {
                        _recipientUploadFile = null;
                        _recipientFileEmails = [];
                        _recipientFileError = null;
                      }),
                      child: Text(
                        'Delete',
                        style: context.textTheme.s12w500
                            .copyWith(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
    }
  }

  Future<void> _pickRecipientFile() async {
    setState(() => _isPickingRecipientFile = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv', 'xlsx', 'xls'],
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        final emails = _extractEmailsFromCsvBytes(file.bytes);
        setState(() {
          _recipientUploadFile = file;
          _recipientFileEmails = emails;
          _recipientFileError =
              emails.isEmpty ? 'No valid email addresses found' : null;
        });
      }
    } finally {
      if (mounted) setState(() => _isPickingRecipientFile = false);
    }
  }

  // ── EMAIL LIST contact picker ────────────────────────────────────────────
  //
  // TODO: EmailListView currently sources its `_contacts` from a hardcoded
  // local list (see email_list_view.dart), not a shared provider. Swap
  // `_placeholderContacts` below for the real contacts provider once one
  // exists — the picker UI and selection wiring are ready either way.
  static const List<EmailContact> _placeholderContacts = [];

  Future<void> _openContactPicker() async {
    final contacts = _placeholderContacts; // TODO: source from provider
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        final localSelection = Set<String>.from(_selectedContactEmails);
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select recipients',
                            style: context.textTheme.s16w600),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    const VerticalSpacing(8),
                    if (contacts.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'No contacts available yet. Add contacts from the '
                          'Email List page first.',
                          style: context.textTheme.s12w400
                              .copyWith(color: Colors.grey[600]),
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: contacts.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, index) {
                            final contact = contacts[index];
                            final selected =
                                localSelection.contains(contact.email);
                            return CheckboxListTile(
                              value: selected,
                              activeColor: AppColors.primaryF9BC1F,
                              title: Text(contact.name),
                              subtitle: Text(contact.email),
                              onChanged: (checked) => setSheetState(() {
                                if (checked == true) {
                                  localSelection.add(contact.email);
                                } else {
                                  localSelection.remove(contact.email);
                                }
                              }),
                            );
                          },
                        ),
                      ),
                    const VerticalSpacing(16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryF9BC1F,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () =>
                            Navigator.pop(sheetContext, localSelection),
                        child: Text(
                          'Add ${localSelection.length} recipient(s)',
                          style: context.textTheme.s14w600
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedContactEmails
          ..clear()
          ..addAll(result);
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
          onTap: () async {
            setState(() => _messageSource = _MessageSource.draft);
            await _loadDraftsIfNeeded();
          },
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
          onPressed: _openDraftPicker,
          icon: const Icon(Icons.add),
          label: const Text('Select from draft'),
        ),
        const VerticalSpacing(8),
        Text(
          _selectedDraftTitle ?? 'No message selected',
          style: context.textTheme.s12w400.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  // ── DRAFT picker ─────────────────────────────────────────────────────────
  //
  // TODO: `AllDraftsData` is assumed to expose a body-text field beyond
  // `draftTitle` (e.g. `draftMessage` / `content`) — confirm the exact field
  // name against the model and swap `_draftBody` below. Falling back to the
  // title keeps this compiling/functional in the meantime rather than
  // guessing at a field that may not exist.
  String _draftBody(AllDraftsData draft) {
    // TODO: replace with the real body field, e.g. `draft.draftMessage`.
    return draft.draftTitle ?? '';
  }

  Future<void> _loadDraftsIfNeeded() async {
    final drafts = ref.read(
      getAllDraftsNotifier.select((v) => v.getAllDraftsResponse?.data ?? []),
    );
    if (drafts.isNotEmpty) return;

    setState(() => _isLoadingDrafts = true);
    await ref.read(getAllDraftsNotifier.notifier).getAllDrafts(
          service: DraftServiceTab.sms,
          start: 1,
          length: 50,
        );
    if (mounted) setState(() => _isLoadingDrafts = false);
  }

  Future<void> _openDraftPicker() async {
    await _loadDraftsIfNeeded();
    if (!mounted) return;

    final drafts = ref.read(
      getAllDraftsNotifier.select((v) => v.getAllDraftsResponse?.data ?? []),
    );

    final selected = await showModalBottomSheet<AllDraftsData>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select a draft', style: context.textTheme.s16w600),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
                const VerticalSpacing(8),
                if (_isLoadingDrafts)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (drafts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'No drafts saved yet.',
                      style: context.textTheme.s12w400
                          .copyWith(color: Colors.grey[600]),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: drafts.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, index) {
                        final draft = drafts[index];
                        return ListTile(
                          title: Text(draft.draftTitle ?? 'Untitled draft'),
                          onTap: () => Navigator.pop(sheetContext, draft),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedDraftTitle = selected.draftTitle ?? 'Untitled draft';
        _selectedDraftBody = _draftBody(selected);
      });
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(emailNotifierProvider.notifier).fetchSenderIds();
    });
  }
}
