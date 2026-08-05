import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';

// --- Navigation Utilities ---
extension NavigationExtension on BuildContext {
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T?> replaceNamed<T extends Object?, E extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushReplacementNamed<T, E>(
      routeName,
      arguments: arguments,
    );
  }

  Future<T?> replaceAll<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  Future<T?> push<T extends Object?>(MaterialPageRoute<T> route) {
    return Navigator.of(this).push<T>(route);
  }

  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(this).popAndPushNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Route<T> newRoute, {
    TO? result,
  }) {
    return Navigator.of(this).pushReplacement<T, TO>(
      newRoute,
      result: result,
    );
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(this).pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  void popUntil(bool Function(Route<dynamic>) predicate) {
    Navigator.of(this).popUntil(predicate);
  }

  void pop<T>([T? result]) {
    return Navigator.of(this).pop<T>(result);
  }
}

// --- Clipboard Utilities ---
extension CopyToClipboard on BuildContext {
  void copyToClipboard(String value) {
    Clipboard.setData(ClipboardData(text: value)).then(
      (_) => showToast(message: 'Copied to clipboard'),
    );
  }
} // Fixed the missing closing brace here

// --- Iterable Grouping Utilities ---
extension Group<T> on Iterable<T> {
  Groups<K, T> groupBy<K>(K Function(T) key) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final keyValue = key(element);
      if (!map.containsKey(keyValue)) {
        map[keyValue] = [];
      }
      map[keyValue]?.add(element);
    }
    return Groups(keys: map.keys.toList(), children: map.values.toList());
  }
}

class Groups<K, T> {
  const Groups({
    required this.keys,
    required this.children,
  });

  final List<K> keys;
  final List<List<T>> children;

  @override
  String toString() {
    return 'Groups{keys: $keys, children: $children}';
  }

  factory Groups.empty() {
    return const Groups(keys: [], children: []);
  }

  List<T> expands() => children.fold(<T>[], (pv, e) => [...pv, ...e]);
}

// --- DateTime Utilities ---
extension DateExtension on DateTime {
  String toFormattedString() {
    return '$year-$month-$day';
  }

  String get dateOnly => toIso8601String().split('T').first;

  DateTime get splitDateOnly => DateTime.parse(toString().split(' ')[0]);

  String get toTime => DateFormat('hh:mm a').format(toLocal()).toLowerCase();

  String get toDate => DateFormat('MMM d, y').format(toLocal());

  String get getHeaderDate {
    final now = DateTime.now();
    if (day == now.day && month == now.month && year == now.year) {
      return 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (day == yesterday.day &&
        month == yesterday.month &&
        year == yesterday.year) {
      return 'Yesterday';
    }
    return DateFormat('MMM dd, yyyy').format(this);
  }

  String get timeAgo {
    final difference = DateTime.now().difference(this);
    final days = difference.inDays;
    final hours = difference.inHours;
    final minutes = difference.inMinutes;
    final seconds = difference.inSeconds;

    if (days > 0) {
      return toDate;
    } else if (hours > 0) {
      return toTime;
    } else if (minutes > 0) {
      return minutes == 1 ? '$minutes minute ago' : '$minutes minutes ago';
    } else if (seconds > 0) {
      return '$seconds seconds ago';
    } else {
      return 'Just now';
    }
  }
}
