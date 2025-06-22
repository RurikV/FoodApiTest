import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'models/recipe.dart';
import 'models/recipe_step.dart';
import 'models/ingredient.dart';
import 'models/recipe_ingredient.dart' as ri;
import 'models/recipe_step_link.dart' as rsl;
import 'models/measure_unit.dart';
import 'models/favorite.dart';
import 'models/comment.dart';

class FoodApiClient {
  // API endpoints
  static const String _recipeEndpoint = '/recipe';
  static const String _recipeStepEndpoint = '/recipe_step';
  static const String _recipeStepLinkEndpoint = '/recipe_step_link';
  static const String _ingredientEndpoint = '/ingredient';
  static const String _recipeIngredientEndpoint = '/recipe_ingredient';
  static const String _measureUnitEndpoint = '/measure_unit';
  final String baseUrl;
  final http.Client _httpClient;
  final bool useMockData;

  /// Creates a new FoodApiClient
  /// 
  /// [baseUrl] - The base URL of the Food API
  /// [httpClient] - An optional HTTP client to use for requests
  /// [useMockData] - Whether to use mock data instead of making actual API calls
  ///
  /// If [useMockData] is false, the client will attempt to use the real API first,
  /// but will automatically fall back to mock data if the API is unavailable or returns an error.
  FoodApiClient({
    required this.baseUrl,
    http.Client? httpClient,
    this.useMockData = false, // Default to trying the real API first, with fallback to mock data
  }) : _httpClient = httpClient ?? _createHttpClient();

  static http.Client _createHttpClient() {
    HttpClient client = HttpClient()
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    return IOClient(client);
  }

  /// Fetches a list of recipes from the API
  Future<List<Recipe>> getRecipes({int? count, int? offset}) async {
    if (useMockData) {
      print('Using mock data for recipes');
      return _getMockRecipes(count: count, offset: offset);
    }

    final queryParams = <String, String>{};
    if (count != null) queryParams['count'] = count.toString();
    if (offset != null) queryParams['offset'] = offset.toString();

    print('Fetching recipes from: $baseUrl/recipe');
    final uri = Uri.parse('$baseUrl/recipe').replace(queryParameters: queryParams);

    try {
      // Skip the ping check since the server might not have an endpoint at the base URL
      // Just try to fetch the recipes directly

      final response = await _httpClient.get(uri);
      print('Recipe endpoint response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Recipe.fromJson(json)).toList();
      } else {
        print('Error response body: ${response.body}');
        print('Recipe endpoint is not available, falling back to mock data');
        return _getMockRecipes(count: count, offset: offset);
      }
    } catch (e) {
      print('Exception during API request: $e');
      print('Error occurred, falling back to mock data');
      return _getMockRecipes(count: count, offset: offset);
    }
  }

