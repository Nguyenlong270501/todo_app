import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class ChangeCurrentIndexState extends OnboardingState {}

class RemoveFromCurrentIndexState extends OnboardingState {}

class SkipIndexState extends OnboardingState {
  const SkipIndexState();
}

class OnboardingComplete extends OnboardingState {
  const OnboardingComplete();
}
