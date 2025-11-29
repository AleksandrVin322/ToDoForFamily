part of 'auth_flow_bloc.dart';

@immutable
abstract class AuthFlowEvent {}

class AuthFlowSwitchLoginColumnEvent extends AuthFlowEvent {}

class AuthFlowSwitchRegisterColumnEvent extends AuthFlowEvent {}
