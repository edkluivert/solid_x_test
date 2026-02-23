import 'package:flutter_test/flutter_test.dart';
import 'package:solid_x/solid_x.dart';
import 'package:solid_x_test/solid_x_test.dart';

// We need a dummy view model to create mutations since `mutation` is protected on `Solid`.
class TestViewModel extends Solid<int> {
  TestViewModel() : super(0);

  late final successfulMutation = mutation<int>(() async {
    return 42;
  });

  late final failingMutation = mutation<int>(() async {
    throw Exception('Error');
  });
}

void main() {
  group('mutationTest', () {
    late TestViewModel vm;

    setUp(() {
      vm = TestViewModel();
    });

    // We pass the mutation directly
    mutationTest<Mutation<int>, int>(
      'emits [Loading, Success] for successful throw-based mutation',
      build: () => vm.successfulMutation,
      act: (m) => m.call(),
      expect: () => [isMutationLoading, isMutationSuccess(42)],
    );

    mutationTest<Mutation<int>, int>(
      'emits [Loading, Error] for failing throw-based mutation',
      build: () => vm.failingMutation,
      act: (m) => m.call(),
      expect: () => [isMutationLoading, isMutationError(isA<Exception>())],
    );
  });
}
