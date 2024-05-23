// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i5;
import 'package:task_manager_app/core/di/app_module.dart' as _i16;
import 'package:task_manager_app/core/repositories/main_repository.dart' as _i8;
import 'package:task_manager_app/core/repositories/main_repository_impl.dart'
    as _i9;
import 'package:task_manager_app/core/utils/cache_helper.dart' as _i7;
import 'package:task_manager_app/features/auth/cubit/login_cubit.dart' as _i14;
import 'package:task_manager_app/features/auth/repositories/auth_repository.dart'
    as _i10;
import 'package:task_manager_app/features/auth/repositories/auth_repository_impl.dart'
    as _i11;
import 'package:task_manager_app/features/auth/services/auth_services.dart'
    as _i6;
import 'package:task_manager_app/features/home/cubit/todo_cubit.dart' as _i15;
import 'package:task_manager_app/features/home/repositories/home_repository.dart'
    as _i12;
import 'package:task_manager_app/features/home/repositories/home_repository_impl.dart'
    as _i13;
import 'package:task_manager_app/features/home/services/home_services.dart'
    as _i4;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.lazySingleton<_i3.Dio>(() => appModule.dio);
    gh.lazySingleton<_i4.HomeService>(() => _i4.HomeService(gh<_i3.Dio>()));
    await gh.factoryAsync<_i5.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i6.AuthService>(() => _i6.AuthService(gh<_i3.Dio>()));
    gh.lazySingleton<_i7.CacheHelper>(
        () => _i7.CacheHelperImpl(gh<_i5.SharedPreferences>()));
    gh.lazySingleton<_i8.MainRepository>(
        () => _i9.MainRepositoryImp(gh<_i7.CacheHelper>()));
    gh.lazySingleton<_i10.AuthRepository>(
        () => _i11.AuthRepositoryImpl(gh<_i6.AuthService>()));
    gh.lazySingleton<_i12.HomeRepository>(() => _i13.HomeRepositoryImpl(
          gh<_i4.HomeService>(),
          gh<_i8.MainRepository>(),
        ));
    gh.lazySingleton<_i14.LoginCubit>(() => _i14.LoginCubit(
          gh<_i10.AuthRepository>(),
          gh<_i8.MainRepository>(),
        ));
    gh.lazySingleton<_i15.TodoCubit>(
        () => _i15.TodoCubit(gh<_i12.HomeRepository>()));
    return this;
  }
}

class _$AppModule extends _i16.AppModule {}
