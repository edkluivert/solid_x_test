import 'package:flutter_test/flutter_test.dart';
import 'package:solid_x/solid_x.dart';

/// A matcher for [MutationInitial].
const Matcher isMutationInitial = TypeMatcher<MutationInitial<dynamic>>();

/// A matcher for [MutationLoading].
const Matcher isMutationLoading = TypeMatcher<MutationLoading<dynamic>>();

/// A matcher for [MutationEmpty].
const Matcher isMutationEmpty = TypeMatcher<MutationEmpty<dynamic>>();

/// Returns a matcher for [MutationSuccess].
///
/// If [dataMatcher] is provided, it verifies the [MutationSuccess.data] matches.
Matcher isMutationSuccess([dynamic dataMatcher]) {
  var matcher = const TypeMatcher<MutationSuccess<dynamic>>();
  if (dataMatcher != null) {
    matcher = matcher.having((s) => s.data, 'data', dataMatcher);
  }
  return matcher;
}

/// Returns a matcher for [MutationError].
///
/// If [errorMatcher] is provided, it verifies the [MutationError.error] matches.
Matcher isMutationError([dynamic errorMatcher]) {
  var matcher = const TypeMatcher<MutationError<dynamic>>();
  if (errorMatcher != null) {
    matcher = matcher.having((e) => e.error, 'error', errorMatcher);
  }
  return matcher;
}
