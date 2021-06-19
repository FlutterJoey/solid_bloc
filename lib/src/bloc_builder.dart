part of solid_bloc;

/// A wrapper class for the [BlocBuilder] class provided by the bloc library.
///
/// The main focus is to remove the need for if Statements in
/// the builder method from [BlocBuilder]. By providing a [Map] of
/// [SolidBlocStateBuilder]s the builder automatically matches the key
/// to the appropriate build method. If no builder was found for the type, 
/// [elseBuild] will be used when provided or a [FlutterError] will be thrown.
///
/// Even though it is ensured that:
/// ```dart
///   SolidBlocBuilder(
///     builders: [
///       StateType: (BuildContext context, /* StateType */ state) {
///         //state is always of type StateType
///       }
///     ],
///   )
/// ```
/// Dart does not support for the type to bound in List like this, so the
/// second parameter of a [SolidBlocStateBuilder] should remain [dynamic] or of
/// type [SolidBlocState]. To ensure the IDE that the [state] provided is in
/// fact of the type, the following statement can be used:
/// /// ```dart
///   SolidBlocBuilder(
///     builders: [
///       StateType: (BuildContext context, /* StateType */ state) {
///         state as StateType; //assure IDE/Compiler that state is in fact of type StateType from here on forth.
///       }
///     ],
///   )
/// ```
///
class SolidBlocBuilder<B extends SolidBloc> extends StatelessWidget {
  final BlocBuilderCondition? buildWhen;
  final B? bloc;
  final Map<Type, SolidBlocStateBuilder<SolidBlocState>> builders;
  final SolidBlocStateBuilder? elseBuild;

  SolidBlocBuilder(
      {Key? key,
      this.buildWhen,
      this.bloc,
      required this.builders,
      this.elseBuild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, SolidBlocState>(
      bloc: bloc,
      buildWhen: buildWhen,
      builder: buildState,
    );
  }

  Widget buildState(BuildContext context, SolidBlocState state) {
    if (builders.containsKey(state.runtimeType)) {
      return builders[state.runtimeType]!.call(context, state);
    } else if (this.elseBuild != null) {
      return this.elseBuild!.call(context, state);
    } else {
      throw FlutterError('''
      You need to provide a builder for the state ${state.runtimeType}!

      This error can occur when you have not defined your map of builders or if the map does not contain a key 
      matching the runtimeType of ${state.runtimeType}.

      Evaluate the map provided to the named argument [SolidBlocBuilder.builders].
    ''');
    }
  }
}

/// typedef used by the [SolidBlocBuilder] as interface for building for a particular state.
///
typedef Widget SolidBlocStateBuilder<S extends SolidBlocState>(
    BuildContext context, S state);