  /// Returns mock recipe data
  List<Recipe> _getMockRecipes({int? count, int? offset}) {
    // Create mock measure units
    final measureUnit1 = MeasureUnitRef(id: 1);
    final measureUnit2 = MeasureUnitRef(id: 2);
    final measureUnit3 = MeasureUnitRef(id: 3);

    // Create mock ingredients
    final ingredient1 = ri.IngredientRef(id: 1);
    final ingredient2 = ri.IngredientRef(id: 2);
    final ingredient3 = ri.IngredientRef(id: 3);
    final ingredient4 = ri.IngredientRef(id: 4);
    final ingredient5 = ri.IngredientRef(id: 5);
    final ingredient666 = ri.IngredientRef(id: 666); // Add ingredient with ID 666

    // Create mock recipe references
    final recipe1Ref = ri.RecipeRef(id: 1);
    final recipe2Ref = ri.RecipeRef(id: 2);

    // Create mock recipe ingredients
    final recipeIngredient1 = ri.RecipeIngredient(
      id: 1,
      count: 200,
      ingredient: ingredient1,
      recipe: recipe1Ref,
    );

    final recipeIngredient2 = ri.RecipeIngredient(
      id: 2,
      count: 3,
      ingredient: ingredient2,
      recipe: recipe1Ref,
    );

    final recipeIngredient3 = ri.RecipeIngredient(
      id: 3,
      count: 1,
      ingredient: ingredient3,
      recipe: recipe1Ref,
    );

    final recipeIngredient4 = ri.RecipeIngredient(
      id: 4,
      count: 100,
      ingredient: ingredient4,
      recipe: recipe2Ref,
    );

    final recipeIngredient5 = ri.RecipeIngredient(
      id: 5,
      count: 2,
      ingredient: ingredient5,
      recipe: recipe2Ref,
    );

    // Create recipe ingredient for ingredient 666
    final recipeIngredient666 = ri.RecipeIngredient(
      id: 666,
      count: 1,
      ingredient: ingredient666,
      recipe: recipe1Ref,
    );

    // Create mock step references
    final step1 = rsl.StepRef(id: 1);
    final step2 = rsl.StepRef(id: 2);
    final step3 = rsl.StepRef(id: 3);
    final step4 = rsl.StepRef(id: 4);

    // Create mock recipe references for step links
    final recipe1StepRef = rsl.RecipeRef(id: 1);
    final recipe2StepRef = rsl.RecipeRef(id: 2);

    // Create mock recipe step links
    final recipeStepLink1 = rsl.RecipeStepLink(
      id: 1,
      number: 1,
      recipe: recipe1StepRef,
      step: step1,
    );

    final recipeStepLink2 = rsl.RecipeStepLink(
      id: 2,
      number: 2,
      recipe: recipe1StepRef,
      step: step2,
    );

    final recipeStepLink3 = rsl.RecipeStepLink(
      id: 3,
      number: 1,
      recipe: recipe2StepRef,
      step: step3,
    );

    final recipeStepLink4 = rsl.RecipeStepLink(
      id: 4,
      number: 2,
      recipe: recipe2StepRef,
      step: step4,
    );

    // Create mock recipes
    final recipes = [
      Recipe(
        id: 1,
        name: 'Spaghetti Carbonara',
        duration: 30,
        photo: 'https://example.com/carbonara.jpg',
        ingredients: [recipeIngredient1, recipeIngredient2, recipeIngredient3, recipeIngredient666], // Added ingredient 666
        stepLinks: [recipeStepLink1, recipeStepLink2],
      ),
      Recipe(
        id: 2,
        name: 'Chicken Alfredo',
        duration: 45,
        photo: 'https://example.com/alfredo.jpg',
        ingredients: [recipeIngredient3, recipeIngredient4, recipeIngredient5],
        stepLinks: [recipeStepLink3, recipeStepLink4],
      ),
    ];

    // Apply pagination if requested
    int startIndex = offset ?? 0;
    int endIndex = count != null ? startIndex + count : recipes.length;

    if (startIndex >= recipes.length) {
      return [];
    }

    endIndex = endIndex.clamp(0, recipes.length);
    return recipes.sublist(startIndex, endIndex);
  }

  /// Fetches a single recipe by ID
  Future<Recipe> getRecipe(String id) async {
    if (useMockData) {
      print('Using mock data for recipe with id: $id');
      return _getMockRecipe(id);
    }

    try {
      final uri = Uri.parse('$baseUrl/recipe/$id');
      final response = await _httpClient.get(uri);

      if (response.statusCode == 200) {
        return Recipe.fromJson(json.decode(response.body));
      } else {
        print('Error loading recipe: ${response.statusCode}, falling back to mock data');
        return _getMockRecipe(id);
      }
    } catch (e) {
      print('Exception during API request: $e, falling back to mock data');
      return _getMockRecipe(id);
    }
  }

  /// Returns a mock recipe by ID
  Recipe _getMockRecipe(String id) {
    final recipes = _getMockRecipes();
    final recipeId = int.tryParse(id);

    if (recipeId == null) {
      throw Exception('Invalid recipe ID: $id');
    }

    final recipe = recipes.firstWhere(
      (r) => r.id == recipeId,
      orElse: () => throw Exception('Recipe not found with ID: $id'),
    );

    return recipe;
  }

