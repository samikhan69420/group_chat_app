import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_chat_app/features/global/themes/style.dart';
import 'package:group_chat_app/features/global/widgets/custom_text_field.dart';
import 'package:group_chat_app/features/storage/domain/usecases/upload_profile_photo_usecase.dart';
import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';
import 'package:group_chat_app/features/user/presentation/cubit/single_user/single_user_cubit.dart';
import 'package:group_chat_app/features/user/presentation/cubit/single_user/single_user_state.dart';
import 'package:group_chat_app/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:group_chat_app/on_generate_route.dart';
import 'package:network_image/network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:group_chat_app/features/injection_container.dart' as di;

class ProfilePage extends StatefulWidget {
  final String? profileUrl;
  final String? uid;
  const ProfilePage({
    super.key,
    this.uid,
    this.profileUrl = '',
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;

  File? imageFile;

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode statusFocusNode = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  @override
  void dispose() {
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    statusFocusNode.dispose();

    nameController.dispose();
    emailController.dispose();
    statusController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nameFocusNode.unfocus();
        emailFocusNode.unfocus();
        statusFocusNode.unfocus();
      },
      child: Scaffold(
        body: BlocBuilder<SingleUserCubit, SingleUserState>(
          builder: (context, state) {
            if (state is SingleUserLoaded) {
              return bodyWidget(state.currentUser);
            } else if (state is SingleUserLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const ErrorPage(
                text: "There was an error loading your profile.",
              );
            }
          },
        ),
      ),
    );
  }

  Widget bodyWidget(UserEntity user) {
    emailController.value = TextEditingValue(text: "${user.email}");
    nameController.value = TextEditingValue(text: "${user.name}");
    statusController.value = TextEditingValue(text: "${user.status}");
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => getImage(),
                  borderRadius: BorderRadius.circular(100),
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: ClipOval(
                      child: NetworkImageWidget(
                        imageUrl: user.profileUrl,
                        borderRadiusImageFile: 0,
                        imageFileBoxFit: BoxFit.cover,
                        placeHolderBoxFit: BoxFit.cover,
                        imageFile: imageFile,
                        networkImageBoxFit: BoxFit.cover,
                        progressIndicatorBuilder: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        placeHolder: "assets/profile_default.png",
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    "Remove profile widget",
                    style: TextStyle(
                      fontSize: 16,
                      color: greenColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  iconData: Icons.person,
                  hint: "Name",
                  controller: nameController,
                  focusNode: nameFocusNode,
                ),
                const SizedBox(height: 10),
                AbsorbPointer(
                  absorbing: true,
                  child: CustomTextField(
                    iconData: Icons.email,
                    hint: "Email",
                    controller: emailController,
                    focusNode: emailFocusNode,
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  iconData: Icons.description,
                  hint: "Status",
                  controller: statusController,
                  focusNode: statusFocusNode,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      backgroundColor: const WidgetStatePropertyAll(greenColor),
                      enableFeedback: true,
                    ),
                    onPressed: () {
                      nameFocusNode.unfocus();
                      emailFocusNode.unfocus();
                      statusFocusNode.unfocus();
                      updateProfile(user.uid!);
                      setState(() {});
                    },
                    child: const Text("Update Profile"),
                  ),
                ),
              ],
            ),
          ),
        ),
        isLoading
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color.fromARGB(150, 0, 0, 0),
              )
            : Container(),
        isLoading
            ? Center(
                child: Container(
                  width: 250,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.black,
                      ),
                      SizedBox(height: 20),
                      Material(
                        type: MaterialType.transparency,
                        child: Text(
                          "Updating Profile",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  void updateProfile(String uid) async {
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      di.sl<UploadProfileUsecase>().call(file: imageFile!).then((imageUrl) {
        BlocProvider.of<UserCubit>(context)
            .getUpdateUser(
                user: UserEntity(
          uid: uid,
          name: nameController.text,
          status: statusController.text,
          profileUrl: imageUrl,
        ))
            .then(
          (value) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Profile Updated");
          },
        );
      });
    } else {
      setState(() {
        isLoading = true;
      });
      BlocProvider.of<UserCubit>(context)
          .getUpdateUser(
              user: UserEntity(
        uid: uid,
        name: nameController.text,
        status: statusController.text,
      ))
          .then(
        (value) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "Profile Updated");
        },
      );
    }
  }

  Future getImage() async {
    try {
      final pickedFile = await ImagePicker.platform
          .getImageFromSource(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      } else {
        Fluttertoast.showToast(
            msg: "No image selected.", toastLength: Toast.LENGTH_SHORT);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
