class Recipe {
  String title;
  String publisher;
  String id;
  Recipe({this.id, this.title, this.publisher});
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['recipe_id'] as String,
      title: json['title'] as String,
      publisher: json['publisher'] as String,
    );
  }
}