  /// Fetches a list of recipe steps for a recipe
  Future<List<RecipeStep>> getRecipeSteps(String recipeId) async {
    if (useMockData) {
      print('Using mock data for recipe steps with recipe id: $recipeId');
      return _getMockRecipeSteps(recipeId);
    }

    try {
      // First, get the recipe to find the step links
      final recipe = await getRecipe(recipeId);

      if (recipe.stepLinks == null || recipe.stepLinks!.isEmpty) {
        return [];
      }

      // Fetch each step by ID
      final steps = <RecipeStep>[];
      bool hasError = false;

      for (final link in recipe.stepLinks!) {
        try {
          final stepId = link.step.id.toString();
          final uri = Uri.parse('$baseUrl/recipe_step/$stepId');
          final response = await _httpClient.get(uri);

          if (response.statusCode == 200) {
            steps.add(RecipeStep.fromJson(json.decode(response.body)));
          } else {
            print('Error loading recipe step: ${response.statusCode}');
            hasError = true;
            break;
          }
        } catch (e) {
          print('Exception during API request for step: $e');
          hasError = true;
          break;
        }
      }

      if (hasError || steps.isEmpty) {
        print('Errors occurred while fetching recipe steps, falling back to mock data');
        return _getMockRecipeSteps(recipeId);
      }

      // Sort steps by their order in the recipe
      steps.sort((a, b) {
        final aLink = recipe.stepLinks!.firstWhere((link) => link.step.id == a.id);
        final bLink = recipe.stepLinks!.firstWhere((link) => link.step.id == b.id);
        return aLink.number.compareTo(bLink.number);
      });

      return steps;
    } catch (e) {
      print('Exception during API request: $e, falling back to mock data');
      return _getMockRecipeSteps(recipeId);
    }
  }

  /// Returns mock recipe steps for a recipe
  List<RecipeStep> _getMockRecipeSteps(String recipeId) {
    final recipe = _getMockRecipe(recipeId);

    if (recipe.stepLinks == null || recipe.stepLinks!.isEmpty) {
      return [];
    }

    // Create mock recipe steps
    final mockSteps = {
      1: RecipeStep(
        id: 1,
        name: 'Boil water in a large pot',
        duration: 5,
      ),
      2: RecipeStep(
        id: 2,
        name: 'Cook pasta according to package instructions',
        duration: 10,
      ),
      3: RecipeStep(
        id: 3,
        name: 'Season chicken with salt and pepper',
        duration: 2,
      ),
      4: RecipeStep(
        id: 4,
        name: 'Cook chicken in a pan until golden brown',
        duration: 15,
      ),
    };

    // Get steps for this recipe
    final steps = <RecipeStep>[];
    for (final link in recipe.stepLinks!) {
      final step = mockSteps[link.step.id];
      if (step != null) {
        steps.add(step);
      }
    }

    // Sort steps by their order in the recipe
    steps.sort((a, b) {
      final aLink = recipe.stepLinks!.firstWhere((link) => link.step.id == a.id);
      final bLink = recipe.stepLinks!.firstWhere((link) => link.step.id == b.id);
      return aLink.number.compareTo(bLink.number);
    });

    return steps;
  }

  /// Fetches a list of ingredients for a recipe
  Future<List<Ingredient>> getRecipeIngredients(String recipeId) async {
    if (useMockData) {
      print('Using mock data for recipe ingredients with recipe id: $recipeId');
      return _getMockRecipeIngredients(recipeId);
    }

    try {
      // First, get the recipe to find the ingredient links
      final recipe = await getRecipe(recipeId);

      if (recipe.ingredients == null || recipe.ingredients!.isEmpty) {
        return [];
      }

      // Fetch each ingredient by ID
      final ingredients = <Ingredient>[];
      bool hasError = false;

      for (final recipeIngredient in recipe.ingredients!) {
        try {
          final ingredientId = recipeIngredient.ingredient.id.toString();
          final uri = Uri.parse('$baseUrl/ingredient/$ingredientId');
          final response = await _httpClient.get(uri);

          if (response.statusCode == 200) {
            ingredients.add(Ingredient.fromJson(json.decode(response.body)));
          } else {
            print('Error loading ingredient: ${response.statusCode}');
            hasError = true;
            break;
          }
        } catch (e) {
          print('Exception during API request for ingredient: $e');
          hasError = true;
          break;
        }
      }

      if (hasError || ingredients.isEmpty) {
        print('Errors occurred while fetching recipe ingredients, falling back to mock data');
        return _getMockRecipeIngredients(recipeId);
      }

      return ingredients;
    } catch (e) {
      print('Exception during API request: $e, falling back to mock data');
      return _getMockRecipeIngredients(recipeId);
    }
  }

