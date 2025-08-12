import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice/work_with_bloc/counter_cubit.dart';

class WorkWithBloc extends StatelessWidget {
  const WorkWithBloc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int state = context.watch<CounterCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work with Bloc'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocConsumer<CounterCubit, int>(
              listenWhen: (previous, current) {
                if (current == 1 || current == 2) {
                  return true;
                }
                return false;
              },
              listener: (context, state) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('hello')));
              },

              buildWhen: (previous, current) {
                if (current == 3) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                return Text(state.toString(), style: const TextStyle(fontSize: 24),);
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: (){
                    BlocProvider.of<CounterCubit>(context).increase();
                  },
                  child: const Text('increase'),
                ),
                ElevatedButton(
                  onPressed: (){
                    BlocProvider.of<CounterCubit>(context).decrease();
                  },
                  child: const Text('decrease'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
