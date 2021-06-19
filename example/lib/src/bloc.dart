import 'package:example/src/service.dart';
import 'package:solid_bloc/solid_bloc.dart';

class BasicIncrementBloc extends SolidBloc {
  CounterService _counterService = CounterService();

  BasicIncrementBloc() : super(BasicState(0)) {
    //listeners are always called before transitions...
    //listeners can be great for event chaining or used when you want to make sure that transitions are also still available.
    //best to not make this async unless you are not depending of the outcome of the function body in withTransition();
    withListener((BasicIncrementEvent event, BasicIncrementBloc bloc) {
      _counterService.increment(amount: event.amount);
      // _counterService.incrementAsync(amount: event.amount); DON'T: high likelyhood that incrementation has not completed before
    });
    withListener((BasicReduceEvent event, BasicIncrementBloc bloc) async {
      await _counterService.reduceAsync(amount: event.amount);

      this.add(
          CountCompletedEvent()); // we wait and then we don't increment. This is makeshift and normally you would throw a "countCompletedEvent";
    });
    withTransition((BasicIncrementEvent event) {
      return BasicState(_counterService.count);
    });
    withTransition(
        (CountCompletedEvent event) => BasicState(_counterService.count));
  }

  // when you require that the event is completed before updating the state
  // you should add a new event which describes that event.
  // A transition can then handle the change.
  void incrementAsync() async {
    await _counterService.incrementAsync();
    this.add(
          CountCompletedEvent());
  }
}

class BasicIncrementEvent extends SolidBlocEvent {
  final int amount;
  BasicIncrementEvent(this.amount);
}

class BasicReduceEvent extends SolidBlocEvent {
  final int amount;
  BasicReduceEvent(this.amount);
}

class CountCompletedEvent extends SolidBlocEvent {}

class BasicState extends SolidBlocState {
  final int counter;

  BasicState(this.counter);

  @override
  List<Object?> get props => [counter];
}
