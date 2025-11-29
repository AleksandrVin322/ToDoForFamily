import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../domain/service/auth_service.dart';
import '../../../domain/service/firestore_service.dart';
import '../../../entity/family.dart';
import '../../../entity/user_bd.dart';

part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  final FirestoreService _firestoreService;
  final AuthService _authService;
  FamilyBloc({
    required FirestoreService firestoreService,
    required AuthService authService,
  })  : _firestoreService = firestoreService,
        _authService = authService,
        super(FamilyInitialEvent()) {
    on<FamilyLoadingEvent>(_onGetFamily);
    on<AddMemberEvent>(_onAddMember);
    on<DeleteMemberEvent>(_onDeleteMember);
    on<CreateFamilyEvent>(_onCreateFamily);
  }

  void _onGetFamily(
    FamilyLoadingEvent event,
    Emitter<FamilyState> emit,
  ) async {
    try {
      final user = _authService.currentUser;
      final Family family =
          await _firestoreService.getFamily(userId: user!.uid);
      final members =
          await _firestoreService.getMembersFamily(familyId: family.id);
      emit(
        FamilyCurrentState(
          family: family,
          members: members,
        ),
      );
    } catch (error) {
      emit(
        FamilyCurrentState(
          family: const Family(id: '', name: ''),
          members: const [],
        ),
      );
    }
  }

  void _onAddMember(
    AddMemberEvent event,
    Emitter<FamilyState> emit,
  ) async {
    final users = await _firestoreService.getUsers();
    final userEmail = users.where((user) => user.email == event.email).toList();
    final user = userEmail[0];
    final userId = user.id;
    final refUser = FirebaseFirestore.instance.collection('users').doc(userId);
    final refFamily =
        FirebaseFirestore.instance.collection('families').doc(event.familiesId);
    await _firestoreService.addMember(
      docFamilies: refFamily,
      docUser: refUser,
    );
    add(FamilyLoadingEvent());
  }

  void _onDeleteMember(
    DeleteMemberEvent event,
    Emitter<FamilyState> emit,
  ) {
    _firestoreService.deleteMember(
      userId: event.userId,
      familiesId: event.familiesId,
      memberId: event.userId,
    );
    add(FamilyLoadingEvent());
  }

  void _onCreateFamily(
    CreateFamilyEvent event,
    Emitter<FamilyState> emit,
  ) async {
    final user = _authService.currentUser;
    await _firestoreService.createFamily(name: event.name, user: user!);
    add(FamilyLoadingEvent());
  }
}
