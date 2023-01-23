import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ domain/entities/weight.dart';
import '../bloc/add_weight_bloc.dart';
import '../bloc/add_weight_event.dart';

@immutable
class FormWeightWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();

  FormWeightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextFormField(
              controller: _titleController,
              validator: (val) =>
                  val!.isEmpty ? 'the weight of Weight' : null,
              decoration: const InputDecoration(hintText: 'Weight'),
              // minLines: 2,
              // maxLines: 2,
            ),
          ),
          ElevatedButton.icon(
              onPressed: () => validateFormThenUpdateOrAddPost(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Weight'))
        ],
      ),
    );
  }

  void validateFormThenUpdateOrAddPost(BuildContext context) {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      try {
        final weight = Weight(
          id: 0,
          name: _titleController.text.toString(),
        );
        BlocProvider.of<AddUpdateGetWeightBloc>(context)
            .add(AddWeightEvent(weight: weight));
      } catch (e) {
        print(e);
      }
    }
  }
}
