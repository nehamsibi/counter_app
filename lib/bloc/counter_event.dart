abstract class CounterEvent {}

class LoadCounter extends CounterEvent {}

class IncrementCounter extends CounterEvent {}

class DecrementCounter extends CounterEvent {}

class SetMaxValueEvent extends CounterEvent {
  final int maxValue;

  SetMaxValueEvent(this.maxValue);
}
