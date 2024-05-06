import 'dart:convert';

import 'package:electric/models/comment.dart';
import 'package:electric/resources/changingDatabase.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

Comment commentFromJson(Map<String, dynamic> json) {
  return Comment.fromJson(json);
}

class CommentsScreen extends StatefulWidget {
  final String userId;
  final String billId;

  const CommentsScreen({Key? key, required this.userId, required this.billId})
      : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

  Future<void> _scrollToMaxExtent(ScrollController _scrollController) async {
    await Future.delayed(Duration(milliseconds: 300));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

class SocketService {
  late IO.Socket socket;
  StreamController _commentController =
      StreamController<List<Comment>>.broadcast();
  final scrollController = ScrollController();


  Stream<List<Comment>> get commentStream =>
      _commentController.stream as Stream<List<Comment>>;

  connectAndRegister(String billId, String userId) {
    print("we are connecting");
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'reconnection': true,
      'reconnectionDelay': 1000,
    });

    socket.on('connect', (_) {
      print('Connected');
      socket.emit('register', billId);
      socket.emit('getComments', {'userId': userId, 'billId': billId});
    });

    socket.on('getComments', (data) {
      List<String> comments = List<String>.from(data['comments']);
      print(comments);
      // TODO: Convert the json object to viable format and store in the stream
    });

    socket.on('commentAdded', (data)async {
      print("comment added");
      List<Comment> newComm = List<Map<String, dynamic>>.from(data)
          .map<Comment>((json) => commentFromJson(json))
          .toList();
      _commentController.add(newComm);
      // scrollController.animateTo(
      // scrollController.position.maxScrollExtent+10,
      // duration: Duration(milliseconds: 500),
      // curve: Curves.easeInOut,
      await _scrollToMaxExtent(scrollController);
    });

    socket.on("comments", (data) {
      print("comments coming in as: ");
      print(data['comments']);
      List<Comment> comments = List<Map<String, dynamic>>.from(data['comments'])
          .map<Comment>((json) => commentFromJson(json))
          .toList();

      _commentController.add(comments);
    });

    socket.on('disconnect', (_) => print('Disconnected'));
  }

  disconnect() {
    socket.disconnect();
  }
}

class _CommentsScreenState extends State<CommentsScreen> {
  final SocketService _socketService = SocketService();
  final TextEditingController _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _socketService.connectAndRegister(widget.billId, widget.userId);
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }

  void initialise() async {
    // to be checked
    _socketService._commentController
        .add(fetchComments(widget.billId, widget.userId));
    // TODO: To check and implement correctly
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _socketService.socket.emit("disconnect");
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          // Expanded(
          //   child: StreamBuilder<List<Comment>>(
          //     stream: _socketService.commentStream,
          //     builder:
          //         (BuildContext context, AsyncSnapshot<List<Comment>> snapshot) {
          //       if (snapshot.hasData) {
          //         var comments = snapshot.data!;
          //         return ListView.builder(
          //           itemCount: comments.length,
          //           itemBuilder: (context, index) {
          //             return ListTile(
          //               title: Text(comments[index].text?? "null"),
          //             );
          //           },
          //         );
          //       } else {
          //         return const Center(child: CircularProgressIndicator());
          //       }
          //     },
          //   ),
          // ),
          Expanded(
            child: StreamBuilder<List<Comment>>(
              stream: _socketService.commentStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Comment>> snapshot) {
                if (snapshot.hasData) {
                  var comments = snapshot.data!;
                  return ListView.builder(
                    controller: _socketService.scrollController,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      bool isAdmin = comments[index].writer ==
                          'admin'; // Check if the writer is admin
                      return Align(
                        alignment: isAdmin
                            ? Alignment.centerRight
                            : Alignment
                                .centerLeft, // Align right if admin, left if consumer
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isAdmin
                                ? Colors.blue
                                : Colors.grey[
                                    300], // Different colors for admin and consumer
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: isAdmin
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment
                                    .start, // Align text to the end or start
                            children: [
                              Text(
                                comments[index].writer??"", // Display the writer
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isAdmin ? Colors.white : Colors.black,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                comments[index].text ??
                                    "null", // Display the message text
                                style: TextStyle(
                                  color: isAdmin ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: 'Enter comment'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    print("pressed");
                    _socketService.socket.emit('newComment', {
                      'billId': widget.billId,
                      'comment': _controller.text,
                      'userId': widget.userId
                    });
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
