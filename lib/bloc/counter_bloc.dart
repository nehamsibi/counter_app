import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final CounterRepository repository;
  CounterBloc({required this.repository}) : super(CounterInitial()) {
    on<LoadCounter>((event, emit) async {
      emit(CounterLoading());
      try {
        final counter = await repository.fetchCounter();
        if (counter != null) {
          emit(CounterLoaded(counter));
        } else {
          emit(CounterError("Failed to load counter: Response was null"));
        }
      } catch (e) {
        emit(CounterError("Failed to load counter: $e"));
      }
    });

    on<IncrementCounter>((event, emit) async {
      if (state is CounterLoaded) {
        final currentState = state as CounterLoaded;
        final newValue = currentState.counter.value + 1;
        if (newValue <= currentState.counter.maxValue) {
          try {
            print("Updating counter to new value: $newValue");
            await repository.updateCounter(newValue);
            emit(CounterLoaded(
                currentState.counter.counternew(value: newValue)));
          } catch (e) {
            print("Error in IncrementCounter: $e");
            emit(CounterError("Failed to increment counter: $e"));
          }
        }
      }
    });
    on<DecrementCounter>((event, emit) async {
      if (state is CounterLoaded) {
        final currentState = state as CounterLoaded;
        final newValue = currentState.counter.value - 1;
        if (newValue >= 0) {
          await repository.updateCounter(newValue);
          emit(CounterLoaded(currentState.counter.counternew(value: newValue)));
        }
      }
    });

    on<SetMaxValueEvent>((event, emit) async {
      if (state is CounterLoaded) {
        final currentState = state as CounterLoaded;
        final newMaxValue = event.maxValue;
        final newCounter =
            currentState.counter.counternew(maxValue: newMaxValue);
        await repository.updateMaxValue(newMaxValue);
        emit(CounterLoaded(newCounter));
      }
    });
  }
}
