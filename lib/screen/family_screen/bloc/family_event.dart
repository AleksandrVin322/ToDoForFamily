part of 'family_bloc.dart';

@immutable
abstract class FamilyEvent {}

class FamilyLoadingEvent extends FamilyEvent {}

class AddMemberEvent extends FamilyEvent {
  final String email;
  final String familiesId;

  AddMemberEvent({
    required this.email,
    required this.familiesId,
  });
}

class DeleteMemberEvent extends FamilyEvent {
  final String userId;
  final String familiesId;

  DeleteMemberEvent({
    required this.userId,
    required this.familiesId,
  });
}

class CreateFamilyEvent extends FamilyEvent {
  final String name;

  CreateFamilyEvent({required this.name});
}
