import 'package:solid_x/solid_x.dart';

class CounterViewModel extends Solid<int> {
  CounterViewModel() : super(0);

  void increment() {
    update((s) => s + 1);
  }
}
