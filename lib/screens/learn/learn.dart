import 'package:flutter/material.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chatgpt")),
      body: Center(
        child: Text("Welcome to the Chatbot Screen!"),
      ),
    );
  }
}
