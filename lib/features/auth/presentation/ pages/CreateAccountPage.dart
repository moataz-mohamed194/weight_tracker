import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../weight/presentation/ pages/get_all_weight.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_state.dart';
import '../widgets/form_widget.dart';

class CreateAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: _body(context),
    ));
  }

  Widget _body(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is MessageLoginState) {
              SnackBarMessage()
                  .showSuccesSnackBar(message: state.message, context: context);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => GetAllWeightPage()),
                  (route) => false);
            } else if (state is ErrorLoginState) {
              SnackBarMessage()
                  .showErrorSnackBar(message: state.message, context: context);
            }
          },
          builder: (context, state) {
            if (state is LoadingLoginState) {
              return LoadingWidget();
            }
            return FormWidget(
              isItLoginForm: false,
            );
          },
        ),
      ),
    );
  }
}
