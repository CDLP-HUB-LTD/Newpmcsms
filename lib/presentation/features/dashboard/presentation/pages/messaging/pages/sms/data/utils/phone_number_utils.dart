/// Normalizes Nigerian phone numbers into the E.164-style digits-only
/// format (2348012345678) the backend appears to expect, given that a
/// local-format number (08012345678) was rejected with "No valid phone
/// numbers found after validation".
///
/// This is a client-side stopgap. Ideally the backend normalizes local
/// input server-side (leading 0 -> 234) since that's the format most
/// users will actually type/paste/upload — confirm with backend which
/// side should own this before relying on it long-term.
///
/// Handles:
///   08012345678      -> 2348012345678   (local, 11 digits)
///   8012345678        -> 2348012345678   (local without leading 0, 10 digits)
///   2348012345678     -> 2348012345678   (already E.164 digits)
///   +2348012345678    -> 2348012345678   (E.164 with plus / spaces / dashes)
///
/// Returns null if the cleaned digits don't match any of the above —
/// callers should treat that as an invalid number rather than send it.
String? normalizeNigerianPhone(String raw) {
  final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return null;

  if (digits.startsWith('234')) {
    return digits.length == 13 ? digits : null;
  }

  if (digits.startsWith('0') && digits.length == 11) {
    return '234${digits.substring(1)}';
  }

  if (digits.length == 10) {
    return '234$digits';
  }

  return null;
}

class NormalizedRecipients {
  final List<String> valid;
  final List<String> invalid; // original, un-normalized entries
  const NormalizedRecipients({required this.valid, required this.invalid});
}

/// Normalizes a comma/newline separated block of numbers (as typed into
/// the "Recipient" free-text field), splitting valid from invalid so the
/// caller can decide whether to warn, drop, or block on the invalid ones.
NormalizedRecipients normalizeRecipientList(String raw) {
  final parts = raw
      .split(RegExp(r'[,\n]'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty);

  final valid = <String>[];
  final invalid = <String>[];

  for (final part in parts) {
    final normalized = normalizeNigerianPhone(part);
    if (normalized == null) {
      invalid.add(part);
    } else {
      valid.add(normalized);
    }
  }

  return NormalizedRecipients(valid: valid, invalid: invalid);
}
