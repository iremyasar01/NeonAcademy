import 'package:flutter/material.dart';
import 'package:neonacademymembers/service/travel_preferences.dart';


class TravelScreen extends StatefulWidget {
  const TravelScreen({super.key});

  @override
 State<TravelScreen>createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  final _service = TravelPreferences();
  final TextEditingController _placeController = TextEditingController();
  List<Map<String, dynamic>> _places = [];
 

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    final loaded = await _service.loadPlaces();
    setState(() {
      _places = loaded;
    });
  }

  Future<void> _savePlaces() async {
    await _service.savePlaces(_places);
  }

  void _addPlace(String name) {
  final trimmedName = name.trim();
  if (trimmedName.isEmpty) return;

  final alreadyExists = _places.any(
    (place) => (place['name'] as String).toLowerCase() == trimmedName.toLowerCase(),
  );

  if (alreadyExists) {
    ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('🚫 This place is already in your list!')),
    );
    return;
  }

  setState(() {
    _places.add({'name': trimmedName, 'visitCount': 0});
  });
  _savePlaces();
  _placeController.clear();
}


  void _markAsVisited(Map<String, dynamic> place) async {
    final TextEditingController _countController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('How many times have you visited ${place['name']}?'),
        content: TextField(
          controller: _countController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Enter visit count'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final count = int.tryParse(_countController.text);
              if (count != null && count > 0) {
                setState(() {
                  place['visitCount'] = count;
                });
                _savePlaces();
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _incrementVisit(Map<String, dynamic> place) {
    setState(() {
      place['visitCount'] = (place['visitCount'] ?? 0) + 1;
    });
    _savePlaces();
  }

  void _decrementVisit(Map<String, dynamic> place) {
    setState(() {
      place['visitCount'] = (place['visitCount'] ?? 1) - 1;
      if (place['visitCount'] <= 0) place['visitCount'] = 0;
    });
    _savePlaces();
  }

  void _deletePlace(Map<String, dynamic> place) {
    setState(() {
      _places.remove(place);
    });
    _savePlaces();
  }

  List<Map<String, dynamic>> get dreamPlaces =>
      _places.where((p) => (p['visitCount'] ?? 0) == 0).toList();

  List<Map<String, dynamic>> get visitedPlaces =>
      _places.where((p) => (p['visitCount'] ?? 0) > 0).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dream Trip Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Clear All',
            onPressed: () async {
              await _service.clearAllData();
              setState(() {
                _places.clear();
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
             const Text("🌍 Enter a dream destination"),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _placeController,
                    decoration:const InputDecoration(hintText: 'e.g. Tokyo'),
                  ),
                ),
               const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addPlace(_placeController.text),
                  child: const Text("Add"),
                ),
              ],
            ),
           const Divider(height: 30),
            const Text("🌈 Dream Destinations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...dreamPlaces.map((place) => ListTile(
              title: Text(place['name']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check),
                    tooltip: "Mark as Visited",
                    onPressed: () => _markAsVisited(place),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: "Remove",
                    onPressed: () => _deletePlace(place),
                  ),
                ],
              ),
            )),
             const SizedBox(height: 20),
             const Text("✅ Visited Places", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...visitedPlaces.map((place) => ListTile(
              title: Text(place['name']),
              subtitle: Text("Visited ${place['visitCount']} time(s)"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon:const Icon(Icons.add),
                    tooltip: "Add visit",
                    onPressed: () => _incrementVisit(place),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    tooltip: "Remove visit",
                    onPressed: () => _decrementVisit(place),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: "Delete place",
                    onPressed: () => _deletePlace(place),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}


