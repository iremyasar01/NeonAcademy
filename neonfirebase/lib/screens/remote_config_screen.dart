import 'package:flutter/material.dart';
import 'package:neonfirebase/service/remote_config_service.dart';

class RemoteConfigScreen extends StatefulWidget {
  const RemoteConfigScreen({super.key});

  @override
  State<RemoteConfigScreen> createState() => _RemoteConfigScreenState();
}

class _RemoteConfigScreenState extends State<RemoteConfigScreen> {
  bool _isLoading = true;
  bool _isImageHidden = false;
  String _title = "";
  int _year = 0;

  @override
  void initState() {
    super.initState();
    _loadRemoteConfigValues();
  }

  Future<void> _loadRemoteConfigValues() async {
    // Firebase Remote Config değerlerini yükle
    await RemoteConfigService.fetchAndActivate();

    setState(() {
      _isImageHidden = RemoteConfigService.isImageHidden;
      _title = RemoteConfigService.title;
      _year = RemoteConfigService.year;
      _isLoading = false;
    });
  }

  Future<void> _refreshConfig() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Yenileme efekti için
    await _loadRemoteConfigValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eurovision Remote Config'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshConfig,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Year: $_year',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.lightBlue,
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (!_isImageHidden)
                     Image.asset(
                      "assets/images/eurovision_logo.jpeg",
                     ),
                    const SizedBox(height: 20),
                    Text(
                      _isImageHidden
                          ? '⚠️ Eurovision görseli şu anda gizli!'
                          : '🌟 Eurovision görseli görüntüleniyor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _isImageHidden ? Colors.red : Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'The Hidden Image of Eurovision: A Remote Config Tale',
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Developers quickly adapted when the organizers changed the image visibility "
                        "through Firebase Remote Config during the competition. Their quick response "
                        "ensured the app's success with millions of Eurovision fans worldwide.",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: _refreshConfig,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Config Yenile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}