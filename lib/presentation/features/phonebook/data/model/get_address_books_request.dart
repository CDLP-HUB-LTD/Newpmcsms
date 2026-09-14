// lib/presentation/features/phonebook/data/model/get_address_books_request.dart
class GetAddressBooksRequest {
  final String process;
  final String action;
  final int start;
  final int length;

  GetAddressBooksRequest({
    this.process = 'pm_address_books',
    this.action = 'get_user_address_books',
    this.start = 1,
    this.length = 50,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'start': start,
        'length': length,
      };
}
