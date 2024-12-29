import 'package:flutter/material.dart';
import 'package:group_chat_app/features/global/themes/style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_app/features/group/presentation/cubit/group/group_cubit.dart';
import 'package:group_chat_app/features/group/presentation/pages/group_page.dart';
import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';
import 'package:group_chat_app/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:group_chat_app/features/user/presentation/cubit/single_user/single_user_cubit.dart';
import 'package:group_chat_app/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:group_chat_app/features/user/presentation/pages/all_users/all_users_page.dart';
import 'package:group_chat_app/features/user/presentation/pages/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({
    required this.uid,
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    BlocProvider.of<SingleUserCubit>(context)
        .getSingleUserProfile(user: UserEntity(uid: widget.uid));
    BlocProvider.of<UserCubit>(context)
        .getUsers(user: UserEntity(uid: widget.uid));
    BlocProvider.of<GroupCubit>(context).getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greenColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: Colors.white,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  BlocProvider.of<AuthCubit>(context).logOut();
                },
                child: const Text("Log Out"),
              ),
            ],
            icon: const Icon(Icons.more_vert),
            iconColor: Colors.white,
          ),
        ],
        title: const Text(
          "Group Chat App",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          unselectedLabelStyle: const TextStyle(fontSize: 17),
          labelStyle: const TextStyle(fontSize: 17),
          dividerColor: Colors.grey[500],
          automaticIndicatorColorAdjustment: true,
          indicatorSize: TabBarIndicatorSize.tab,
          physics: const BouncingScrollPhysics(),
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          controller: tabController,
          indicatorWeight: 4,
          tabs: const [
            SizedBox(
              height: 30,
              child: Center(child: Text("Groups")),
            ),
            SizedBox(
              height: 30,
              child: Center(child: Text("Users")),
            ),
            SizedBox(
              height: 30,
              child: Center(
                child: Text("Profile"),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        physics: const BouncingScrollPhysics(),
        controller: tabController,
        children: [
          GroupPage(
            uid: widget.uid,
          ),
          const AllUsers(),
          const ProfilePage(),
        ],
      ),
    );
  }
}
