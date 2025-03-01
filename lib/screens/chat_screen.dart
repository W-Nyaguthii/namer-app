import 'package:flutter/material.dart';
import '../services/chat_gpt_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatGPTService chatGPTService = ChatGPTService();
  final TextEditingController _controller = TextEditingController();
  String _response = '';

  void _sendMessage() async {
    String message = _controller.text;
    setState(() => _response = 'Thinking...');
    String reply = await chatGPTService.sendMessage(message);
    setState(() => _response = reply);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Financial Assistant')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration:
                  InputDecoration(labelText: 'Ask a financial question...'),
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _sendMessage, child: Text('Send')),
            SizedBox(height: 20),
            Text('Response: $_response', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
