import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/snackbar_message.dart';
import '../bloc/add_weight_bloc.dart';
import '../bloc/add_weight_state.dart';
import '../widgets/form_widget.dart';

class AddWeightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Weight'),
      ),
      body: appBody(context),
    );
  }

  Widget appBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocConsumer<AddUpdateGetWeightBloc, AddUpdateGetWeightState>(
          listener: (context, state) {
            if (state is MessageAddUpdateGetWeightState) {
              SnackBarMessage()
                  .showSuccesSnackBar(message: state.message, context: context);
              Navigator.pop(context);
            } else if (state is ErrorWeightState) {
              SnackBarMessage()
                  .showErrorSnackBar(message: state.message, context: context);
            }
          },
          builder: (context, state) {
            // if (state is LoadingWeightState){
            // return LoadingWidget();
            // }
            return FormWeightWidget();
          },
        ),
      ),
    );
  }
}
