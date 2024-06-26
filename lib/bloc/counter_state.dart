import '../../data/models.dart';

abstract class CounterState {}

class CounterInitial extends CounterState {}

class CounterLoading extends CounterState {}

class CounterLoaded extends CounterState {
  final Counter counter;

  CounterLoaded(this.counter);
}

class CounterError extends CounterState {
  final String message;

  CounterError(this.message);
}
