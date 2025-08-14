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
  bool isKenTyping = false;

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
  }

  // İlk yüklemede Ken'in mesajlarını getir
  Future<void> _loadInitialMessages() async {
    try {
      List<Message> fetchedMessages = await _apiService.fetchMessages();
      // API'den gelen mesajları Ken'in mesajları olarak göster
      List<Message> kenMessages = fetchedMessages.map((msg) => Message(
        id: msg.id,
        name: "Ken", // API mesajlarını Ken'e atfet
        body: msg.body,
        email: "ken@example.com",
        time: DateTime.now().subtract(Duration(minutes: fetchedMessages.indexOf(msg) * 5)),
      )).toList();

      setState(() => messages = kenMessages);
      _scrollToBottom();
    } catch (e) {
      _showError('Ken\'in mesajları yüklenemedi: $e');
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
    
    // Kullanıcının mesajını hemen ekle
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch,
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
    
    // Eğer Barbie mesaj attıysa, Ken'den cevap getir
    if (currentUser == "Barbie") {
      _getKenResponse();
    }

    // API'ye mesajı gönder
    try {
      final success = await _apiService.sendMessage(
        currentUser,
        currentUser == "Barbie" ? "barbie@example.com" : "ken@example.com",
        messageText,
      );

      if (!success) {
        _showError('Mesaj gönderilemedi');
      }
    } catch (e) {
      _showError('Hata: $e');
    }
  }

  // Ken'den otomatik cevap getir
  Future<void> _getKenResponse() async {
    // Ken yazıyor göster
    setState(() => isKenTyping = true);
    
    // 1-3 saniye bekle (gerçekçi typing effect)
    await Future.delayed(Duration(seconds: 1 + (DateTime.now().millisecond % 3)));
    
    try {
      // API'den yeni mesaj getir (Ken'in cevabı olarak)
      List<Message> fetchedMessages = await _apiService.fetchMessages();
      
      if (fetchedMessages.isNotEmpty) {
        // Rastgele bir mesaj seç veya son mesajı al
        final randomIndex = DateTime.now().millisecond % fetchedMessages.length;
        final apiMessage = fetchedMessages[randomIndex];
        
        final kenResponse = Message(
          id: DateTime.now().millisecondsSinceEpoch,
          name: "Ken",
          body: apiMessage.body,
          email: "ken@example.com",
          time: DateTime.now(),
        );
        
        setState(() {
          isKenTyping = false;
          messages.add(kenResponse);
        });
        
        _scrollToBottom();
      }
    } catch (e) {
      setState(() => isKenTyping = false);
      _showError('Ken cevap veremedi: $e');
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
            onPressed: _loadInitialMessages,
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
                itemCount: messages.length + (isKenTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  // Ken yazıyor göstergesi
                  if (index == messages.length && isKenTyping) {
                    return _buildTypingIndicator();
                  }
                  
                  final message = messages[index];
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

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Ken yazıyor",
              style: TextStyle(
                color: Colors.blue[700],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[300]!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}