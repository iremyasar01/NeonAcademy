import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final bool showName;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.showName,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isMe 
                ? (message.name == "Barbie" ? Colors.pink[100] : Colors.blue[100])
                : (message.name == "Barbie" ? Colors.pink[50] : Colors.blue[50]),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
              bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
            ),
            boxShadow: const[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showName)
                Text(
                  message.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: message.name == "Barbie" ? Colors.pink[800] : Colors.blue[800],
                  ),
                ),
              if (showName) const SizedBox(height: 6),
              
              Text(
                message.body,
                style: TextStyle(
                  color: message.name == "Barbie" ? Colors.pink[900] : Colors.blue[900],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('HH:mm').format(message.time),
                    style: TextStyle(
                      fontSize: 10,
                      color: message.name == "Barbie" ? Colors.pink[700] : Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}