library solid_bloc;

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// we hide bloc to provide our own bloc implementation on top.
// Because the SolidBlocBuilder does not provide the ideal usage we still allow the provided BlocBuilder to be shown.
export 'package:flutter_bloc/flutter_bloc.dart' hide Bloc, BlocBase;
export 'package:equatable/equatable.dart';

part 'src/bloc.dart';
part 'src/bloc_builder.dart';
part 'src/bloc_event.dart';
part 'src/bloc_state.dart';
