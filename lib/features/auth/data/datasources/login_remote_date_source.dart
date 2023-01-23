import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ domain/entities/login.dart';
import '../../../../core/error/Exception.dart';

abstract class LoginRemoteDataSource {
  Future<Unit> loginMethod(Login login);
  Future<Unit> createAccountMethod(Login login);
}

class LoginRemoteDataSourceImple extends LoginRemoteDataSource {
  @override
  Future<Unit> loginMethod(Login login) async {
    print('login method');
    final body = {
      'email': login.email.toString(),
      'password': login.password.toString()
    };
    try {
      print(body);
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: login.email.toString(),
              password: login.password.toString())
          .onError((error, stackTrace) {
        print(error);
        print(stackTrace);
        throw FailuresLoginException();
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', credential.user!.uid);
      prefs.setBool('login', true);

      print('done-${credential.user!.uid}');
      return Future.value(unit);
    } catch (e) {
      print(e);
      throw OfflineException();
    }
  }

  @override
  Future<Unit> createAccountMethod(Login login) async {
    print('login method');
    final body = {
      'email': login.email.toString(),
      'password': login.password.toString()
    };
    try {
      print(body);
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: login.email.toString(),
              password: login.password.toString())
          .onError((error, stackTrace) {
        print(error);
        print(stackTrace);
        throw FailuresLoginException();
      });
      print('done-$credential');
      return Future.value(unit);
    } catch (e) {
      print(e);
      throw OfflineException();
    }
  }
}
