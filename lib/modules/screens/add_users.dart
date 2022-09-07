import 'package:control_style/decorated_input_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertask/models/users_model.dart';
import 'package:fluttertask/modules/bloc/users_bloc.dart';

class AddUsers extends StatefulWidget {
  const AddUsers({Key? key}) : super(key: key);

  @override
  _AddUsersState createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  late UsersBloc usersBloc;
  final TextEditingController searchController = TextEditingController();
  late FocusNode myFocusNode;
  List<UsersModel> usersList = [];
  List<bool> add = [];
  late List<UsersModel> searchList = [];

  @override
  void initState() {
    usersBloc = BlocProvider.of<UsersBloc>(context);
    usersBloc
      ..add(GetUsers())
      ..stream.listen((state) {
        if (state is GetUsersSuccess) {
          setState(() {
            usersList = state.usersList;
            searchList = state.usersList;
            for (int i = 0; i < searchList.length; i++) {
              add.add(false);
            }
          });
        }
      });
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            const Align(
              child: Text(
                "Add Players",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: searchList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  if (add[index] == true) {
                    return Stack(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          backgroundImage:
                              NetworkImage(searchList[index].image!),
                        ),
                        Positioned(
                          top: 0,
                          right: 2,
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                add[index] = false;
                              });
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 10,
                              child: Icon(Icons.close,color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Icon(Icons.person_add_rounded),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  enabled: true,
                  textDirection:
                      Localizations.localeOf(context).languageCode == "en"
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                  controller: searchController,
                  autofocus: false,
                  focusNode: myFocusNode,
                  keyboardType: TextInputType.name,
                  onEditingComplete: () {
                    setState(() {
                      searchList = usersList
                          .where((element) =>  element.username!
                          .toLowerCase()
                          .contains(searchController.text
                          .toLowerCase()))
                          .toList();
                    });

                  },
                  decoration: InputDecoration(
                    hintText: "Search by player name",
                    hintTextDirection:
                        Localizations.localeOf(context).languageCode == "en"
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                    border: DecoratedInputBorder(
                      child: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    prefixIcon: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Icon(Icons.search),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      maxWidth: 80,
                    ),
                    contentPadding: const EdgeInsets.all(0.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            BlocConsumer<UsersBloc, UsersState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is GetUsersLoading) {
                  return const CircularProgressIndicator();
                } else if (state is GetUsersFailed) {
                  return Container();
                } else if (state is GetUsersSuccess) {
                  return Expanded(
                    child: ListView.separated(
                      itemCount: searchList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 16,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(searchList[index].image!),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              searchList[index].username!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 15),
                            ),
                            const Spacer(),
                            add[index] == false
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        add[index] = true;
                                      });
                                    },
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: const Center(
                                        child: Text(
                                          "Add",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        add[index] = false;
                                      });
                                    },
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: const Center(
                                        child: Text(
                                          "Remove",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
