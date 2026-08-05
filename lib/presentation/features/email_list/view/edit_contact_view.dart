// lib/presentation/features/email_list/view/edit_contact_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/email_list_model.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/page_loader.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

/// Screen for editing an existing contact's details.
///
/// Push with the contact to edit, e.g.:
/// ```dart
/// final updated = await Navigator.push<EmailContact>(
///   context,
///   MaterialPageRoute(builder: (_) => EditContactView(contact: contact)),
/// );
/// ```
class EditContactView extends ConsumerStatefulWidget {
  const EditContactView({super.key, required this.contact});

  static const String routeName = '/editContact';

  final EmailContact contact;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditContactViewState();
}

class _EditContactViewState extends ConsumerState<EditContactView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  // TODO: wire to a real notifier, e.g.
  // ref.watch(editContactNotifier.select((v) => v.loadState.isLoading))
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.name);
    _emailController = TextEditingController(text: widget.contact.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // TODO: replace with a real call, e.g.
    // await ref.read(editContactNotifier.notifier).update(
    //       widget.contact.copyWith(
    //         name: _nameController.text.trim(),
    //         email: _emailController.text.trim(),
    //       ),
    //     );
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.pop(
      context,
      widget.contact.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Contact'),
      body: PageLoader(
        isLoading: _isSaving,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.primaryF9BC1F,
                            child: Text(
                              widget.contact.name.trim().isEmpty
                                  ? '?'
                                  : widget.contact.name.trim().substring(0, 2),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalSpacing(28),
                    Text('Full name', style: context.textTheme.s14w500),
                    const VerticalSpacing(8),
                    TextFormField(
                      controller: _nameController,
                      decoration: _fieldDecoration('Enter full name'),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? 'Name is required'
                              : null,
                    ),
                    const VerticalSpacing(20),
                    Text('Email address', style: context.textTheme.s14w500),
                    const VerticalSpacing(8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _fieldDecoration('Enter email address'),
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const VerticalSpacing(32),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Save changes',
                          style: context.textTheme.s14w600
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.primaryF5F7F9,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}
