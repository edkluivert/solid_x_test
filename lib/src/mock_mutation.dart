import 'package:mocktail/mocktail.dart';
import 'package:solid_x/solid_x.dart';

/// A mock implementation of [Mutation] suitable for use with mocktail.
///
/// This simplifies testing widgets and classes that rely on a [Mutation].
class MockMutation<T> extends Mock implements Mutation<T> {}
