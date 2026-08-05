// lib/presentation/features/email_list/presentation/models/email_list_model.dart
//
// Shared models used across the Email List feature (contacts + groups tabs).
// TODO: Replace with your real domain models once contacts/groups
// repositories are wired up.

class EmailContact {
  const EmailContact({
    required this.id,
    required this.name,
    required this.email,
    this.groupIds = const [],
  });

  final String id;
  final String name;
  final String email;
  final List<String> groupIds;

  EmailContact copyWith({
    String? name,
    String? email,
    List<String>? groupIds,
  }) {
    return EmailContact(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      groupIds: groupIds ?? this.groupIds,
    );
  }
}

class EmailGroup {
  const EmailGroup({
    required this.id,
    required this.name,
    this.contactCount = 0,
  });

  final String id;
  final String name;
  final int contactCount;

  EmailGroup copyWith({String? name, int? contactCount}) {
    return EmailGroup(
      id: id,
      name: name ?? this.name,
      contactCount: contactCount ?? this.contactCount,
    );
  }
}
