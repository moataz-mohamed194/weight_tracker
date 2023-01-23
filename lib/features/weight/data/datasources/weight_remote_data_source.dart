import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ domain/entities/weight.dart';
import '../../../../core/error/Exception.dart';
import '../models/weight_Model.dart';

abstract class WeightRemoteDataSource {
  Future<Unit> addWeight(Weight weight);
  Future<Unit> logOutProfile();
  Future<Unit> deleteWeight(String id);
  Future<String?> getWeight();
}

class WeightRemoteDataSourceImple extends WeightRemoteDataSource {
  @override
  Future<Unit> addWeight(Weight weight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      CollectionReference users = FirebaseFirestore.instance
          .collection(prefs.getString('uid').toString());
      return users.add({
        'Weight': weight.name.toString(), // John Doe
        'date': DateTime.now(), // Stokes and Sons
      }).then((value) {
        return Future.value(unit);
      }).catchError((error) {
        throw FailuresLoginException();
      });
    } catch (e) {
      throw OfflineException();
    }
  }

  @override
  Future<String?> getWeight() async {
    print('get weight');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      FirebaseFirestore _db = FirebaseFirestore.instance;
      String uid = prefs.getString('uid').toString();
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection(uid).get();
      print(snapshot.docs.length);
      if (snapshot.docs.length > 0) {
        return prefs.getString('uid').toString();
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      throw OfflineException();
    }
  }

  @override
  Future<Unit> logOutProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('login', false);
      return Future.value(unit);
    } catch (e) {
      print(e);
      throw OfflineException();
    }
  }

  @override
  Future<Unit> deleteWeight(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('uid').toString();

      CollectionReference users = FirebaseFirestore.instance.collection(uid);

      users.doc(id).delete().then((value) {
        return Future.value(unit);
      }).catchError((error) {
        throw FailuresLoginException();
      });
      return Future.value(unit);
    } catch (e) {
      print(e);
      throw OfflineException();
    }
  }
}
