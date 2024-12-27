import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SurgeryRecommendationTab extends StatefulWidget {
  final Map<String, String> patientData;

  const SurgeryRecommendationTab({super.key, required this.patientData});

  @override
  State<SurgeryRecommendationTab> createState() =>
      _SurgeryRecommendationTabState();
}

class _SurgeryRecommendationTabState extends State<SurgeryRecommendationTab> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // اطلاعات API
  final String apiKey = 'b12a39b621964269a0da06699f814f01';
  final String endpoint = 'https://marchv1.openai.azure.com/';
  final String assistantId = 'asst_MTOT6iTFyXCuRGxDjO3h8rzS';

  @override
  void initState() {
    super.initState();
    _fetchInitialRecommendation();
  }

  Future<void> _fetchInitialRecommendation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$endpoint/v1/assistants/$assistantId/invoke'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({"patientData": widget.patientData}),
      );

      if (response.statusCode == 200) {
        final recommendation = jsonDecode(response.body)['recommendation'] ??
            'No recommendation available.';
        setState(() {
          _messages.add({'role': 'AI', 'content': recommendation});
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'AI',
            'content': 'Failed to fetch recommendation. Please try again later.'
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'AI',
          'content': 'Error connecting to the server. Please check your connection.'
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage(String message) async {
    setState(() {
      _messages.add({'role': 'User', 'content': message});
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$endpoint/v1/assistants/$assistantId/invoke'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({"message": message}),
      );

      if (response.statusCode == 200) {
        final reply = jsonDecode(response.body)['reply'] ??
            'No response available from the AI.';
        setState(() {
          _messages.add({'role': 'AI', 'content': reply});
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'AI',
            'content': 'Failed to fetch response. Please try again later.'
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'AI',
          'content': 'Error connecting to the server. Please check your connection.'
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isUser = message['role'] == 'User';
              return Align(
                alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blueAccent : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message['content'] ?? '',
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_isLoading) const CircularProgressIndicator(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: "Type your message...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  final message = _messageController.text.trim();
                  if (message.isNotEmpty) {
                    _sendMessage(message);
                    _messageController.clear();
                  }
                },
                icon: const Icon(Icons.send, color: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
