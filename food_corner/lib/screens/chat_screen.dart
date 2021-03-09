import 'package:flutter/material.dart';
import 'package:food_corner/models/order_model.dart';
import 'package:food_corner/models/user_model.dart';
import 'package:food_corner/services/firebase_api.dart';
import 'package:food_corner/widgets/message_stream_widget.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'ChatScreen';

  final UserModel user;
  final UserModel currentUser;
  final OrderModel order;

  const ChatScreen(
      {Key key,
      @required this.user,
      @required this.order,
      @required this.currentUser})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseApi _firebaseApi = FirebaseApi();

  String message = '';

  sendChatMessage(String message) async {
    await _firebaseApi.addNewMessage(
      message: message,
      userId: widget.currentUser.userRole == 'seller'
          ? widget.order.consumerId
          : widget.currentUser.userId,
      sellerId: widget.currentUser.userRole == 'seller'
          ? widget.currentUser.userId
          : widget.user.userId,
      // orderId: widget.order.orderId,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        leading: Container(),
        titleSpacing: 0.0,
        leadingWidth: 3.0,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_back),
                  ClipOval(
                    child: Material(
                      color: Colors.white,
                      child: Container(
                        width: 38.0,
                        height: 38.0,
                        child: Icon(
                          Icons.chat,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            InkWell(
              child: Text(widget.user.userName),
              onTap: () {
                print('user profile details');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 4.0,
          right: 4.0,
          top: 4.0,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 14,
              child: TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                maxLines: 7,
                minLines: 1,
                controller: _messageController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(24.0),
                    ),
                  ),
                  fillColor: Colors.green[500],
                  filled: true,
                  hintText: 'Type a message',
                  hintStyle: TextStyle(
                    color: Colors.white70,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                ),
                onChanged: (value) {
                  message = value.trim();
                },
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            SizedBox(
              width: 2.0,
            ),
            Expanded(
              flex: 2,
              child: MaterialButton(
                disabledColor: Colors.grey,
                textColor: Colors.white,
                color: Colors.green,
                padding: EdgeInsets.all(14.0),
                child: Icon(
                  Icons.send,
                  size: 20,
                ),
                shape: CircleBorder(),
                onPressed: () {
                  _messageController.clear();
                  if (message.isNotEmpty) sendChatMessage(message);
                },
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(4.0),
        child: MessageStream(
          consumerId: widget.currentUser.userRole == 'seller'
              ? widget.order.consumerId
              : widget.currentUser.userId,
          sellerId: widget.currentUser.userRole == 'seller'
              ? widget.currentUser.userId
              : widget.user.userId,
          currentUserId: widget.currentUser.userId,
        ),
      ),
    );
  }
}
