part of 'family_bloc.dart';

@immutable
abstract class FamilyState {}

class FamilyInitialEvent extends FamilyState {}

class FamilyLoadingState extends FamilyState {}

class FamilyCurrentState extends FamilyState {
  final Family family;
  final List<UserBD> members;

  FamilyCurrentState({
    required this.family,
    required this.members,
  });
}
