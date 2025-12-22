part of 'column_login_bloc.dart';

@immutable
abstract class ColumnLoginState {}

class ColumnLoginInitialState extends ColumnLoginState {
  final bool isLoading;
  final String errorMessage;
  ColumnLoginInitialState({
    this.isLoading = false,
    this.errorMessage = '',
  });
}
