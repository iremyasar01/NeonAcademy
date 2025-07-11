import 'package:flutter/material.dart';
import 'package:neonacademymembers/extensions/extensions.dart';

class ExtensionScreen extends StatefulWidget {
  const ExtensionScreen({super.key});

  @override
  State<ExtensionScreen> createState() => _ExtensionScreenState();
}

class _ExtensionScreenState extends State<ExtensionScreen> {
  final _primeController = TextEditingController();
  final _palindromeController = TextEditingController();
  final _boolController = TextEditingController();
  final _date1Controller = TextEditingController();
  final _date2Controller = TextEditingController();
  final _dynamicController = TextEditingController();
  final _setController = TextEditingController();
  final _mapController = TextEditingController();
  final _logic1Controller = TextEditingController();
  final _logic2Controller = TextEditingController();
  String? _selectedOp = 'AND';

  String primeResult = '';
  String palindromeResult = '';
  String boolResult = '';
  String dateResult = '';
  String dynamicResult = '';
  String setResult = '';
  String logicResult = '';
  Map<String, List<String>> groupedMap = {};

  void _checkPrime() {
    final input = int.tryParse(_primeController.text.trim());
    setState(() {
      primeResult = (input == null)
          ? "❗ Please enter a valid number."
          : input < 0
              ? "❗ Enter a positive number."
              : input.isPrime
                  ? "✅ $input is prime"
                  : "❌ $input is NOT prime";
    });
  }

  void _checkPalindrome() {
    final input = _palindromeController.text.trim();
    setState(() {
      palindromeResult = input.isEmpty
          ? "❗ Please enter some text."
          : input.isPalindrome
              ? "✅ '$input' is a palindrome."
              : "❌ '$input' is not a palindrome.";
    });
  }

  void _checkDateDifference() {
    try {
      final date1 = DateTime.parse(_date1Controller.text);
      final date2 = DateTime.parse(_date2Controller.text);
      setState(() {
        dateResult = "📅 ${date1.daysBetween(date2)} days between dates.";
      });
    } catch (_) {
      setState(() {
        dateResult = "❗ Enter both dates in YYYY-MM-DD format.";
      });
    }
  }

  void _checkDynamicType() {
    final input = _dynamicController.text;
    dynamic val;
    if (int.tryParse(input) != null) {
      val = int.parse(input);
    } else if (double.tryParse(input) != null) {
      val = double.parse(input);
    } else {
      val = input;
    }

    setState(() {
      dynamicResult = "📦 Type: ${describeDynamicType(val)}";
    });
  }

  void _checkSetComplaints() {
    final items = _setController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);
    final resultSet = items.toSet().removeDuplicateComplaints();
    setState(() {
      setResult = resultSet.toString();
    });
  }

  void _groupMap() {
    final entries = _mapController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final map = {for (var i = 0; i < entries.length; i++) i: entries[i]};
    setState(() {
      groupedMap = map.groupBySurname();
    });
  }

  void _checkLogicOperation() {
    try {
      final a = _logic1Controller.text.trim().toLowerCase() == "true";
      final b = _logic2Controller.text.trim().toLowerCase() == "true";

      bool result;
      switch (_selectedOp) {
        case "AND":
          result = a.and(b);
          break;
        case "OR":
          result = a.or(b);
          break;
        case "XOR":
          result = a.xor(b);
          break;
        default:
          throw Exception("Invalid operation");
      }

      setState(() {
        logicResult = "🔎 Result: ${result ? "TRUE" : "FALSE"}";
      });
    } catch (_) {
      setState(() {
        logicResult =
            "❗ Enter valid values (true/false) and select operation.";
      });
    }
  }

  @override
  void dispose() {
    _primeController.dispose();
    _palindromeController.dispose();
    _boolController.dispose();
    _date1Controller.dispose();
    _date2Controller.dispose();
    _dynamicController.dispose();
    _setController.dispose();
    _mapController.dispose();
    _logic1Controller.dispose();
    _logic2Controller.dispose();
    super.dispose();
  }

  Widget _buildInputSection({
    required String title,
    required TextEditingController controller,
    required VoidCallback onCheck,
    required String result,
    String? hint,
    Widget? additionalWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: hint ?? "Enter value"),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: onCheck, child: const Text("Check")),
          ],
        ),
        if (additionalWidget != null) additionalWidget,
        const SizedBox(height: 6),
        Text(result,
            style: const TextStyle(
                color: Colors.teal, fontWeight: FontWeight.w600)),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("🧰 Dartian Extensions"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputSection(
              title: "🔢 Prime Checker",
              controller: _primeController,
              onCheck: _checkPrime,
              result: primeResult,
              hint: "e.g. 17",
            ),
            _buildInputSection(
              title: "🪞 Palindrome Checker",
              controller: _palindromeController,
              onCheck: _checkPalindrome,
              result: palindromeResult,
              hint: "e.g. kayak",
            ),
            _buildSectionTitle("🧠 Bool Logic Operations"),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _logic1Controller,
                    decoration:
                        const InputDecoration(hintText: "true/false"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _logic2Controller,
                    decoration:
                        const InputDecoration(hintText: "true/false"),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedOp,
                  onChanged: (value) {
                    setState(() {
                      _selectedOp = value!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(value: "AND", child: Text("AND")),
                    DropdownMenuItem(value: "OR", child: Text("OR")),
                    DropdownMenuItem(value: "XOR", child: Text("XOR")),
                  ],
                ),
              ],
            ),
            ElevatedButton(
                onPressed: _checkLogicOperation,
                child: const Text("Calculate")),
            const SizedBox(height: 6),
            Text(logicResult,
                style: const TextStyle(
                    color: Colors.teal, fontWeight: FontWeight.w600)),
            const SizedBox(height: 18),
            _buildSectionTitle("📅 Days Between Dates"),
            TextField(
              controller: _date1Controller,
              decoration: const InputDecoration(
                  hintText: "Start date (YYYY-MM-DD)"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _date2Controller,
              decoration:
                  const InputDecoration(hintText: "End date (YYYY-MM-DD)"),
            ),
            ElevatedButton(
                onPressed: _checkDateDifference,
                child: const Text("Check")),
            const SizedBox(height: 5),
            Text(dateResult,
                style: const TextStyle(
                    color: Colors.teal, fontWeight: FontWeight.w600)),
            const SizedBox(height: 18),
            _buildInputSection(
              title: "📦 Dynamic Type Checker",
              controller: _dynamicController,
              onCheck: _checkDynamicType,
              result: dynamicResult,
              hint: "e.g. 42 or 3.14 or hello",
            ),
            _buildInputSection(
              title: "📚 Set Complaint Filter",
              controller: _setController,
              onCheck: _checkSetComplaints,
              result: setResult,
              hint: "e.g. noise, trash, noise",
            ),
            _buildSectionTitle("🧑‍👩‍👧 Group by Surname"),
            TextField(
              controller: _mapController,
              decoration: const InputDecoration(
                  hintText: "e.g. Alice Smith, Bob Smith, Clara Johnson"),
            ),
            ElevatedButton(onPressed: _groupMap, child: const Text("Group")),
            const SizedBox(height: 8),
            ...groupedMap.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("${e.key}: ${e.value.join(', ')}"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

