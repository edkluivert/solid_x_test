# SOLID_X_TEST

A robust testing utility library for the `solid_x` state management package.

`solid_x_test` provides simple, declarative utilities (inspired by `bloc_test`) to test your `Solid` ViewModels with ease.

## Features

- **`solidTest`**: A powerful testing function that manages ViewModel initialization, action execution, and state verification.
- **`MockSolid`**: A base class for creating mock ViewModels using `mocktail`.

## Getting Started

Add `solid_x_test` to your `pubspec.yaml` under `dev_dependencies`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  solid_x_test: ^1.0.0
```

## Usage

### Testing ViewModels with `solidTest`

Testing a `Solid` ViewModel involves building the ViewModel, acting on it, and asserting the expected series of states that it emits.

#### The ViewModel

```dart
import 'package:solid_x/solid_x.dart';

class CounterViewModel extends Solid<int> {
  CounterViewModel() : super(0);

  void increment() {
    update((s) => s + 1);
  }
}
```

#### The Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_x_test/solid_x_test.dart';

void main() {
  group('CounterViewModel', () {
    
    solidTest<CounterViewModel, int>(
      'emits [1] when increment is called',
      // 1. Build the ViewModel
      build: () => CounterViewModel(),
      // 2. Perform an action
      act: (viewModel) => viewModel.increment(),
      // 3. Define the expected states
      expect: () => <int>[1],
    );

    solidTest<CounterViewModel, int>(
      'verifies the final state property',
      build: () => CounterViewModel(),
      act: (viewModel) => viewModel.increment(),
      // 4. Perform additional verification if needed
      verify: (viewModel) {
        expect(viewModel.state, equals(1));
      },
    );

  });
}
```

### Mocking ViewModels

When writing Widget tests, you might want to mock the behavior of your ViewModels without connecting them to actual business logic or repositories.

Use `MockSolid` to easily create a mock implementation.

```dart
import 'package:solid_x_test/solid_x_test.dart';

class MockCounterViewModel extends MockSolid<int> implements CounterViewModel {}

void main() {
  late MockCounterViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockCounterViewModel();
    // Setup mocktail behaviors...
    when(() => mockViewModel.state).thenReturn(42);
  });
  
  // Use mockViewModel in your widget tests!
}
```

### Testing Mutations

`solid_x` features `Mutation<T>` for asynchronous operations. You can test these just like ViewModels using both `mutationTest` and specific matchers!

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_x_test/solid_x_test.dart';

void main() {
  group('AuthViewModel', () {
    late AuthViewModel vm;

    setUp(() {
      vm = AuthViewModel();
    });

    mutationTest<Mutation<User>, User>(
      'login emits loading then success',
      build: () => vm.loginMutation,
      act: (m) => m.call(),
      expect: () => [
        isMutationLoading,
        isMutationSuccess(isA<User>()),
      ],
    );
  });
}
```

Available matchers:
- `isMutationInitial`
- `isMutationLoading`
- `isMutationSuccess([matcher])`
- `isMutationError([matcher])`
- `isMutationEmpty`
