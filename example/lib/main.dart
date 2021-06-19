import 'package:flutter/material.dart';
import 'package:solid_bloc/solid_bloc.dart';
import 'src/bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc Example app',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<BasicIncrementBloc>(
        create: (context) => BasicIncrementBloc(),
        child: MyHomePage(
          title: 'Solid Bloc Example',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _incrementCounter() {
    // you should not care whether the incrementation is synchronous or not.
    // Any logic handling synchronization should be within your bloc or underlying services.
    context.read<BasicIncrementBloc>().incrementAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SolidBlocBuilder<BasicIncrementBloc>(
        // You must provide a builder for each state!
        builders: {
          // When we encounter a state of type BasicState, we call this event.
          BasicState: (BuildContext context, state) {
            state as BasicState;
            return Container(
              child: Center(
                child: Text('You clicked the button: ${state.counter} times!'),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _incrementCounter,
      ),
    );
  }
}

