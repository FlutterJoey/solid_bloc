import 'package:flutter_test/flutter_test.dart';

import 'package:solid_bloc/solid_bloc.dart';

void main() {
  group('StateMapper', () {
    SolidBloc sut = SolidBloc(InitialState());
    setUp(() {
      sut = SolidBloc(InitialState());
    });

    test('mapEventToState should return a stream containing TargetState',
        () async {
      //arrange
      var expected = TargetState();
      sut.withTransition((SomeEvent event) => expected);

      //act
      Stream s = sut.mapEventToState(SomeEvent());
      var actual = await s.first;

      //assert
      expect(actual, equals(expected));
    });

    test('mapEventToState should yield nothing without TargetState', () {
      Stream s = sut.mapEventToState(SomeEvent());

      s.listen(neverCalled);
    });

    test(
        'mapEventToState should yield nothing with no specific listener specified',
        () {
      sut.withTransition((OtherEvent event) => TargetState());
      Stream s = sut.mapEventToState(SomeEvent());

      s.listen(neverCalled);
    });

    test('mapEventToState should yield nothing when event was cancelled', () {
      SomeCancellable cancellable = SomeCancellable();
      cancellable.cancel();
      sut.withTransition((SomeCancellable event) => TargetState());
      Stream s = sut.mapEventToState(cancellable);

      s.listen(neverCalled);
    });
  });

  group('eventHandler', () {
    SolidBloc sut = SolidBloc(InitialState());
    setUp(() {
      sut = SolidBloc(InitialState());
    });
    test('onEvent should call the appropriate listener', () {
      var called = false;

      sut.withListener((SomeEvent event, bloc) {
        called = true;
      });

      sut.onEvent(SomeEvent());

      expect(called, equals(true));
    });

    test('onEvent should not call unrelated listeners', () {
      sut.withListener((OtherEvent event, bloc) {
        neverCalled();
      });

      sut.withListener((event, bloc) {
        // this only gets called when a specifically marked SolidBlocEvent is called
        neverCalled();
      });

      sut.onEvent(SomeEvent());
    });

    test('onEvent should not call other listeners after event is cancelled',
        () {
      sut.withListener((SomeCancellable event, bloc) {
        event.cancel();
      });
      sut.withListener((SomeCancellable event, bloc) {
        neverCalled();
      });

      sut.onEvent(SomeCancellable());
    });
  });
}

class TestState extends SolidBlocState {
  @override
  List<Object?> get props => [];
}

class TargetState extends TestState {}

class InitialState extends TestState {}

class SomeEvent extends SolidBlocEvent {}

class OtherEvent extends SolidBlocEvent {}

class SomeCancellable extends SolidBlocEvent with CancelableEvent {}
