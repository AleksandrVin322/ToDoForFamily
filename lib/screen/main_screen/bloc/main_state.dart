part of 'main_bloc.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}

class VerificationUserState extends MainState {}

class NonVerificationUserState extends MainState {}
