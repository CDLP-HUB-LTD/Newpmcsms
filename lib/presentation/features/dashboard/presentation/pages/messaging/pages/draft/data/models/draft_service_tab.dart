// lib/presentation/features/dashboard/presentation/pages/messaging/pages/draft/presentation/model/draft_service_tab.dart
enum DraftServiceTab { sms, voice }

extension DraftServiceTabX on DraftServiceTab {
  /// Confirmed: my_drafts / my_voice_drafts (list), add_draft / add_voice_draft (create).
  /// GUESSED, unconfirmed against any sample response: edit_voice_draft, delete_voice_draft,
  /// view_voice_draft.
  String get listAction =>
      this == DraftServiceTab.voice ? 'my_voice_drafts' : 'my_drafts';

  String get addAction =>
      this == DraftServiceTab.voice ? 'add_voice_draft' : 'add_draft';

  String get editAction =>
      this == DraftServiceTab.voice ? 'edit_voice_draft' : 'edit_draft';

  String get deleteAction =>
      this == DraftServiceTab.voice ? 'delete_voice_draft' : 'delete_draft';

  String get viewAction =>
      this == DraftServiceTab.voice ? 'view_voice_draft' : 'view_draft';

  String get label => this == DraftServiceTab.voice ? 'Voice SMS' : 'SMS';
}
