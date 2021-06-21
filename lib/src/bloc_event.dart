part of solid_bloc;

class SolidBlocEvent {
  
}

mixin CancelableEvent {
  bool cancelled = false;

  void cancel({bool doCancel = true}) {
    this.cancelled = doCancel;
  }

  bool isCancelled() {
    return cancelled;
  }
}

typedef Future<void>? BlocEventListener<E extends SolidBlocEvent,
    B extends SolidBloc>(E event, B bloc);

extension _GetEventTypeForListener<E extends SolidBlocEvent,
    B extends SolidBloc> on BlocEventListener<E, B> {
  Type getEventType() => E;
}
