part of solid_bloc;

abstract class SolidBlocState extends Equatable {
  
}

typedef S BlocStateMapper<S extends SolidBlocState, E extends SolidBlocEvent>(
    E event);

extension _GetEventTypeForMapper<E extends SolidBlocEvent,
    S extends SolidBlocState> on BlocStateMapper<S, E> {
  Type getEventType() => E;
}
