import 'package:flutter_test/flutter_test.dart';
import 'package:solid_x/solid_x.dart';
import 'package:solid_x_test/solid_x_test.dart';

void main() {
  group('Mutation Matchers', () {
    test('isMutationInitial matches MutationInitial', () {
      expect(const MutationInitial<int>(), isMutationInitial);
      expect(const MutationLoading<int>(), isNot(isMutationInitial));
    });

    test('isMutationLoading matches MutationLoading', () {
      expect(const MutationLoading<int>(), isMutationLoading);
      expect(const MutationEmpty<int>(), isNot(isMutationLoading));
    });

    test('isMutationEmpty matches MutationEmpty', () {
      expect(const MutationEmpty<int>(), isMutationEmpty);
      expect(MutationSuccess<int>(1), isNot(isMutationEmpty));
    });

    test('isMutationSuccess matches MutationSuccess and its data', () {
      expect(MutationSuccess<int>(42), isMutationSuccess());
      expect(MutationSuccess<int>(42), isMutationSuccess(42));
      expect(MutationSuccess<int>(42), isMutationSuccess(isA<int>()));

      // Should fail if data doesn't match
      expect(MutationSuccess<int>(42), isNot(isMutationSuccess(100)));
      expect(const MutationLoading<int>(), isNot(isMutationSuccess()));
    });

    test('isMutationError matches MutationError and its error', () {
      final Exception error = Exception('Failed');
      expect(MutationError<int>(error), isMutationError());
      expect(MutationError<int>(error), isMutationError(error));
      expect(MutationError<int>(error), isMutationError(isA<Exception>()));

      // Should fail if error doesn't match
      expect(
        MutationError<int>(error),
        isNot(isMutationError(Exception('Other'))),
      );
      expect(const MutationLoading<int>(), isNot(isMutationError()));
    });
  });
}
