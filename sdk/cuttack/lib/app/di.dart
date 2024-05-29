//
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'app_prefs.dart';
//
// final instance = GetIt.instance;
// Future<void> initAppModule() async {
//   final sharedPrefs = await SharedPreferences.getInstance();
//
//   // shared prefs instance
//   instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
//
//   // app prefs instance
//   instance
//       .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));
//   // network info
//   instance.registerLazySingleton<NetworkInfo>(
//           () => NetworkInfoImpl(DataConnectionChecker())
//   );
//   // dio factory
//   instance.registerLazySingleton<DioFactory>(
//           () => DioFactory(instance()));
//   // app service client
//   final dio = await instance<DioFactory>().getDio();
//   instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));
//   // remote data source
//   instance.registerLazySingleton<RemoteDataSource>(
//           () => RemoteDataSourceImplementer(instance()));
//   // local data source
//   instance.registerLazySingleton<LocalDataSource>(
//           () => LocalDataSourceImplementer());
//
//   // repository
//   instance.registerLazySingleton<Repository>(
//           () => RepositoryImpl(instance(), instance(),instance()));
// }
//   // DI APPLY LOGINMODULE
//   initLoginModule() {
//     if (!GetIt.I.isRegistered<LoginUseCase>()) {
//       instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
//       instance.registerFactory<LoginViewModel>(() =>
//           LoginViewModel(instance()));
//     }
//   }
//   // FogotPassword
// initFogotPasswordModule() {
//   if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
//     instance.registerFactory<ForgotPasswordUseCase>(() => ForgotPasswordUseCase(instance()));
//     instance.registerFactory<ForgotPasswordViewModel>(() =>
//         ForgotPasswordViewModel(instance()));
//   }
// }
// initRegisterModule() {
//   if (!GetIt.I.isRegistered<RegisterUseCase>()) {
//     instance.registerFactory<RegisterUseCase>(
//             () => RegisterUseCase(instance()));
//     instance.registerFactory<RegisterViewModel>(
//             () => RegisterViewModel(instance()));
//     instance.registerFactory<ImagePicker>(
//             () => ImagePicker());
//   }
// }
// initHomeModule() {
//   if (!GetIt.I.isRegistered<HomeUseCase>()) {
//     instance.registerFactory<HomeUseCase>(
//             () => HomeUseCase(instance()));
//     instance.registerFactory<HomeViewModel>(
//             () => HomeViewModel(instance()));
//   }
// }
// initStoreDetailsModule() {
//   if (!GetIt.I.isRegistered<StoreDetailsUseCase>()) {
//     instance.registerFactory<StoreDetailsUseCase>(
//             () => StoreDetailsUseCase(instance()));
//     instance.registerFactory<StoreDetailsViewModel>(
//             () => StoreDetailsViewModel(instance()));
//   }
// }
