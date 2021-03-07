import 'package:flutter/material.dart';
import 'package:food_corner/widgets/message_stream_widget.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        titleSpacing: 0.0,
        leadingWidth: 0.0,
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
            Text('Anil Kumar Lenka'),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStream(),
            Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 14,
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
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
                        ),
                      ),
                      onChanged: (value) {},
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Expanded(
                    flex: 2,
                    child: MaterialButton(
                      color: Colors.green,
                      padding: EdgeInsets.all(14.0),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      shape: CircleBorder(),
                      onPressed: () {
                        _messageController.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
