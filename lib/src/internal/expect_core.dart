import 'package:flutter_test/flutter_test.dart';

// Alias the flutter_test expect to avoid naming collisions with our expect parameter
void expectCore(
  dynamic actual,
  dynamic matcher, {
  String? reason,
  dynamic skip,
}) {
  expect(actual, matcher, reason: reason, skip: skip);
}
