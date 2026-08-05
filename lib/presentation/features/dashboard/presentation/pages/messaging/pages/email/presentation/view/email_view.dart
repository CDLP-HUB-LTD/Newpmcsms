import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
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
  const EmailView({super.key});
  static const String routeName = '/emailView';

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

  // TODO: replace with the real draft model once wired up.
  String? _selectedDraftTitle;

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

  void _sendEmail() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSenderId == null) {
      // TODO: surface via context.showError once an email notifier exists
      return;
    }

    if (_recipientSource == _RecipientSource.newEntry &&
        _recipientsController.text.trim().isEmpty) {
      return;
    }

    if (_messageSource == _MessageSource.newEntry &&
        _messageController.text.trim().isEmpty) {
      return;
    }

    if (_messageSource == _MessageSource.draft && _selectedDraftTitle == null) {
      return;
    }

    // TODO: wire up to an email notifier, e.g.
    // ref.read(emailNotifierProvider.notifier).sendBulkEmail(request: ...)
    setState(() => _isSending = true);
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
                // TODO: Route to Email history
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

  // ── STEP 1: UPLOAD FILE ─────────────────────────────────────────────────
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

  void _submitUpload() {
    if (!_canSubmitUpload || _uploadedFile == null) return;
    setState(() => _isSendingUpload = true);

    // TODO: build the real bulk-upload request (file, template type,
    // message body if Template 2, schedule fields) and call the email notifier.

    setState(() => _isSendingUpload = false);
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

  // ── COMPOSE FORM (unchanged) ────────────────────────────────────────────
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
                // TODO: route to create sender ID flow
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
    const senderIds = <String>[];
    return DropdownButtonFormField<String>(
      initialValue: _selectedSenderId,
      isExpanded: true,
      decoration: _fieldDecoration(hintText: 'Select a user ID'),
      items: senderIds
          .map((id) => DropdownMenuItem(value: id, child: Text(id)))
          .toList(),
      onChanged: (value) => setState(() => _selectedSenderId = value),
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
        return OutlinedButton.icon(
          onPressed: () {
            // TODO: open email list picker
          },
          icon: const Icon(Icons.contacts_outlined),
          label: const Text('Add recipients from email list'),
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
          onPressed: () {
            // TODO: open a bottom sheet / picker of drafts and set
            // _selectedDraftTitle on selection.
          },
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
