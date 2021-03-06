part of solid_bloc;

/// main class of this package.
///
/// provides additional functionality on top of the default bloc given
/// by flutter_bloc. The main goal is to avoid unnecessary if statements and 
/// switch case blocks.
class SolidBloc extends Bloc<SolidBlocEvent, SolidBlocState> {
  _BlocStateManager _stateManager;
  late _BlocEventHandler _eventHandler;

  SolidBloc(SolidBlocState initialState)
      : _stateManager = _BlocStateManager(),
        super(initialState) {
    _eventHandler = _eventHandler = _BlocEventHandler(this);
  }

  @override
  Stream<SolidBlocState> mapEventToState(SolidBlocEvent event) async* {
    SolidBlocState? state = _stateManager._mapEventToState(event);
    if (state != null) {
      yield state;
    }
  }

  @override
  @mustCallSuper
  void onEvent(SolidBlocEvent event) {
    super.onEvent(event);
    _eventHandler._handleEvent(event);
  }

  /// add a transition which adds a new [SolidBlocState] to the stream of this
  /// bloc when event [E] is added to the bloc.
  ///
  /// adding a second transition for the same type of [E] will overwrite the
  /// previous transition.
  void withTransition<E extends SolidBlocEvent, S extends SolidBlocState>(
      BlocStateMapper<S, E> mapper) {
    this._stateManager._registerMapper(mapper, mapper.getEventType());
  }

  /// add a listener which is called when event [E] is added to the bloc.
  /// multiple events are allowed to exist for the same type of event [E]
  ///
  void withListener<E extends SolidBlocEvent, B extends SolidBloc>(
      BlocEventListener<E, B> listener) {
    this._eventHandler._registerEventHandler(listener.getEventType(), listener);
  }
}

class _BlocStateManager {
  Map<Type, dynamic> mappers = {};

  SolidBlocState? _mapEventToState(SolidBlocEvent event) {
    Type t = event.runtimeType;
    // we should not create states for cancelled events.
    if (event is CancelableEvent && (event as CancelableEvent).isCancelled())
      return null;
    if (mappers.containsKey(t)) {
      debugPrint(
          "Found event: ${event.runtimeType} and mapped it to the state: ${mappers[t].runtimeType}");
      return mappers[t]!.call(event);
    }
    return null;
  }

  void _registerMapper<S extends SolidBlocState, E extends SolidBlocEvent>(
      BlocStateMapper<S, E> mapper, Type type) {
    this.mappers.putIfAbsent(type, () => mapper);
  }
}

class _BlocEventHandler {
  SolidBloc bloc;
  Map<Type, List<dynamic>> listeners = {};

  _BlocEventHandler(this.bloc);

  void _handleEvent(SolidBlocEvent event) {
    Type t = event.runtimeType;
    if (listeners.containsKey(t)) {
      var list = listeners[t]!;
      for (var listener in list) {
        if (event is CancelableEvent &&
            (event as CancelableEvent).isCancelled()) break;
        listener.call(event, bloc);
      }
    }
  }

  void _registerEventHandler<E extends SolidBlocEvent, B extends SolidBloc>(
      Type type, BlocEventListener<E, B> listener) {
    listeners.putIfAbsent(type, () => []).add(listener);
  }
}
