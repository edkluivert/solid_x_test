import 'package:flutter_test/flutter_test.dart';
import 'package:solid_x/solid_x.dart';
import 'package:solid_x_test/solid_x_test.dart';

class CounterViewModel extends Solid<int> {
  CounterViewModel() : super(0);

  void increment() {
    update((s) => s + 1);
  }

  void addError() {
    // Solid base doesn't have an error method by default unless using mutations
    // So we'll just throw an error here to test error capturing if we added mutation tests later
    throw Exception('Test Error');
  }
}

void main() {
  group('solidTest', () {
    solidTest<CounterViewModel, int>(
      'emits [] when nothing is added',
      build: () => CounterViewModel(),
      expect: () => <int>[],
    );

    solidTest<CounterViewModel, int>(
      'emits [1] when increment is called',
      build: () => CounterViewModel(),
      act: (viewModel) => viewModel.increment(),
      expect: () => <int>[1],
    );

    solidTest<CounterViewModel, int>(
      'emits [1, 2] when increment is called twice',
      build: () => CounterViewModel(),
      act: (viewModel) {
        viewModel.increment();
        viewModel.increment();
      },
      expect: () => <int>[1, 2],
    );

    // Testing the ability of solidTest to verify custom assertions
    solidTest<CounterViewModel, int>(
      'verifies state properties correctly',
      build: () => CounterViewModel(),
      act: (viewModel) => viewModel.increment(),
      verify: (viewModel) {
        expect(viewModel.state, equals(1));
      },
    );
  });
}
