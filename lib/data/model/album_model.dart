class Album {
  final int? id;
  final String? title;

  const Album({
    this.id,
    this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}
