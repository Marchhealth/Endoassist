import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SurgeryRecommendationTab extends StatefulWidget {
  final Map<String, String> patientData;

  const SurgeryRecommendationTab({super.key, required this.patientData});

  @override
  State<SurgeryRecommendationTab> createState() => _SurgeryRecommendationTabState();
}

class _SurgeryRecommendationTabState extends State<SurgeryRecommendationTab> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _prepareInitialPrompt();
  }

  void _prepareInitialPrompt() {
    String initialPrompt = """
Based on the following patient data, please provide a surgery recommendation analysis:
- Name: ${widget.patientData['name']}
- Age: ${_calculateAge(widget.patientData['dateOfBirth'] ?? '')}
- Diagnosis: ${widget.patientData['diagnosis']}
- CA-125 Level: ${widget.patientData['ca125']}
- AMH Level: ${widget.patientData['amh']}
- Symptoms: ${widget.patientData['symptoms']}
""";
    _sendMessage(initialPrompt, isInitial: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildPatientSummaryCard(),
          Expanded(
            child: _buildChatInterface(),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[700]!, Colors.indigo[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Patient Summary",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow("Name", widget.patientData['name'] ?? "Unknown"),
          _buildSummaryRow("Age", "${_calculateAge(widget.patientData['dateOfBirth'] ?? '')} years"),
          _buildSummaryRow("Diagnosis", widget.patientData['diagnosis'] ?? "Unknown"),
          _buildSummaryRow("CA-125", "${widget.patientData['ca125'] ?? 'N/A'} U/mL"),
          _buildSummaryRow("AMH", "${widget.patientData['amh'] ?? 'N/A'} ng/mL"),
        ],
      ),
    );
  }

  Widget _buildChatInterface() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildChatHeader(),
          Expanded(child: _buildMessagesList()),
          if (_isLoading) const LinearProgressIndicator(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.medical_services, color: Colors.indigo),
          SizedBox(width: 8),
          Text(
            "Surgery Recommendation Assistant",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isUser = message['role'] == 'User';
        return _buildMessageBubble(message, isUser);
      },
    );
  }

  Widget _buildMessageBubble(Map<String, String> message, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isUser ? Colors.indigo[600] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message['content'] ?? '',
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Ask about surgery recommendation...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              final message = _messageController.text.trim();
              if (message.isNotEmpty) {
                _sendMessage(message);
                _messageController.clear();
              }
            },
            mini: true,
            backgroundColor: Colors.indigo[600],
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String message, {bool isInitial = false}) async {
    setState(() {
      if (!isInitial) {
        _messages.add({'role': 'User', 'content': message});
      }
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://marchv1.openai.azure.com/openai/deployments/gpt-4/chat/completions?api-version=2024-02-15-preview'),
        headers: {
          'Content-Type': 'application/json',
          'api-key': 'b12a39b621964269a0da06699f814f01',
        },
        body: jsonEncode({
          "messages": [
            {
              "role": "system",
              "content": "You are an endometriosis surgery recommendation assistant. Analyze patient data and lab results to provide evidence-based surgical recommendations."
            },
            {"role": "user", "content": message}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final reply = responseData['choices']?[0]?['message']?['content'] ?? 
                     'No response available from the AI.';
        
        setState(() {
          _messages.add({'role': 'AI', 'content': reply});
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'AI', 
            'content': 'Error: ${response.statusCode} - ${response.body}'
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'AI', 
          'content': 'Error connecting to the server: ${e.toString()}'
        });
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  int _calculateAge(String dateOfBirth) {
    if (dateOfBirth.isEmpty) return 0;
    final dob = DateTime.parse(dateOfBirth);
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }
}
