// lib/presentation/features/phonebook/data/model/edit_address_book_request.dart
class EditAddressBookRequest {
  final String process;
  final String action;
  final int addressBookId;
  final String addressBook;
  final int groupId;

  EditAddressBookRequest({
    this.process = 'pm_address_books',
    this.action = 'edit_address_book',
    required this.addressBookId,
    required this.addressBook,
    required this.groupId,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'address_book_id': addressBookId,
        'address_book': addressBook,
        'group_id': groupId,
      };
}
