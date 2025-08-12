import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myneonacademyapp/constants/cartoon_app_constants.dart';
import 'package:myneonacademyapp/models/cartoons_model.dart';
import 'package:myneonacademyapp/services/cartoon_api_service.dart';
import '../widgets/cartoon_of_day_card.dart';
import '../widgets/genre_chip_list.dart';
import '../widgets/section_title.dart';
import '../widgets/cartoon_grid_item.dart';
import 'detail_screen.dart';

class CartoonScreen extends StatefulWidget {
  const CartoonScreen({super.key});

  @override
  State<CartoonScreen> createState() => _CartoonScreenState();
}

class _CartoonScreenState extends State<CartoonScreen> {
  late Future<List<CartoonsModel>> _cartoonsFuture;
  final CartoonApiService _apiService = CartoonApiService();
  final TextEditingController _searchController = TextEditingController();
  List<CartoonsModel> _allCartoons = [];
  List<CartoonsModel> _filteredCartoons = [];
  bool _isSearching = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cartoonsFuture = _loadCartoons();
  }

  Future<List<CartoonsModel>> _loadCartoons() async {
    try {
      setState(() => _isLoading = true);
      final cartoons = await _apiService.fetchCartoons();
      setState(() {
        _allCartoons = cartoons;
        _isLoading = false;
      });
      return cartoons;
    } catch (e) {
      setState(() => _isLoading = false);
      rethrow;
    }
  }
//günün çizgi filmini random seçiyor.
  CartoonsModel? _getCartoonOfDay(List<CartoonsModel> cartoons) {
    if (cartoons.isEmpty) return null;
    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final random = Random(seed);
    return cartoons[random.nextInt(cartoons.length)];
  }

  List<String> _getGenres(List<CartoonsModel> cartoons) {
    return cartoons
        .expand((cartoon) => cartoon.genre ?? <String>[]) 
        .toSet()
        .toList()..sort(); // Alfabetik sırala
  }

  void _filterCartoons(String query) {
    if (!_isLoading && _allCartoons.isNotEmpty) {
      setState(() {
        _filteredCartoons = _allCartoons.where((cartoon) {
          final title = cartoon.title?.toLowerCase() ?? '';
          final genres = cartoon.genre?.join(' ').toLowerCase() ?? '';
          final creators = cartoon.creator?.join(' ').toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();
          
          return title.contains(searchQuery) || 
                 genres.contains(searchQuery) ||
                 creators.contains(searchQuery);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FutureBuilder<List<CartoonsModel>>(
        future: _cartoonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || _isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Çizgi filmler yükleniyor...'),
                  SizedBox(height: 8),
                  Text(
                    'Geçerli resimler kontrol ediliyor',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Hata: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _cartoonsFuture = _loadCartoons();
                      });
                    },
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Geçerli çizgi film bulunamadı'),
                  SizedBox(height: 8),
                  Text(
                    'Tüm resim URL\'leri kontrol edildi',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final cartoons = snapshot.data!;
          final cartoonOfDay = _getCartoonOfDay(cartoons);
          final genres = _getGenres(cartoons);
          final displayCartoons = _isSearching ? _filteredCartoons : cartoons;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (cartoonOfDay != null)
                  CartoonOfDayCard(
                    cartoon: cartoonOfDay,
                    onTap: () => _navigateToDetail(cartoonOfDay, context),
                  ),
                
                const SectionTitle(title: CartoonAppConstants.categoriesTitle),
                GenreChipList(genres: genres, cartoons: cartoons),
                
                const SectionTitle(title: CartoonAppConstants.allCartoonsTitle),
                
                // Toplam sayı bilgisi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '${displayCartoons.length} çizgi film gösteriliyor',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                if (displayCartoons.isEmpty && _isSearching)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.search_off, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Arama sonucu bulunamadı'),
                        ],
                      ),
                    ),
                  )
                else
                  _buildCartoonGrid(displayCartoons, context),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue[700],
      title: _isSearching 
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: CartoonAppConstants.searchHint,
                border: InputBorder.none,
              ),
              onChanged: _filterCartoons,
            )
          : const Text(CartoonAppConstants.appTitle),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                _filteredCartoons.clear();
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildCartoonGrid(List<CartoonsModel> cartoons, BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: cartoons.length,
      itemBuilder: (context, index) {
        final cartoon = cartoons[index];
        return CartoonGridItem(
          cartoon: cartoon,
          onTap: () => _navigateToDetail(cartoon, context),
        );
      },
    );
  }

  void _navigateToDetail(CartoonsModel cartoon, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(cartoon: cartoon),
      ),
    );
  }
}