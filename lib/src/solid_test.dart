import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:solid_x/solid_x.dart';

import 'internal/expect_core.dart';

/// Exposes [solidTest] to easily test [Solid] ViewModels.
void solidTest<V extends Solid<S>, S>(
  String description, {
  required V Function() build,
  S Function()? seed,
  FutureOr<void> Function(V viewModel)? act,
  Duration? wait,
  int skip = 0,
  Iterable Function()? expect,
  FutureOr<void> Function(V viewModel)? verify,
  Iterable Function()? errors,
}) {
  test(description, () async {
    final viewModel = build();
    final states = <S>[];
    final capturedErrors = <dynamic>[];

    // Seed initial state if provided
    if (seed != null) {
      seed();
      // Wait for StateFlow injection/support or use initial state logic
    }

    // Since `Solid` uses `ChangeNotifier`, we listen via addListener:
    // We add the initial state (how bloc_test typically works, or skipping it based on `skip`)
    void listener() {
      states.add(viewModel.state);
    }

    viewModel.addListener(listener);

    try {
      if (act != null) {
        await act(viewModel);
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
      // Allow async operations to settle on the microtask queue
      await Future<void>.delayed(Duration.zero);
    }

    viewModel.removeListener(listener);

    // Apply skip offset
    final actualStates = states.skip(skip).toList();

    if (expect != null) {
      final expectedStates = expect();
      try {
        expectCore(actualStates, expectedStates);
      } catch (e) {
        // Wrap error for better readability
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
      await verify(viewModel);
    }

    viewModel.dispose();
  });
}
