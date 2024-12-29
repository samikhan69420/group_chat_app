import 'dart:async';

import 'package:flutter/material.dart';
import 'package:group_chat_app/features/global/themes/style.dart';
import 'package:group_chat_app/features/group/domain/entities/group_entity.dart';
import 'package:group_chat_app/features/group/domain/entities/single_message_entity.dart';
import 'package:group_chat_app/features/group/domain/entities/text_message_entity.dart';
import 'package:group_chat_app/features/group/presentation/cubit/chat/chat_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_chat_app/features/group/presentation/cubit/group/group_cubit.dart';
import 'package:intl/intl.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleChatPage extends StatefulWidget {
  final SingleMessageEntity singleMessageEntity;

  const SingleChatPage({
    super.key,
    required this.singleMessageEntity,
  });

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  final TextEditingController messageController = TextEditingController();
  bool showSendIcon = false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<ChatCubit>(context)
        .getMessages(channelId: widget.singleMessageEntity.groupId);
    if (scrollController.hasClients) {
      Timer(
        const Duration(milliseconds: 100),
        () {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCirc);
        },
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 20),
            Text(
              widget.singleMessageEntity.groupName,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: greenColor,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, chatState) {
          if (chatState is ChatLoaded) {
            var messages = chatState.messages;
            return Column(
              children: [
                _messageListWidget(messages),
                messageField(),
              ],
            );
          } else if (chatState is ChatFailure) {
            return const Center(
              child: Text("There was an error while loading your chats"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget messageField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 5,
                            color: Color.fromARGB(60, 0, 0, 0),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: messageController,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              showSendIcon = false;
                            });
                          } else {
                            setState(() {
                              showSendIcon = true;
                            });
                          }
                        },
                        cursorColor: greenColor,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(top: 15),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.attach_file),
                                  color: Colors.grey,
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.camera_alt),
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                          hintText: "Type a message",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(100),
            enableFeedback: true,
            onTap: () {
              setState(() {
                showSendIcon = false;
              });
              sendMessage(messageContent: messageController.text);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: greenColor,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 5,
                    color: Color.fromARGB(60, 0, 0, 0),
                  )
                ],
              ),
              height: 55,
              width: 55,
              child: Icon(
                showSendIcon ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageLayout({
    required String text,
    required String time,
    required Color color,
    required TextAlign align,
    required CrossAxisAlignment boxAlign,
    required CrossAxisAlignment crossAlign,
    required String name,
    required TextAlign alignName,
    required BubbleNip nip,
  }) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.90,
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(3),
            child: Bubble(
              color: color,
              nip: nip,
              child: Column(
                crossAxisAlignment: crossAlign,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    textAlign: alignName,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    text,
                    textAlign: align,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    time,
                    textAlign: align,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(
                        .4,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _messageListWidget(List<TextMessageEntity> messages) {
    // if (scrollController.hasClients) {
    //   Timer(
    //     const Duration(milliseconds: 100),
    //     () {
    //       scrollController.animateTo(scrollController.position.maxScrollExtent,
    //           duration: const Duration(milliseconds: 300),
    //           curve: Curves.easeOutCirc);
    //     },
    //   );
    // }

    return Expanded(
        child: ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        final singleMessage = messages[index];

        if (singleMessage.senderId == widget.singleMessageEntity.uid) {
          return _messageLayout(
            name: "Me",
            alignName: TextAlign.end,
            color: Colors.lightGreen,
            time: DateFormat('hh:mm a').format(singleMessage.time!.toDate()),
            align: TextAlign.left,
            nip: BubbleNip.rightTop,
            boxAlign: CrossAxisAlignment.start,
            crossAlign: CrossAxisAlignment.end,
            text: singleMessage.content!,
          );
        } else {
          return _messageLayout(
            color: Colors.white,
            nip: BubbleNip.leftTop,
            name: "${singleMessage.senderName}",
            alignName: TextAlign.end,
            time: DateFormat('hh:mm a').format(singleMessage.time!.toDate()),
            align: TextAlign.left,
            boxAlign: CrossAxisAlignment.start,
            crossAlign: CrossAxisAlignment.start,
            text: singleMessage.content!,
          );
        }
      },
    ));
  }

  void sendMessage({required String messageContent}) {
    BlocProvider.of<ChatCubit>(context)
        .sendTextMessage(
      textMessageEntity: TextMessageEntity(
        time: Timestamp.now(),
        content: messageContent,
        senderName: widget.singleMessageEntity.username,
        senderId: widget.singleMessageEntity.uid,
        type: "TEXT",
      ),
      channelId: widget.singleMessageEntity.groupId,
    )
        .then(
      (value) {
        print(messageContent);
        BlocProvider.of<GroupCubit>(context).updateGroup(
          groupEntity: GroupEntity(
            groupId: widget.singleMessageEntity.groupId,
            lastMessage: messageContent,
          ),
        );
        messageController.clear();
      },
    );
  }
}
