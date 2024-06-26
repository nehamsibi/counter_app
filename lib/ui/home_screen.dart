import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/counter_bloc.dart';
import '../../bloc/counter_event.dart';
import '../../bloc/counter_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Counter App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              _MaxLimitset(context);
            },
            icon: Icon(Icons.edit, color: Colors.white),
          ),
        ],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            if (state is CounterInitial) {
              context.read<CounterBloc>().add(LoadCounter());
              return CircularProgressIndicator();
            } else if (state is CounterLoading) {
              return CircularProgressIndicator();
            } else if (state is CounterLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${state.counter.value}',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    'Maximum Limit: ${state.counter.maxValue}',
                    style: TextStyle(color: Colors.red),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.read<CounterBloc>().add(IncrementCounter());
                          },
                          child: Icon(Icons.add),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CounterBloc>().add(DecrementCounter());
                          },
                          child: Icon(Icons.remove),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is CounterError) {
              return Text(state.message);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  void _MaxLimitset(BuildContext context) {
    final TextEditingController maxValueController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Max Limit'),
          content: TextField(
            controller: maxValueController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter maximum limit'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newMaxValue = int.tryParse(maxValueController.text);
                //     if (newMaxValue != null) {
                //       context
                //           .read<CounterBloc>()
                //           .add(SetMaxValueEvent(newMaxValue));
                //}
                if (newMaxValue != null) {
                  BlocProvider.of<CounterBloc>(context)
                      .add(SetMaxValueEvent(newMaxValue));
                }
                //Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
