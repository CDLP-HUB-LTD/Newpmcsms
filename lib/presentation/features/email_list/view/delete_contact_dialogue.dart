// lib/presentation/features/email_list/view/delete_contact_dialogue.dart
import 'package:flutter/material.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';

/// Shows a confirmation dialog before deleting a contact.
/// Returns `true` if the user confirmed the deletion, `false`/`null` otherwise.
///
/// Usage:
/// ```dart
/// final confirmed = await showDeleteContactDialog(context, contactName: contact.name);
/// if (confirmed == true) {
///   // TODO: ref.read(contactsNotifier.notifier).delete(contact.id);
/// }
/// ```
Future<bool?> showDeleteContactDialog(
  BuildContext context, {
  required String contactName,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text('Delete contact?', style: dialogContext.textTheme.s16w600),
      content: Text(
        'Are you sure you want to delete $contactName from your contacts? '
        'This action cannot be undone.',
        style: dialogContext.textTheme.s14w400,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(
            'Cancel',
            style: dialogContext.textTheme.s14w500
                .copyWith(color: Colors.grey[700]),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(
            'Delete',
            style: dialogContext.textTheme.s14w600.copyWith(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}
