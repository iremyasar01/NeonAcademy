import 'package:flutter/material.dart';
import 'package:neonapp/widgets/accaount_card.dart';
import '../models/account_model.dart';
import '../widgets/action_button.dart';
import '../widgets/home_header.dart';

class FlexibleScreen extends StatelessWidget {
  FlexibleScreen({super.key});

  final List<Account> accounts = [
    Account('Checking', 5423.75),
    Account('Savings', 12890.30),
    Account('Investment', 35642.18),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FinSmart'),
        backgroundColor: Colors.green[200],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HomeHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                return AccountCard(account: accounts[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionButton(
                  icon: Icons.add,
                  label: 'Add Expense',
                  color: Colors.redAccent,
                  onPressed: () {},
                ),
                const SizedBox(width: 12),
                ActionButton(
                  icon: Icons.swap_horiz,
                  label: 'Transfer',
                  color: Colors.blueAccent,
                  onPressed: () {},
                ),
                const SizedBox(width: 12),
                ActionButton(
                  icon: Icons.pie_chart,
                  label: 'Budget',
                  color: Colors.green,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
