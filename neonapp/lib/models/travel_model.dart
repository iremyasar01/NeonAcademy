import 'dart:ui';
class TravelModel {
  final String id;
  final String title;
  final String location;
  final String imageAsset;
  final Color color;

  TravelModel({
    required this.id,
    required this.title,
    required this.location,
    required this.imageAsset,
    required this.color,
  });
}

final List<TravelModel> travelModels = [
  TravelModel(
    id: '1',
    title: 'Santorini',
    location: 'Greece',
    imageAsset: 'assets/images/santorini.jpeg',
    color: const Color(0xFFF8B195),
  ),
  TravelModel(
    id: '2',
    title: 'Bali',
    location: 'Indonesia',
    imageAsset: 'assets/images/bali.jpeg',
    color: const Color(0xFF6C5B7B),
  ),
  TravelModel(
    id: '3',
    title: 'Kyoto',
    location: 'Japan',
    imageAsset: 'assets/images/kyoto.jpeg',
    color: const Color(0xFF355C7D),
  ),
  TravelModel(
    id: '4',
    title: 'Seychelles',
    location: 'Africa',
    imageAsset: 'assets/images/seychelles.jpeg',
    color: const Color(0xFF99B898),
  ),
  TravelModel(
    id: '5',
    title: 'Banff',
    location: 'Canada',
    imageAsset: 'assets/images/banff.jpeg',
    color: const Color(0xFF2A363B),
  ),
  TravelModel(
    id: '6',
    title: 'Cappadocia',
    location: 'Turkey',
    imageAsset: 'assets/images/cappadocia.jpeg',
    color: const Color(0xFFE84A5F),
  ),
];