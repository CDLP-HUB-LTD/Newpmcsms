// import 'package:flutter/foundation.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'base_response.g.dart';

// @immutable
// @JsonSerializable(genericArgumentFactories: true)
// class BaseResponse<T> {
//   const BaseResponse({
//     required this.status,
//     this.data,
//     this.serverMessage,
//     this.errorData,
//   });

//   factory BaseResponse.fromJson(
//     Map<String, dynamic> json,
//     T Function(Object? json) fromJsonT,
//   ) {
//     return _$BaseResponseFromJson(json, fromJsonT);
//   }

//   factory BaseResponse.fromMap(Map<String, dynamic> json) {
//     return BaseResponse(
//       data: json['data'] as T?,
//       status: json['status'] as bool,
//       serverMessage: json['server_message'] as String? ?? 'An error occurred',
//       errorData: json['errorData'],
//       //errorData: json['errorData'] as Map<String, dynamic>?,
//     );
//   }

//   final T? data;
//   @JsonKey(name: 'status')
//   final bool status;
//   final String? serverMessage;
//   final dynamic errorData;
//   //final Map<String, dynamic>? errorData;

//   Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
//       _$BaseResponseToJson(this, toJsonT);

//   Map<String, dynamic> toMap(Object Function(T value) toJsonT) {
//     return {
//       'data': data != null ? toJsonT(data as T) : null,
//       'status': status,
//       'server_message': serverMessage,
//       'errorData': errorData,
//     };
//   }

//   @override
//   String toString() {
//     return '''BaseResponse{status: $status, data: $data, server_message: $serverMessage, errorData: $errorData}''';
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is BaseResponse<T> &&
//         other.status == status &&
//         other.data == data &&
//         other.serverMessage == serverMessage &&
//         other.errorData == errorData;
//   }

//   @override
//   int get hashCode {
//     return status.hashCode ^
//         data.hashCode ^
//         serverMessage.hashCode ^
//         errorData.hashCode;
//   }
// }
import 'package:flutter/foundation.dart';

@immutable
class BaseResponse<T> {
  const BaseResponse({
    required this.status,
    this.data,
    this.serverMessage,
    this.errorData,
  });

  /// Factory to manually construct from a map if needed
  factory BaseResponse.fromMap(Map<String, dynamic> json,
      [T Function(Object? json)? fromJsonT]) {
    return BaseResponse(
      status: json['status'] as bool? ?? false,
      serverMessage: json['server_message'] as String? ?? 'An error occurred',
      errorData: json['errorData'],
      data: (json['data'] != null && fromJsonT != null)
          ? fromJsonT(json['data'])
          : json['data'] as T?,
    );
  }

  final T? data;
  final bool status;
  final String? serverMessage;
  final dynamic errorData;

  /// Manual toMap mapping without needing generated mixins
  Map<String, dynamic> toMap(Object? Function(T value)? toJsonT) {
    return {
      'status': status,
      'server_message': serverMessage,
      'errorData': errorData,
      'data': (data != null && toJsonT != null) ? toJsonT(data as T) : data,
    };
  }

  @override
  String toString() {
    return 'BaseResponse{status: $status, data: $data, server_message: $serverMessage, errorData: $errorData}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BaseResponse<T> &&
        other.status == status &&
        other.data == data &&
        other.serverMessage == serverMessage &&
        other.errorData == errorData;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        data.hashCode ^
        serverMessage.hashCode ^
        errorData.hashCode;
  }
}