  /// Returns mock recipe ingredients for a recipe
  List<Ingredient> _getMockRecipeIngredients(String recipeId) {
    final recipe = _getMockRecipe(recipeId);

    if (recipe.ingredients == null || recipe.ingredients!.isEmpty) {
      return [];
    }

    // Create mock measure units
    final mockMeasureUnits = {
      1: MeasureUnitRef(id: 1), // grams
      2: MeasureUnitRef(id: 2), // pieces
      3: MeasureUnitRef(id: 3), // tablespoons
    };

    // Create mock ingredients
    final mockIngredients = {
      1: Ingredient(
        id: 1,
        name: 'Pasta',
        caloriesForUnit: 350.0,
        measureUnit: mockMeasureUnits[1]!,
      ),
      2: Ingredient(
        id: 2,
        name: 'Eggs',
        caloriesForUnit: 70.0,
        measureUnit: mockMeasureUnits[2]!,
      ),
      3: Ingredient(
        id: 3,
        name: 'Bacon',
        caloriesForUnit: 120.0,
        measureUnit: mockMeasureUnits[1]!,
      ),
      4: Ingredient(
        id: 4,
        name: 'Cream',
        caloriesForUnit: 200.0,
        measureUnit: mockMeasureUnits[1]!,
      ),
      5: Ingredient(
        id: 5,
        name: 'Parmesan Cheese',
        caloriesForUnit: 110.0,
        measureUnit: mockMeasureUnits[3]!,
      ),
      // Add ingredient with ID 666
      666: Ingredient(
        id: 666,
        name: 'Special Ingredient 666',
        caloriesForUnit: 666.0,
        measureUnit: mockMeasureUnits[1]!,
      ),
    };

    // Get ingredients for this recipe
    final ingredients = <Ingredient>[];
    for (final recipeIngredient in recipe.ingredients!) {
      final ingredient = mockIngredients[recipeIngredient.ingredient.id];
      if (ingredient != null) {
        ingredients.add(ingredient);
      }
    }

    return ingredients;
  }

