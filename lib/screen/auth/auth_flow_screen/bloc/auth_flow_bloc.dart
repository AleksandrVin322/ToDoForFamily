import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_flow_event.dart';
part 'auth_flow_state.dart';

class AuthFlowBloc extends Bloc<AuthFlowEvent, AuthFlowState> {
  AuthFlowBloc() : super(AuthFlowLoginState()) {
    on<AuthFlowSwitchLoginColumnEvent>(_onSwitchLoginColumn);
    on<AuthFlowSwitchRegisterColumnEvent>(_onSwitchRegisterColumn);
  }

  void _onSwitchLoginColumn(
    AuthFlowSwitchLoginColumnEvent event,
    Emitter<AuthFlowState> emit,
  ) {
    emit(AuthFlowLoginState());
  }

  void _onSwitchRegisterColumn(
    AuthFlowSwitchRegisterColumnEvent event,
    Emitter<AuthFlowState> emit,
  ) {
    emit(AuthFlowRegisterState());
  }
}
