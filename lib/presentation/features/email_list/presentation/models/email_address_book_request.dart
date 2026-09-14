class GetEmailAddressBooksRequest {
  final String process;
  final String action;
  final int start;
  final int length;

  GetEmailAddressBooksRequest({
    this.process = 'pm_address_books',
    this.action = 'get_user_email_address_books',
    required this.start,
    required this.length,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'start': start,
        'length': length,
      };
}

class AddEmailAddressBookRequest {
  final String process;
  final String action;
  final int groupId;
  final String ownerName;

  /// Comma-separated for multiple contacts,
  /// e.g. "john@example.com,jane@example.com"
  final String addressBook;

  AddEmailAddressBookRequest({
    this.process = 'pm_address_books',
    this.action = 'add_email_address_book',
    required this.groupId,
    required this.ownerName,
    required this.addressBook,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'group_id': groupId,
        'owner_name': ownerName,
        'address_book': addressBook,
      };
}

class EditEmailAddressBookRequest {
  final String process;
  final String action;
  final int addressBookId;
  final int groupId;
  final String ownerName;
  final String addressBook;

  EditEmailAddressBookRequest({
    this.process = 'pm_address_books',
    this.action = 'edit_email_address_book',
    required this.addressBookId,
    required this.groupId,
    required this.ownerName,
    required this.addressBook,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'address_book_id': addressBookId,
        'group_id': groupId,
        'owner_name': ownerName,
        'address_book': addressBook,
      };
}

class DeleteEmailAddressBookRequest {
  final String process;
  final String action;
  final int addressBookId;

  DeleteEmailAddressBookRequest({
    this.process = 'pm_address_books',
    this.action = 'delete_email_address_book',
    required this.addressBookId,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'address_book_id': addressBookId,
      };
}
