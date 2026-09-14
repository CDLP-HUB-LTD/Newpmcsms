import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/whatsapp/presentation/repository/whatsaap_template_repository.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/whatsapp/presentation/repository/whatsapp_message_repository.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/custom_button.dart';
import 'package:pmcsms/presentation/general_widgets/custom_text_field.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class WhatsappMsgTestView extends ConsumerStatefulWidget {
  const WhatsappMsgTestView({super.key});
  static const String routeName = '/whatsapp-msg-test';

  @override
  ConsumerState<WhatsappMsgTestView> createState() =>
      _WhatsappMsgTestViewState();
}

class _WhatsappMsgTestViewState extends ConsumerState<WhatsappMsgTestView> {
  final _numberController = TextEditingController();
  final Map<String, TextEditingController> _paramControllers = {};

  List<WhatsappTemplate> _templates = [];
  WhatsappTemplate? _selectedTemplate;
  bool _isLoadingTemplates = true;
  bool _isSending = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  @override
  void dispose() {
    _numberController.dispose();
    for (final c in _paramControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadTemplates() async {
    setState(() {
      _isLoadingTemplates = true;
      _loadError = null;
    });
    try {
      final templates =
          await ref.read(whatsappTemplateRepositoryProvider).getTemplates();
      setState(() {
        _templates = templates;
        _isLoadingTemplates = false;
      });
    } catch (e) {
      setState(() {
        _loadError = 'Could not load templates. Pull to retry.';
        _isLoadingTemplates = false;
      });
    }
  }

  void _onTemplateSelected(WhatsappTemplate template) {
    setState(() {
      _selectedTemplate = template;
      _paramControllers.clear();
      for (final param in template.requiredParameters) {
        _paramControllers[param] = TextEditingController();
      }
    });
    Navigator.pop(context);
  }

  void _showTemplatePicker() {
    if (_templates.isEmpty) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Template', style: context.textTheme.s16w600),
                const VerticalSpacing(12),
                ...List.generate(_templates.length, (index) {
                  final t = _templates[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(t.code, style: context.textTheme.s14w500),
                    subtitle: Text(
                      t.preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.s12w400
                          .copyWith(color: Colors.grey),
                    ),
                    onTap: () => _onTemplateSelected(t),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendTest() async {
    if (_selectedTemplate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a template first.')),
      );
      return;
    }
    if (_numberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a WhatsApp number.')),
      );
      return;
    }

    setState(() => _isSending = true);
    try {
      final result =
          await ref.read(whatsappMessageRepositoryProvider).sendTestMessage(
                templateId: _selectedTemplate!.id,
                whatsappNumber: _numberController.text.trim(),
                parameters: _paramControllers.map(
                  (key, controller) => MapEntry(key, controller.text.trim()),
                ),
              );

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          title: Text('Test Preview', style: context.textTheme.s14w600),
          content: Text(
            result.previewMessage ?? 'No preview returned.',
            style: context.textTheme.s12w400,
          ),
          actions: [
            CustomButton(
              text: 'Close',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Test send failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Test Transactional Whatsapp MSG'),
      body: SafeArea(
        child: _isLoadingTemplates
            ? const Center(child: CircularProgressIndicator())
            : _loadError != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_loadError!, style: context.textTheme.s12w400),
                        const VerticalSpacing(8),
                        CustomButton(
                          text: 'Retry',
                          onPressed: _loadTemplates,
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          label: 'Template',
                          hintText: 'Select a template',
                          readOnly: true,
                          controller: TextEditingController(
                            text: _selectedTemplate?.code ?? '',
                          ),
                          suffixIcon: const Icon(Icons.keyboard_arrow_down),
                          onTap: _showTemplatePicker,
                        ),
                        const VerticalSpacing(12),
                        CustomTextField(
                          label: 'Whatsapp Number',
                          hintText: 'Enter whatsapp number',
                          controller: _numberController,
                          keyboardType: TextInputType.phone,
                        ),
                        if (_selectedTemplate != null &&
                            _selectedTemplate!
                                .requiredParameters.isNotEmpty) ...[
                          const VerticalSpacing(16),
                          Text(
                            'Template Parameters',
                            style: context.textTheme.s12w500,
                          ),
                          const VerticalSpacing(8),
                          ..._selectedTemplate!.requiredParameters.map((param) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: CustomTextField(
                                label: param,
                                hintText: 'Enter value for $param',
                                controller: _paramControllers[param],
                              ),
                            );
                          }),
                        ],
                        const VerticalSpacing(24),
                        CustomButton(
                          text: _isSending ? 'Sending...' : 'Send Test',
                          onPressed: _isSending ? null : _sendTest,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
