import 'package:flutter/material.dart';
import 'package:neonacademymembers/service/travel_preferences.dart';

class TravelScreen extends StatefulWidget {
  const TravelScreen({super.key});

  @override
  State<TravelScreen> createState() => _TravelScreenState();
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
    if (!mounted) return;
    setState(() {
      _places = loaded;
    });
  }

  Future<void> _savePlaces() async {
    await _service.savePlaces(_places);
  }

  void _addPlace(String name) async {
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

    final hasVisited = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Have you been here before?'),
        content: const Text('Select your experience with this place'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Not yet! 🌠'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes! 🗺️'),
          ),
        ],
      ),
    ) ?? false;

    if (!mounted) return;

    int visitCount = 0;
    if (hasVisited) {
      final count = await showDialog<int>(
        context: context,
        builder: (context) => VisitCountDialog(placeName: trimmedName),
      );

      if (!mounted) return;

      if (count == null || count <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid number')),
        );
        return;
      }

      visitCount = count;
    }

    setState(() {
      _places.add({
        'name': trimmedName,
        'hasVisited': hasVisited,
        'visitCount': visitCount,
      });
    });

    _savePlaces();
    _placeController.clear();
  }

  void _updatePlaceStatus(Map<String, dynamic> place) async {
    if (place['hasVisited'] == true) return;

    final hasVisited = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Have you visited ${place['name']}?'),
        content: const Text('Mark this as visited?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Not yet'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes!'),
          ),
        ],
      ),
    ) ?? false;

    if (!mounted || !hasVisited) return;

    final count = await showDialog<int>(
      context: context,
      builder: (context) => VisitCountDialog(placeName: place['name']),
    );

    if (!mounted) return;

    if (count == null || count <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    setState(() {
      place['hasVisited'] = true;
      place['visitCount'] = count;
    });
    _savePlaces();
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
      if (place['visitCount'] <= 0) {
        place['visitCount'] = 0;
        place['hasVisited'] = false;
      }
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
      _places.where((p) => p['hasVisited'] == false).toList();

  List<Map<String, dynamic>> get visitedPlaces =>
      _places.where((p) => p['hasVisited'] == true).toList();

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
              if (!mounted) return;
              setState(() {
                _places.clear();
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "🌍 Where do you dream of visiting?",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _placeController,
                            decoration: const InputDecoration(
                              hintText: 'Enter a dream destination...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _addPlace(_placeController.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          ),
                          child: const Text("Add Dream"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.star, color: Colors.amber), text: "Dream"),
                        Tab(icon: Icon(Icons.check, color: Colors.green), text: "Visited"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          dreamPlaces.isEmpty
                              ? const Center(child: Text("No dream destinations yet!"))
                              : ListView.builder(
                                  itemCount: dreamPlaces.length,
                                  itemBuilder: (context, index) {
                                    final place = dreamPlaces[index];
                                    return _buildDreamPlaceCard(place);
                                  },
                                ),
                          visitedPlaces.isEmpty
                              ? const Center(child: Text("No visited places yet!"))
                              : ListView.builder(
                                  itemCount: visitedPlaces.length,
                                  itemBuilder: (context, index) {
                                    final place = visitedPlaces[index];
                                    return _buildVisitedPlaceCard(place);
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDreamPlaceCard(Map<String, dynamic> place) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.star, color: Colors.amber),
        title: Text(place['name']),
        subtitle: const Text("Not visited yet"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              tooltip: "Mark as visited",
              onPressed: () => _updatePlaceStatus(place),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: "Remove",
              onPressed: () => _deletePlace(place),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitedPlaceCard(Map<String, dynamic> place) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.flag, color: Colors.green),
        title: Text(place['name']),
        subtitle: Text("Visited ${place['visitCount']} time(s)"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: "Add visit",
              onPressed: () => _incrementVisit(place),
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              tooltip: "Remove visit",
              onPressed: () => _decrementVisit(place),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: "Delete place",
              onPressed: () => _deletePlace(place),
            ),
          ],
        ),
      ),
    );
  }
}

class VisitCountDialog extends StatelessWidget {
  final String placeName;
  final TextEditingController _countController = TextEditingController();

  VisitCountDialog({super.key, required this.placeName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('How many times have you visited $placeName?'),
      content: TextField(
        controller: _countController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Enter visit count',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final count = int.tryParse(_countController.text);
            if (count != null && count > 0) {
              Navigator.pop(context, count);
            } else {
              Navigator.pop(context, null);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}



