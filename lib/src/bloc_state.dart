part of solid_bloc;

/// a class to enable type checking through generics and ensuring immutability.
/// the [SolidBlocState] extends [Equatable] to make sure that the internal
/// properties are considered when comparing states which trigger [BlocBuilder]
abstract class SolidBlocState extends Equatable {}

/// a typedef defining the signature of the calback given to a [SolidBloc]
/// for mapping events to states.
/// by strongly typing the [event] argument, the type of [E] is automatically
/// inferred.
typedef S BlocStateMapper<S extends SolidBlocState, E extends SolidBlocEvent>(
    E event);

/// an extension to be able to automatically infer type [E] from
/// a [BlocStateMapper]
extension _GetEventTypeForMapper<E extends SolidBlocEvent,
    S extends SolidBlocState> on BlocStateMapper<S, E> {
  Type getEventType() => E;
}
