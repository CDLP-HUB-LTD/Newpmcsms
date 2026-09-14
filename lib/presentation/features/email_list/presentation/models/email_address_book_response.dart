/// Confirmed against a real response:
/// { "server_message": ..., "status": true, "data": [ { ... } ], ... }
/// `data` is a flat list of items directly — no pagination wrapper.
class EmailAddressBookResponse {
  final bool? status;
  final String? serverMessage;
  final List<EmailAddressBookItem>? data;

  EmailAddressBookResponse({
    this.status,
    this.serverMessage,
    this.data,
  });

  factory EmailAddressBookResponse.fromJson(Map<String, dynamic> json) =>
      EmailAddressBookResponse(
        status: json['status'],
        serverMessage: json['server_message'],
        data: json['data'] == null
            ? []
            : List<EmailAddressBookItem>.from(
                (json['data'] as List)
                    .map((x) => EmailAddressBookItem.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'server_message': serverMessage,
        'data': data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class EmailAddressBookItem {
  final int? addressBookId;
  final int? groupId;
  final String? ownerName;
  final String? addressBook;

  EmailAddressBookItem({
    this.addressBookId,
    this.groupId,
    this.ownerName,
    this.addressBook,
  });

  factory EmailAddressBookItem.fromJson(Map<String, dynamic> json) =>
      EmailAddressBookItem(
        addressBookId: json['address_id'],
        groupId: json['group_id'],
        ownerName: json['owner_name'],
        addressBook: json['address_book'],
      );

  Map<String, dynamic> toJson() => {
        'address_book_id': addressBookId,
        'group_id': groupId,
        'owner_name': ownerName,
        'address_book': addressBook,
      };
}

/// Generic response for add/edit/delete — these typically just echo status
/// and a message. Adjust if the API returns the affected record too.
class EmailAddressBookActionResponse {
  final bool? status;
  final String? serverMessage;
  final dynamic data;

  EmailAddressBookActionResponse({
    this.status,
    this.serverMessage,
    this.data,
  });

  factory EmailAddressBookActionResponse.fromJson(Map<String, dynamic> json) =>
      EmailAddressBookActionResponse(
        status: json['status'],
        serverMessage: json['server_message'],
        data: json['data'],
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'server_message': serverMessage,
        'data': data,
      };
}
