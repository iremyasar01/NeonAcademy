class CartoonsModel {
  String? title;
  int? year;
  List<String>? creator;
  String? rating;
  List<String>? genre;
  int? runtimeInMinutes;
  int? episodes;
  String? image;
  int? id;

  CartoonsModel(
      {this.title,
      this.year,
      this.creator,
      this.rating,
      this.genre,
      this.runtimeInMinutes,
      this.episodes,
      this.image,
      this.id});
      

  CartoonsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    year = json['year'];
    creator = json['creator'].cast<String>();
    rating = json['rating'];
    genre = json['genre'].cast<String>();
    runtimeInMinutes = json['runtime_in_minutes'];
    episodes = json['episodes'];
    image = json['image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['year'] = year;
    data['creator'] = creator;
    data['rating'] = rating;
    data['genre'] = genre;
    data['runtime_in_minutes'] = runtimeInMinutes;
    data['episodes'] = episodes;
    data['image'] = image;
    data['id'] = id;
    return data;
  }
    // copyWith metodu ekleniyor
  CartoonsModel copyWith({
    int? id,
    String? title,
    int? year,
    int? episodes,
    List<String>? genre,
    List<String>? creator,
    String? image,
  }) {
    return CartoonsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      episodes: episodes ?? this.episodes,
      genre: genre ?? this.genre,
      creator: creator ?? this.creator,
      image: image ?? this.image,
    );
  }
}
