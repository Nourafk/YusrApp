class RecipesRequest {
  final String addByUid;
  final String countPersonRecipe;
  final String recipeType;
  final String dateAdd;
  final String desRecipe;
  final String imageRecipe;
  final String ingredientsRecipe;
  final bool isShow;
  final String nameRecipe;
  final String nutritionalInformationRecipe;
  final String timeEndRecipe;
  final String state;
  final String RecipeId;

  RecipesRequest({
    required this.imageRecipe,
    required this.nutritionalInformationRecipe,
    required this.ingredientsRecipe,
    required this.timeEndRecipe,
    required this.recipeType,
    required this.nameRecipe,
    required this.dateAdd,
    required this.desRecipe,
    required this.countPersonRecipe,
    required this.isShow,
    required this.state,
    required this.addByUid,
    required this.RecipeId,
  });

  Map<String, dynamic> toJson() => {
        'imageRecipe': imageRecipe,
        'nutritionalInformationRecipe': nutritionalInformationRecipe,
        'timeEndRecipe': timeEndRecipe,
        'recipeType': recipeType,
        'dateAdd': dateAdd,
        'nameRecipe': nameRecipe,
        'state': state,
        'ingredientsRecipe': ingredientsRecipe,
        'desRecipe': desRecipe,
        'countPersonRecipe': countPersonRecipe,
        'isShow': isShow,
        'addByUid': addByUid,
        'RecipeId': RecipeId,
      };

  static RecipesRequest fromJson(Map<String, dynamic> json) => RecipesRequest(
        imageRecipe: json['imageRecipe'],
        countPersonRecipe: json['countPersonRecipe'],
        dateAdd: json['dateAdd'],
        recipeType: json['recipeType'] ?? "",
        timeEndRecipe: json['timeEndRecipe'],
        state: json['state'],
        nutritionalInformationRecipe: json['nutritionalInformationRecipe'],
        nameRecipe: json['nameRecipe'],
        desRecipe: json['desRecipe'],
        ingredientsRecipe: json['ingredientsRecipe'],
        isShow: json['isShow'],
        addByUid: json['addByUid'],
        RecipeId: json['RecipeId'],
      );

  Map<String, dynamic> toMap() {
    return {
      'imageRecipe': imageRecipe,
      'nutritionalInformationRecipe': nutritionalInformationRecipe,
      'timeEndRecipe': timeEndRecipe,
      'recipeType': recipeType,
      'dateAdd': dateAdd,
      'nameRecipe': nameRecipe,
      'state': state,
      'ingredientsRecipe': ingredientsRecipe,
      'desRecipe': desRecipe,
      'countPersonRecipe': countPersonRecipe,
      'isShow': isShow,
      'addByUid': addByUid,
      'RecipeId': RecipeId,
    };
  }

  factory RecipesRequest.fromMap(map) => RecipesRequest(
        imageRecipe: map['imageRecipe'],
        countPersonRecipe: map['countPersonRecipe'],
        dateAdd: map['dateAdd'],
        recipeType: map['recipeType'],
        timeEndRecipe: map['timeEndRecipe'],
        state: map['state'],
        nutritionalInformationRecipe: map['nutritionalInformationRecipe'],
        nameRecipe: map['nameRecipe'],
        desRecipe: map['desRecipe'],
        ingredientsRecipe: map['ingredientsRecipe'],
        isShow: map['isShow'],
        addByUid: map['addByUid'],
        RecipeId: map['RecipeId'],
      );
}
