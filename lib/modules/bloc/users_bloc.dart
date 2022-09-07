import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fluttertask/models/users_model.dart';
import 'package:fluttertask/repository/users_repository.dart';
import 'package:fluttertask/response/users_response.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  int total = 0;
  int limit = 0;
  int skip = 0;
  List<UsersModel> usersList = [];
  UsersBloc() : super(UsersInitial()) {
    on<GetUsers>((GetUsers event, Emitter<UsersState> emit) async{
      try {
        emit(GetUsersLoading());
        final UsersResponse response = await UsersRepo.getAllUsers();
        if (response.total != 0) {
          total = response.total;
          limit = response.limit;
          skip = response.skip;
          usersList = <UsersModel>[];
          usersList = response.results!;
          emit(GetUsersSuccess(usersList: response.results!));
        } else {
          emit(GetUsersFailed(error: "Error"));
        }
      } catch (e) {
        emit(GetUsersFailed(error: e.toString()));
      }
    });
  }
}
