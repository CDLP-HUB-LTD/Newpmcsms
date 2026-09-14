// lib/presentation/features/email_list/data/model/email_group.dart
class EmailGroupData {
  final int? groupId;
  final String? publicId;
  final int? userId;
  final String? groupName;
  final String? dateCreated;
  final String? dateUpdated;
  final int? totalAddressBooks;

  EmailGroupData({
    this.groupId,
    this.publicId,
    this.userId,
    this.groupName,
    this.dateCreated,
    this.dateUpdated,
    this.totalAddressBooks,
  });

  factory EmailGroupData.fromJson(Map<String, dynamic> json) => EmailGroupData(
        groupId: json['group_id'],
        publicId: json['public_id'],
        userId: json['user_id'],
        groupName: json['group_name'],
        dateCreated: json['date_created'],
        dateUpdated: json['date_updated'],
        totalAddressBooks: json['total_address_books'],
      );
}
