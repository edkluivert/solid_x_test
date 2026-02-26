import 'package:flutter_test/flutter_test.dart';
import 'package:solid_x_test/solid_x_test.dart';

import 'package:example/counter_view_model.dart';

void main() {
  group('CounterViewModel Test', () {
    solidTest<CounterViewModel, int>(
      'emits [1] when increment is called',
      build: () => CounterViewModel(),
      act: (viewModel) => viewModel.increment(),
      expect: () => [1],
    );

    solidTest<CounterViewModel, int>(
      'emits [1, 2] when increment is called twice',
      build: () => CounterViewModel(),
      act: (viewModel) {
        viewModel.increment();
        viewModel.increment();
      },
      expect: () => [1, 2],
    );
  });
}
