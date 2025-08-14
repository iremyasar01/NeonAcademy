import 'package:flutter/material.dart';

class UserSelector extends StatelessWidget {
  final String currentUser;
  final ValueChanged<String> onUserChanged;

  const UserSelector({
    super.key,
    required this.currentUser,
    required this.onUserChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration:const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildUserButton("Barbie", Colors.pink),
          const SizedBox(width: 20),
          _buildUserButton("Ken", Colors.blue),
        ],
      ),
    );
  }

  Widget _buildUserButton(String user, Color color) {
    final isSelected = currentUser == user;
    return GestureDetector(
      onTap: () => onUserChanged(user),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              user == "Barbie" ? Icons.person : Icons.person_outline,
              color: isSelected ? color : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              user,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}