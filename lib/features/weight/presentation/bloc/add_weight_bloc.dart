import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/features/weight/%20domain/usecases/delete_weight.dart';
import 'package:weight_tracker/features/weight/%20domain/usecases/get_all_weight.dart';
import 'package:weight_tracker/features/weight/%20domain/usecases/update_weight.dart';
import '../../ domain/usecases/add _weight.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/string/failures.dart';
import '../../../../core/string/messages.dart';
import 'add_weight_event.dart';
import 'add_weight_state.dart';

class AddUpdateGetWeightBloc
    extends Bloc<AddUpdateGetWeightEvent, AddUpdateGetWeightState> {
  final AddWeight addWeight;
  final GetAllWeight getAllWeight;
  final LogoutFromProfile updateWeight;
  final DeleteWeight deleteWeight;

  AddUpdateGetWeightBloc(
      {required this.updateWeight,
      required this.deleteWeight,
      required this.addWeight,
      required this.getAllWeight})
      : super(WeightInitial()) {
    on<AddUpdateGetWeightEvent>((event, emit) async {
      if (event is AddWeightEvent) {
        emit(LoadingWeightState());
        final failureOrDoneMessage = await addWeight(event.weight);
        emit(_mapFailureOrPostsToStateForAdd(
            failureOrDoneMessage, ADD_SUCCESS_MESSAGE));
      } else if (event is GetWeightEvent || event is RefreshWeightEvent) {
        emit(LoadingWeightState());
        final failureOrDoneMessage = await getAllWeight();
        emit(_mapFailureOrPostsToStateForGet(failureOrDoneMessage));
      } else if (event is DeleteWeightEvent) {
        emit(LoadingWeightState());
        final failureOrDoneMessage = await deleteWeight(event.weightId);
        emit(_mapFailureOrPostsToStateForAdd(
            failureOrDoneMessage, ADD_SUCCESS_MESSAGE));
      } else if (event is LogoutEvent) {
        emit(LoadingWeightState());
        // final failureOrDoneMessage = await updateWeight();
        final failureOrDoneMessage = await updateWeight();

        emit(_mapFailureOrPostsToStateForAdd(
            failureOrDoneMessage, ADD_SUCCESS_MESSAGE));
      }
    });
  }
}

AddUpdateGetWeightState _mapFailureOrPostsToStateForAdd(
    Either<Failures, Unit> either, String message) {
  return either.fold(
    (failure) => ErrorWeightState(message: _mapFailureToMessage(failure)),
    (_) => MessageAddUpdateGetWeightState(
      message: message,
    ),
  );
}

AddUpdateGetWeightState _mapFailureOrPostsToStateForGet(
    Either<Failures, String?> either) {
  return either.fold(
    (failure) => ErrorWeightState(message: _mapFailureToMessage(failure)),
    (weight) => LoadedWeightState(
      weight: weight,
    ),
  );
}

String _mapFailureToMessage(Failures failure) {
  switch (failure.runtimeType) {
    case OfflineFailures:
      return SERVER_FAILURE_MESSAGE;
    default:
      return "Unexpected Error , Please try again later .";
  }
}
