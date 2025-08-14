import 'package:flutter/material.dart';
import 'package:myneonacademyapp/services/message_api_service.dart';
import 'package:myneonacademyapp/widgets/message_buble.dart';
import '../models/message_model.dart';
import '../widgets/user_selector.dart';
import '../widgets/message_input.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final MessageApiService _apiService = MessageApiService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String currentUser = "Barbie";
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      List<Message> fetchedMessages = await _apiService.fetchMessages();
      setState(() => messages = fetchedMessages);
      _scrollToBottom();
    } catch (e) {
      _showError('Mesajlar yüklenemedi: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;
    
    // Optimistik UI: Anında ekranda göster
    final newMessage = Message(
      id: messages.length + 1,
      name: currentUser,
      body: messageText,
      email: currentUser == "Barbie" ? "barbie@example.com" : "ken@example.com",
      time: DateTime.now(),
    );
    
    setState(() {
      messages.add(newMessage);
      _messageController.clear();
    });
    
    _scrollToBottom();
    
    // API'ye gönder
    try {
      final success = await _apiService.sendMessage(
        currentUser,
        currentUser == "Barbie" ? "barbie@example.com" : "ken@example.com",
        messageText,
      );

      if (!success) {
        // Hata durumunda geri al
        setState(() => messages.removeLast());
        _showError('Mesaj gönderilemedi');
      }
    } catch (e) {
      setState(() => messages.removeLast());
      _showError('Hata: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barbie 💖 Ken'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMessages,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE4F1), Color(0xFFE1F5FE)],
          ),
        ),
        child: Column(
          children: [
            UserSelector(
              currentUser: currentUser,
              onUserChanged: (user) => setState(() => currentUser = user),
            ),
            
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  // Mesajın kimin tarafından gönderildiğine göre hizalama
                  final isMe = message.name == currentUser;
                  final showName = index == 0 || 
                                  messages[index - 1].name != message.name;
                  
                  return MessageBubble(
                    message: message,
                    isMe: isMe,
                    showName: showName,
                  );
                },
              ),
            ),
            
            MessageInput(
              controller: _messageController,
              onSendPressed: _sendMessage,
              onSubmitted: (_) => _sendMessage(),
            ),
          ],
        ),
      ),
    );
  }
}