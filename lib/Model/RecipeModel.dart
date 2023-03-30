class Recipe {
  final String RecipeID;
  final String RecipeName;
  final String RecipePhoto;
  final String description;
  final String callories;
  final String ingredients;
  final String time;
  final String persons;

  Recipe({
    required this.RecipeID,
    required this.RecipeName,
    required this.RecipePhoto,
    required this.description,
    required this.callories,
    required this.ingredients,
    required this.time,
    required this.persons,
  });

  Map<String, dynamic> toJson() => {
        'RecipeID': RecipeID,
        'RecipeName': RecipeName,
        'RecipePhoto': RecipePhoto,
        'description': description,
        'callories': callories,
        'ingredients': ingredients,
        'time': time,
        'persons': persons,
      };

  static Recipe fromJson(Map<String, dynamic> json) => Recipe(
        RecipeID: json['RecipeID'],
        RecipeName: json['RecipeName'],
        RecipePhoto: json['RecipePhoto'],
        description: json['description'],
        callories: json['callories'].toString(),
        ingredients: json['ingredients'],
        time: json['time'],
        persons: json['persons'],
      );

  Map<String, dynamic> toMap() {
    return {
      'RecipeID': RecipeID,
      'RecipeName': RecipeName,
      'RecipePhoto': RecipePhoto,
      'description': description,
      'callories': callories,
      'ingredients': ingredients,
      'time': time,
      'persons': persons,
    };
  }

  factory Recipe.fromMap(map) {
    return Recipe(
      RecipeID: map['RecipeID'],
      RecipeName: map['RecipeName'],
      RecipePhoto: map['RecipePhoto'],
      description: map['description'],
      callories: map['callories'].toString(),
      ingredients: map['ingredients'],
      time: map['time'],
      persons: map['persons'],
    );
  }
}