  /// Creates a new recipe
  Future<Recipe> createRecipe(Recipe recipe) async {
    if (useMockData) {
      print('Using mock data for creating recipe');
      // In a real implementation, we would add the recipe to our mock data
      // For now, just return the recipe with a mock ID
      return Recipe(
        id: 999, // Mock ID
        name: recipe.name,
        duration: recipe.duration,
        photo: recipe.photo,
        ingredients: recipe.ingredients,
        stepLinks: recipe.stepLinks,
        favorites: recipe.favorites,
        comments: recipe.comments,
      );
    }

    try {
      final uri = Uri.parse('$baseUrl$_recipeEndpoint');
      final response = await _httpClient.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(recipe.toJson()),
      );

      if (response.statusCode == 200) {
        return Recipe.fromJson(json.decode(response.body));
      } else {
        print('Error creating recipe: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception('Failed to create recipe: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API request: $e');
      throw Exception('Failed to create recipe: $e');
    }
  }

  /// Creates a new recipe step
  Future<RecipeStep> createRecipeStep(RecipeStep step) async {
    if (useMockData) {
      print('Using mock data for creating recipe step');
      // Return the step with a mock ID
      return RecipeStep(
        id: 999, // Mock ID
        name: step.name,
        duration: step.duration,
        stepLinks: step.stepLinks,
      );
    }

    try {
      final uri = Uri.parse('$baseUrl$_recipeStepEndpoint');
      final response = await _httpClient.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(step.toJson()),
      );

      if (response.statusCode == 200) {
        return RecipeStep.fromJson(json.decode(response.body));
      } else {
        print('Error creating recipe step: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception('Failed to create recipe step: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API request: $e');
      throw Exception('Failed to create recipe step: $e');
    }
  }

  /// Creates a new recipe step link
  Future<rsl.RecipeStepLink> createRecipeStepLink(rsl.RecipeStepLink link) async {
    if (useMockData) {
      print('Using mock data for creating recipe step link');
      // Return the link with a mock ID
      return rsl.RecipeStepLink(
        id: 999, // Mock ID
        number: link.number,
        recipe: link.recipe,
        step: link.step,
      );
    }

    try {
      final uri = Uri.parse('$baseUrl$_recipeStepLinkEndpoint');
      final response = await _httpClient.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(link.toJson()),
      );

      if (response.statusCode == 200) {
        return rsl.RecipeStepLink.fromJson(json.decode(response.body));
      } else {
        print('Error creating recipe step link: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception('Failed to create recipe step link: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API request: $e');
      throw Exception('Failed to create recipe step link: $e');
    }
  }

  /// Creates a new ingredient
  Future<Ingredient> createIngredient(Ingredient ingredient) async {
    if (useMockData) {
      print('Using mock data for creating ingredient');
      // Return the ingredient with a mock ID
      return Ingredient(
        id: 999, // Mock ID
        name: ingredient.name,
        caloriesForUnit: ingredient.caloriesForUnit,
        measureUnit: ingredient.measureUnit,
        recipeIngredients: ingredient.recipeIngredients,
        freezerItems: ingredient.freezerItems,
      );
    }

    try {
      final uri = Uri.parse('$baseUrl$_ingredientEndpoint');
      final response = await _httpClient.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(ingredient.toJson()),
      );

      if (response.statusCode == 200) {
        return Ingredient.fromJson(json.decode(response.body));
      } else {
        print('Error creating ingredient: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception('Failed to create ingredient: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API request: $e');
      throw Exception('Failed to create ingredient: $e');
    }
  }

  /// Creates a new recipe ingredient
  Future<ri.RecipeIngredient> createRecipeIngredient(ri.RecipeIngredient recipeIngredient) async {
    if (useMockData) {
      print('Using mock data for creating recipe ingredient');
      // Return the recipe ingredient with a mock ID
      return ri.RecipeIngredient(
        id: 999, // Mock ID
        count: recipeIngredient.count,
        ingredient: recipeIngredient.ingredient,
        recipe: recipeIngredient.recipe,
      );
    }

    try {
      final uri = Uri.parse('$baseUrl$_recipeIngredientEndpoint');
      final response = await _httpClient.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(recipeIngredient.toJson()),
      );

      if (response.statusCode == 200) {
        return ri.RecipeIngredient.fromJson(json.decode(response.body));
      } else {
        print('Error creating recipe ingredient: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception('Failed to create recipe ingredient: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API request: $e');
      throw Exception('Failed to create recipe ingredient: $e');
    }
  }

  /// Creates a new measure unit
  Future<MeasureUnit> createMeasureUnit(MeasureUnit measureUnit) async {
    if (useMockData) {
      print('Using mock data for creating measure unit');
      // Return the measure unit with a mock ID
      return MeasureUnit(
        id: 999, // Mock ID
        one: measureUnit.one,
        few: measureUnit.few,
        many: measureUnit.many,
        ingredients: measureUnit.ingredients,
      );
    }

    try {
      final uri = Uri.parse('$baseUrl$_measureUnitEndpoint');
      final response = await _httpClient.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(measureUnit.toJson()),
      );

      if (response.statusCode == 200) {
        return MeasureUnit.fromJson(json.decode(response.body));
      } else {
        print('Error creating measure unit: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception('Failed to create measure unit: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API request: $e');
      throw Exception('Failed to create measure unit: $e');
    }
  }
}
