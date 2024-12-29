import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_chat_app/features/global/themes/style.dart';
import 'package:group_chat_app/features/group/domain/entities/group_entity.dart';
import 'package:group_chat_app/features/group/presentation/cubit/group/group_cubit.dart';
import 'package:group_chat_app/features/storage/domain/usecases/upload_group_photo_usecase.dart';
import 'package:network_image/network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_chat_app/features/global/widgets/custom_text_field.dart';
import 'package:group_chat_app/features/injection_container.dart' as di;

class CreateGroupPage extends StatefulWidget {
  final String uid;

  const CreateGroupPage({super.key, required this.uid});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  @override
  void initState() {
    clear();
    super.initState();
  }

  final TextEditingController groupNameController = TextEditingController();
  final FocusNode groupFocusNode = FocusNode();

  File? imageFile;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        groupFocusNode.unfocus();
      },
      child: Stack(
        children: [
          Hero(
            tag: 'createGroup',
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: greenColor,
                title: const Text(
                  "Create Group Page",
                  style: TextStyle(color: Colors.white),
                ),
                leading: IconButton(
                  highlightColor: greenColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: ClipOval(
                            child: InkWell(
                              onTap: () {
                                getImage();
                              },
                              borderRadius: BorderRadius.circular(100),
                              child: NetworkImageWidget(
                                borderRadiusImageFile: 0,
                                imageFileBoxFit: BoxFit.cover,
                                imageFile: imageFile,
                                placeHolderBoxFit: BoxFit.cover,
                                networkImageBoxFit: BoxFit.cover,
                                progressIndicatorBuilder: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                placeHolder: "assets/profile_default.png",
                              ),
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
                        hint: "Group Name",
                        controller: groupNameController,
                        focusNode: groupFocusNode,
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 100),
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            backgroundColor:
                                const WidgetStatePropertyAll(greenColor),
                            enableFeedback: true,
                          ),
                          onPressed: () {
                            createGroup();
                          },
                          child: const Text("Create Group"),
                        ),
                      ),
                    ],
                  ),
                ),
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
                            "Creating group",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
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

  void createGroup() {
    if (groupNameController.text == '') {
      Fluttertoast.showToast(msg: "A group can't have an empty name");
      return;
    }
    if (imageFile == null) {
      Fluttertoast.showToast(msg: "Please pick an image for the group");
    }
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      di.sl<UploadGroupPhotoUsecase>().call(file: imageFile!).then((imageUrl) {
        BlocProvider.of<GroupCubit>(context)
            .getCreateGroup(
          groupEntity: GroupEntity(
            createdAt: Timestamp.now(),
            lastMessage: "",
            groupName: groupNameController.text,
            groupProfileImage: imageUrl,
            uid: widget.uid,
          ),
        )
            .then(
          (value) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Group created successfully");
            Navigator.pop(context);
          },
        );
      });
    }
  }

  void clear() {
    setState(() {
      imageFile = null;
      groupNameController.clear();
    });
  }
}
