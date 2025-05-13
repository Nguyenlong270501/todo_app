// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/onboarding/cubit/onboarding_cubit.dart' as _i547;
import '../../features/profile/cubit/profile_cubit.dart' as _i271;
import '../../features/task/blocs/task/task_cubit.dart' as _i1008;
import '../services/shared_prefs_service.dart' as _i816;
import '../theme/theme_cubit.dart' as _i611;
import 'injection_module.dart' as _i212;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectionModule = _$InjectionModule();
    gh.factory<_i271.ProfileCubit>(() => _i271.ProfileCubit());
    gh.factory<_i1008.TaskCubit>(() => _i1008.TaskCubit());
    gh.lazySingleton<_i816.SharedPrefsService>(
      () => _i816.SharedPrefsService(),
    );
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => injectionModule.prefs,
      instanceName: 'prefs',
      preResolve: true,
    );
    gh.factory<_i611.ThemeCubit>(
      () =>
          _i611.ThemeCubit(gh<_i460.SharedPreferences>(instanceName: 'prefs')),
    );
    gh.factory<_i547.OnboardingCubit>(
      () => _i547.OnboardingCubit(
        gh<_i460.SharedPreferences>(instanceName: 'prefs'),
      ),
    );
    return this;
  }
}

class _$InjectionModule extends _i212.InjectionModule {}
