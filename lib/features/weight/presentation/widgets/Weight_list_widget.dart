import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/add_weight_bloc.dart';
import '../bloc/add_weight_event.dart';

class WeightListWidget extends StatelessWidget {
  final String? uid;

  const WeightListWidget({super.key, required this.uid});

  // const WeightListWidget({Key? key, required this.weight}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(uid!)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
                title: Text(data['Weight'].toString()),
                trailing: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _onDelete(context, document.id.toString()),
                    )
                  ],
                ));
          }).toList(),
        );
      },
    );
  }

  _onDelete(BuildContext context, weightId) async {
    try {
      BlocProvider.of<AddUpdateGetWeightBloc>(context).add(DeleteWeightEvent(
        weightId: weightId,
      ));

      BlocProvider.of<AddUpdateGetWeightBloc>(context)
          .add(RefreshWeightEvent());
    } catch (e) {
      print(e);
    }
  }
}
