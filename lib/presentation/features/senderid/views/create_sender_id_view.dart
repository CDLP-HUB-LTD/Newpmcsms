import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/senderid/views/create_sender_id_notifier.dart';
import 'package:pmcsms/presentation/features/senderid/views/create_sender_id_request.dart';
// Reuses the SenderIdServiceTab enum + .apiValue/.label mapping defined in
// sender_id_view.dart, so "sms"/"email"/"voice" is only ever mapped in one
// place. If you'd rather this be its own file (e.g. sender_id_service.dart),
// move the enum there and import it from both screens instead.
import 'package:pmcsms/presentation/features/senderid/views/sender_id_view.dart'
    show SenderIdServiceTab, SenderIdServiceTabX;
import 'package:pmcsms/presentation/features/senderid/views/otp_verification_view.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class CreateSenderIdView extends ConsumerStatefulWidget {
  const CreateSenderIdView({super.key});
  static const String routeName = '/createSenderId';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateSenderIdViewState();
}

class _CreateSenderIdViewState extends ConsumerState<CreateSenderIdView> {
  SenderIdServiceTab? _selectedService;
  final _senderIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _senderIdController.addListener(() => setState(() {}));
    // Pre-select the service the user came from (passed as the route
    // argument from SenderIdView's FAB, e.g. 'sms' / 'email' / 'voice').
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is String) {
        final match =
            SenderIdServiceTab.values.where((t) => t.apiValue == arg).toList();
        if (match.isNotEmpty) {
          setState(() => _selectedService = match.first);
        }
      }
    });
  }

  @override
  void dispose() {
    _senderIdController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _selectedService != null && _senderIdController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(createSenderIdNotifier.select((v) => v.isLoading));

    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Sender ID'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Service', style: context.textTheme.s12w400),
              const VerticalSpacing(6),
              DropdownButtonFormField<SenderIdServiceTab>(
                value: _selectedService,
                hint: const Text('Select a service'),
                items: SenderIdServiceTab.values
                    .map((tab) => DropdownMenuItem(
                          value: tab,
                          child: Text(tab.label),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedService = val),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.primaryF5F7F9,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const VerticalSpacing(16),
              Text('Sender ID', style: context.textTheme.s12w400),
              const VerticalSpacing(6),
              TextField(
                controller: _senderIdController,
                decoration: InputDecoration(
                  hintText: 'Eg. PMCSMS',
                  filled: true,
                  fillColor: AppColors.primaryF5F7F9,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const VerticalSpacing(8),
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Colors.grey),
                  const HorizontalSpacing(4),
                  Text(
                    'Please use alphanumeric combinations.',
                    style: context.textTheme.s12w400.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: Size.fromHeight(48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: (_canSubmit && !isLoading) ? _submit : null,
                child: isLoading
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Create',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Wired to create_sender_id:
  /// { "process": "pm_messaging", "action": "create_sender_id",
  ///   "service": "<sms|email|voice>", "sender_id": "<value>" }
  ///
  /// Confirmed against the "Create Sender ID (Voice)" Postman spec — note
  /// the field is `sender_id`, not `senderId`/`sender_name`, and `service`
  /// is lowercase with no "SMS" suffix even for voice.
  void _submit() {
    final service = _selectedService;
    if (service == null) return;

    final senderId = _senderIdController.text.trim();

    final data = CreateSenderIdRequest(
      process: 'pm_messaging',
      action: 'create_sender_id',
      service: service.apiValue,
      senderId: senderId,
    );

    ref.read(createSenderIdNotifier.notifier).createSenderId(
          data: data,
          onError: (error) {
            context.showError(message: error);
          },
          onSuccess: (message) {
            // NOTE: branching preserved from the original screen — Email and
            // Voice SMS both route to OTP verification, SMS goes straight to
            // the "under review" modal. This matches the existing behavior,
            // not the audit note that said OTP applies to email only; confirm
            // against your OTP-request endpoint which of the two is correct
            // for Voice SMS before shipping.
            if (service == SenderIdServiceTab.email ||
                service == SenderIdServiceTab.voiceSms) {
              context.pushNamed(
                OtpVerificationView.routeName,
                arguments: {
                  'senderId': senderId,
                  'service': service.apiValue,
                },
              );
            } else {
              _showUnderReviewModal(context);
            }
          },
        );
  }

  void _showUnderReviewModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_top_rounded,
                size: 48, color: Colors.amber[600]),
            const VerticalSpacing(16),
            Text('Under Review', style: context.textTheme.s18w500),
            const VerticalSpacing(8),
            Text(
              'The ID is under review by admin. Approval takes between 24 to 48 hours. You will be able to use it once it\'s been approved.',
              textAlign: TextAlign.center,
              style: context.textTheme.s12w400.copyWith(color: Colors.grey),
            ),
            const VerticalSpacing(20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                minimumSize: Size.fromHeight(44.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Close sheet
                Navigator.pop(context); // Return to list
              },
              child:
                  const Text('Continue', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
