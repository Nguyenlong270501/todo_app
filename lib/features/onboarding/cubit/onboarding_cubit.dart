import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_state.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  static const String _onboardingKey = 'onboarding_complete';
  final SharedPreferences _prefs;

  OnboardingCubit(@Named('prefs') this._prefs) : super(OnboardingInitial()) {
    _checkOnboardingStatus();
  }

  int currentIndex = 0;

  Future<void> _checkOnboardingStatus() async {
    final isComplete = _prefs.getBool(_onboardingKey) ?? false;
    if (isComplete) {
      emit(OnboardingComplete());
    }
  }

  Future<void> savePref() async {
    await _prefs.setBool(_onboardingKey, true);
    emit(OnboardingComplete());
  }

  void skipToLast() {
    currentIndex = 2;
    emit(SkipIndexState());
  }

  void nextPage() {
    if (currentIndex < 2) {
      currentIndex++;
      emit(OnboardingInitial());
    } else {
      savePref();
    }
  }

  void previousPage() {
    if (currentIndex > 0) {
      currentIndex--;
      emit(OnboardingInitial());
    }
  }
}
