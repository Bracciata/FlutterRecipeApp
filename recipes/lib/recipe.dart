class Recipe {
  String title;
  String publisher;
  String id;
  String url;
  String imageUrl;
  List<dynamic> ingredients;
  Recipe({this.id, this.title, this.publisher, this.url, this.imageUrl,this.ingredients});
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
        id: json['recipe_id'] as String,
        title: json['title'] as String,
        publisher: json['publisher'] as String,
        url: "",
        imageUrl: "",
        ingredients: List<dynamic>());
  }
  factory Recipe.fromJsonIndividual(Map<String, dynamic> json) {
    return Recipe(
        id: json['recipe_id'] as String,
        title: json['title'] as String,
        publisher: json['publisher'] as String,
        url: json["source_url"] as String,
        imageUrl: json["image_url"] as String,
        ingredients: json["ingredients"] as List<dynamic>);
  }
}
