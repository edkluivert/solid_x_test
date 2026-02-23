import 'package:mocktail/mocktail.dart';
import 'package:solid_x/solid_x.dart';

/// A mock implementation of [Solid] suitable for use with mocktail.
///
/// This simplifies testing widgets and classes that rely on a [Solid] ViewModel.
class MockSolid<S> extends Mock implements Solid<S> {
  // We don't necessarily need overrides if strictly mocking methods, but
  // standard behavior can be defined if necessary.
}
