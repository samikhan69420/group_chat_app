import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';
import 'package:group_chat_app/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:group_chat_app/on_generate_route.dart';
import 'package:network_image/network_image.dart';
import 'package:group_chat_app/features/user/presentation/cubit/user/user_state.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserLoaded) {
          final List<UserEntity> users = state.users;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                onTap: () {},
                title: Text(user.name!),
                subtitle: Text(user.status!),
                leading: SizedBox(
                  height: 50,
                  width: 50,
                  child: ClipOval(
                    child: NetworkImageWidget(
                      imageUrl: user.profileUrl,
                      borderRadiusImageFile: 0,
                      imageFileBoxFit: BoxFit.cover,
                      placeHolderBoxFit: BoxFit.cover,
                      networkImageBoxFit: BoxFit.cover,
                      progressIndicatorBuilder: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      placeHolder: "assets/profile_default.png",
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const ErrorPage(
            text: "Error loading users",
          );
        }
      },
    ));
  }
}
