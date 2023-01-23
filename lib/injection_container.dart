import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_tracker/features/weight/%20domain/usecases/delete_weight.dart';
import 'package:weight_tracker/features/weight/%20domain/usecases/update_weight.dart';
import 'core/network/network_info.dart';
import 'features/auth/ domain/repositories/Login_repositorie.dart';
import 'features/auth/ domain/usecases/create_user.dart';
import 'features/auth/ domain/usecases/login_usecases.dart';
import 'features/auth/data/datasources/login_remote_date_source.dart';
import 'features/auth/data/repositories/login_repositories.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'features/weight/ domain/repositories/weight_repositorie.dart';
import 'features/weight/ domain/usecases/add _weight.dart';
import 'features/weight/ domain/usecases/get_all_weight.dart';
import 'features/weight/data/datasources/weight_remote_data_source.dart';
import 'features/weight/data/repositories/weight_repositories.dart';
import 'features/weight/presentation/bloc/add_weight_bloc.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //Bloc
  sl.registerFactory(() => LoginBloc(loginMethod: sl(), createUseMethod: sl()));
  sl.registerFactory(() => AddUpdateGetWeightBloc(
      addWeight: sl(),
      getAllWeight: sl(),
      updateWeight: sl(),
      deleteWeight: sl()));

  //UseCase
  sl.registerLazySingleton(() => CreateUseCases(sl()));
  sl.registerLazySingleton(() => LoginUseCases(sl()));
  sl.registerLazySingleton(() => AddWeight(sl()));
  sl.registerLazySingleton(() => GetAllWeight(sl()));
  sl.registerLazySingleton(() => LogoutFromProfile(sl()));
  sl.registerLazySingleton(() => DeleteWeight(sl()));

  //Repository
  sl.registerLazySingleton<LoginRepositorie>(
      () => LoginRepositoriesImpl(remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<WeightRepository>(
      () => WeightRepositoriesImpl(remoteDataSource: sl(), networkInfo: sl()));

  //Datasources
  sl.registerLazySingleton<LoginRemoteDataSource>(
      () => LoginRemoteDataSourceImple());
  sl.registerLazySingleton<WeightRemoteDataSource>(
      () => WeightRemoteDataSourceImple());

  //Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
