part of solid_bloc;
/// empty class to allow for generic check
class SolidBlocEvent {
  
}

/// mixin to enable for Cancellable events
/// When [cancelled] is true this event
mixin CancelableEvent {
  bool _cancelled = false;

  /// set this event as cancelled, or uncancel if needed.
  /// If it can be avoided to 'uncancel' the event, do so.
  void cancel({bool doCancel = true}) {
    this._cancelled = doCancel;
  }

  /// returns whether this event has been cancelled
  bool isCancelled() {
    return _cancelled;
  }
}

/// a typedef defining the signature of the calback given to a [SolidBloc]
/// for registering an event listener.
/// 
/// by strongly typing the [event] argument, the type of [E] is automatically
/// inferred. 
/// 
/// multiple different [BlocEventListeners] can exist inside the 
/// same [SolidBloc] for the same type of [E].
typedef Future<void>? BlocEventListener<E extends SolidBlocEvent,
    B extends SolidBloc>(E event, B bloc);

/// an extension to be able to automatically infer type [E] from
/// a [BlocEventListener]
extension _GetEventTypeForListener<E extends SolidBlocEvent,
    B extends SolidBloc> on BlocEventListener<E, B> {
  Type getEventType() => E;
}
