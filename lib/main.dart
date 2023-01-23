
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/weight/presentation/ pages/get_all_weight.dart';
import 'features/weight/presentation/bloc/add_weight_bloc.dart';
import 'injection_container.dart' as di;
import 'core/App_Theme.dart';
import 'features/auth/presentation/ pages/LoginPage.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? uLogin = prefs.getBool('login');
  print(uLogin);
  runApp( MyApp(login:uLogin));
}

class MyApp extends StatelessWidget {
  final bool? login;
   MyApp({super.key, this.login});


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_)=> di.sl<LoginBloc>()),
          BlocProvider(create: (_)=> di.sl<AddUpdateGetWeightBloc>()),

        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          title: 'Posts App',
          home:login==true?GetAllWeightPage():LoginPage()
        )
    );
  }
}

