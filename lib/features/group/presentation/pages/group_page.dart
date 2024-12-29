import 'package:flutter/material.dart';
import 'package:group_chat_app/features/global/const/page_const.dart';
import 'package:group_chat_app/features/global/themes/style.dart';
import 'package:group_chat_app/features/group/domain/entities/group_entity.dart';
import 'package:group_chat_app/features/group/domain/entities/single_message_entity.dart';
import 'package:group_chat_app/features/group/presentation/cubit/group/group_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_app/features/user/presentation/cubit/single_user/single_user_cubit.dart';
import 'package:group_chat_app/features/user/presentation/cubit/single_user/single_user_state.dart';
import 'package:network_image/network_image.dart';
import 'package:group_chat_app/on_generate_route.dart';

class GroupPage extends StatefulWidget {
  final String uid;

  const GroupPage({super.key, required this.uid});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        enableFeedback: true,
        backgroundColor: greenColor,
        heroTag: 'createGroup',
        onPressed: () {
          Navigator.pushNamed(
            context,
            PageConst.createGroupPage,
            arguments: widget.uid,
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: BlocBuilder<SingleUserCubit, SingleUserState>(
        builder: (context, singleUserState) {
          if (singleUserState is SingleUserLoaded) {
            final currentUser = singleUserState.currentUser;
            return BlocBuilder<GroupCubit, GroupState>(
              builder: (context, groupState) {
                if (groupState is GroupLoaded) {
                  List<GroupEntity> groupList = groupState.groups;
                  if (groupList.isEmpty) {
                    return const Center(
                      child: Text("No Groups"),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: groupList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final groupInfo = groupList[index];
                          return ListTile(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                PageConst.singleChatPage,
                                arguments: SingleMessageEntity(
                                  groupId: groupInfo.groupId!,
                                  groupName: groupInfo.groupName!,
                                  uid: currentUser.uid!,
                                  username: currentUser.name!,
                                ),
                              );
                            },
                            title: Text("${groupInfo.groupName}"),
                            subtitle: Text("${groupInfo.lastMessage}"),
                            leading: SizedBox(
                              height: 50,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: NetworkImageWidget(
                                  borderRadiusImageFile: 50,
                                  imageFileBoxFit: BoxFit.cover,
                                  placeHolderBoxFit: BoxFit.cover,
                                  networkImageBoxFit: BoxFit.cover,
                                  imageUrl: groupInfo.groupProfileImage,
                                  progressIndicatorBuilder: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  placeHolder: "assets/profile_default.png",
                                ),
                              ),
                            ),
                          );
                        });
                  }
                } else if (groupState is GroupLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const ErrorPage(
                    text: "We encountered an issue while loading your groups",
                  );
                }
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
