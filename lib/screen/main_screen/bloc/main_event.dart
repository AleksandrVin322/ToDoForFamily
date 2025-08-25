part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class CheckVerificationEvent extends MainEvent {}

class SendVerificationEmailEvent extends MainEvent {}

class SignOutEvent extends MainEvent {}
