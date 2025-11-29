part of 'auth_flow_bloc.dart';

@immutable
abstract class AuthFlowState {}

class AuthFlowLoginState extends AuthFlowState {}

class AuthFlowRegisterState extends AuthFlowState {}
