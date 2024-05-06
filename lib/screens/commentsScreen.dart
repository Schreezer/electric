import 'package:electric/resources/changingDatabase.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  StreamController _commentController =
      StreamController<List<String>>.broadcast();

  Stream<List<String>> get commentStream =>
      _commentController.stream as Stream<List<String>>;

  connectAndRegister(String billId, String userId) {
    print("we are connecting");
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected');
      socket.emit('register', billId);
      socket.emit('getComments', {'userId': userId, 'billId': billId});
    });

    socket.on('getComments', (data) {
      List<String> comments = List<String>.from(data['comments']);
      print(comments);
    });

    socket.on('commentAdded', (data) {
      List<String> comments = List<String>.from(data);
      print('New comment added: $comments');
      // _commentController.add(comments); TODO: Convert the json object to viable format
    });

    socket.on("comments", (data) {
      print("comments coming in as: ");
      _commentController.add(data);
      print(data);
    });

    socket.on('disconnect', (_) => print('Disconnected'));
  }

  disconnect() {
    socket.disconnect();
  }
}

class CommentsScreen extends StatefulWidget {
  final String userId;
  final String billId;

  const CommentsScreen({Key? key, required this.userId, required this.billId})
      : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final SocketService _socketService = SocketService();
  final TextEditingController _controller = TextEditingController();

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
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: _socketService.commentStream,
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.hasData) {
                  var comments = snapshot.data!;
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(comments[index]),
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
                  onPressed: ()async{
                    print("pressed");
                    _socketService.socket.emit('newComment',
                        {'billId': widget.billId, 'comment': _controller.text});
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
