import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../../../../injection_container.dart' as di;
import '../../../../core/widgets/message_display_widget.dart';
import '../../../auth/presentation/ pages/LoginPage.dart';
import '../bloc/add_weight_bloc.dart';
import '../bloc/add_weight_event.dart';
import '../bloc/add_weight_state.dart';
import '../widgets/Weight_list_widget.dart';
import 'add_weight.dart';

class GetAllWeightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight'),
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<AddUpdateGetWeightBloc>(context)
                    .add(LogoutEvent());
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingBtn(context),
    );
  }

  Widget _buildBody() {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: BlocProvider<AddUpdateGetWeightBloc>(
            create: (context) =>
                di.sl<AddUpdateGetWeightBloc>()..add(GetWeightEvent()),
            child: BlocBuilder<AddUpdateGetWeightBloc, AddUpdateGetWeightState>(
              builder: (context, state) {
                if (state is LoadingWeightState) {
                  return LoadingWidget();
                } else if (state is LoadedWeightState) {
                  return RefreshIndicator(
                      onRefresh: () => _onRefresh(context),
                      child: WeightListWidget(uid: state.weight));
                } else if (state is ErrorWeightState) {
                  return MessageDisplayWidget(message: state.message);
                }
                return LoadingWidget();
              },
            )));
  }

  Widget _buildFloatingBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => AddWeightPage()));
      },
      child: const Icon(Icons.add),
    );
  }

  _onRefresh(BuildContext context) async {
    try {
      BlocProvider.of<AddUpdateGetWeightBloc>(context)
          .add(RefreshWeightEvent());
    } catch (e) {
      print(e);
    }
  }
}
