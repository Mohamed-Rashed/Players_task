part of 'users_bloc.dart';

@immutable
abstract class UsersState {}

class UsersInitial extends UsersState {}


class GetUsersLoading extends UsersState{}
class GetUsersSuccess extends UsersState{
  final List<UsersModel> usersList;

  GetUsersSuccess({required this.usersList});
}
class GetUsersFailed extends UsersState{
  final String error;

  GetUsersFailed({required this.error});
}
