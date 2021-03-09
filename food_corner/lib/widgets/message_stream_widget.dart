import 'package:flutter/material.dart';
import 'package:food_corner/widgets/message_bubble_widget.dart';
import 'package:food_corner/widgets/spinner_widget.dart';
import '../services/firebase_api.dart';

class MessageStream extends StatelessWidget {
  final String consumerId;
  final String sellerId;
  final String currentUserId;

  const MessageStream(
      {Key key, this.consumerId, this.sellerId, this.currentUserId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseApi().getChatSnapshots(consumerId, sellerId),
      builder: (context, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting)
          return Spinner();
        final chatData = chatSnapshots.data.docs;
        if (chatData.length == 0)
          return Center(
            child: Text('No conversation found!'),
          );
        return ListView.builder(
          itemCount: chatData.length,
          reverse: true,
          itemBuilder: (context, index) => MessageBubble(
            message: chatData[index]['message'],
            isMe: chatData[index]['senderId'] == currentUserId ? true : false,
          ),
        );
      },
    );
  }
}
