import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ pages/CreateAccountPage.dart';
import '../../ domain/entities/login.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';

class FormWidget extends StatelessWidget {
  final bool isItLoginForm;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FormWidget({super.key, required this.isItLoginForm});
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (val) => val!.isEmpty
                  ? 'must add the email'
                  : val.contains(RegExp(r"^\S+@\S+\.\S+$")) == false
                      ? "must add valid email"
                      : null,
              decoration: InputDecoration(hintText: 'Email'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.text,
                validator: (val) => val!.isEmpty
                    ? 'must add the password'
                    : val.length < 8
                        ? "the password must be more than 8 digits"
                        : null,
                decoration: InputDecoration(hintText: 'password'),
                obscureText: true),
          ),
          ElevatedButton.icon(
              onPressed: () => validateFormThenUpdateOrAddPost(context),
              icon: Icon(Icons.login),
              label: isItLoginForm == true ? Text('Login') : Text('Create')),
          isItLoginForm == true
              ? InkWell(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAccountPage()),
                    );
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  void validateFormThenUpdateOrAddPost(BuildContext context) {
    final isValid = _formKey.currentState!.validate();

    if (isValid && isItLoginForm == true) {
      final login = Login(
        email: _emailController.text.toString(),
        password: _passwordController.text.toString(),
      );

      BlocProvider.of<LoginBloc>(context).add(LoginMethodEvent(login: login));
    } else if (isValid && isItLoginForm == false) {
      final login = Login(
        email: _emailController.text.toString(),
        password: _passwordController.text.toString(),
      );
      BlocProvider.of<LoginBloc>(context).add(AddUserEvent(login: login));
    }
  }
}
