import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:solid_x/solid_x.dart';

import 'internal/expect_core.dart';

/// Exposes [mutationTest] to easily test [Mutation]s directly.
void mutationTest<M extends Mutation<T>, T>(
  String description, {
  required M Function() build,
  FutureOr<void> Function(M mutation)? act,
  Duration? wait,
  int skip = 0,
  Iterable Function()? expect,
  FutureOr<void> Function(M mutation)? verify,
  Iterable Function()? errors,
}) {
  test(description, () async {
    final mutation = build();
    final states = <MutationState<T>>[];
    final capturedErrors = <dynamic>[];

    // Listen to MutationState changes
    void listener() {
      states.add(mutation.state);
    }

    mutation.addListener(listener);

    try {
      if (act != null) {
        await act(mutation);
      }
    } catch (error) {
      if (errors == null) {
        rethrow;
      }
      capturedErrors.add(error);
    }

    if (wait != null) {
      await Future<void>.delayed(wait);
    } else {
      await Future<void>.delayed(Duration.zero);
    }

    mutation.removeListener(listener);

    final actualStates = states.skip(skip).toList();

    if (expect != null) {
      final expectedStates = expect();
      try {
        expectCore(actualStates, expectedStates);
      } catch (e) {
        throw TestFailure(
          'Expected states: $expectedStates\nActual states: $actualStates',
        );
      }
    }

    if (errors != null) {
      final expectedErrors = errors();
      expectCore(capturedErrors, expectedErrors);
    }

    if (verify != null) {
      await verify(mutation);
    }

    // Mutations don't have dispose manually exposed unless we call it on the ChangeNotifier
    // ignore: invalid_use_of_protected_member
    mutation.dispose();
  });
}
