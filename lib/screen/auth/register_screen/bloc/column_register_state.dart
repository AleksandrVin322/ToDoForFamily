part of 'column_register_bloc.dart';

@immutable
abstract class ColumnRegisterState {}

class ColumnRegisterInitial extends ColumnRegisterState {
  final bool isLoading;
  final String errorMessage;
  ColumnRegisterInitial({
    this.isLoading = false,
    this.errorMessage = '',
  });
}
