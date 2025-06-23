import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lib/models/recipe.dart';
import 'lib/models/recipe_step.dart';
import 'lib/models/ingredient.dart';
import 'lib/api_client.dart';
import 'lib/models/recipe_ingredient.dart' as ri;

// Function to fetch recipe ingredients directly from the recipe_ingredient endpoint
Future<List<Map<String, dynamic>>> getRecipeIngredientsFromApi(String baseUrl, int recipeId) async {
  final uri = Uri.parse('$baseUrl/recipe_ingredient');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final List<dynamic> allRecipeIngredients = json.decode(response.body);

    // Filter recipe ingredients for this recipe
    final recipeIngredients = allRecipeIngredients.where((ingredient) {
      return ingredient['recipe'] != null && 
             ingredient['recipe']['id'] == recipeId;
    }).toList();

    return recipeIngredients.cast<Map<String, dynamic>>();
  } else {
    print('Error fetching recipe ingredients: ${response.statusCode}');
    print('Error response body: ${response.body}');
    throw Exception('Failed to load recipe ingredients: ${response.statusCode}');
  }
}

// Function to fetch ingredient details from the ingredient endpoint
Future<Map<String, dynamic>> getIngredientDetailsFromApi(String baseUrl, int ingredientId) async {
  final uri = Uri.parse('$baseUrl/ingredient/$ingredientId');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return json.decode(response.body) as Map<String, dynamic>;
  } else {
    print('Error fetching ingredient details: ${response.statusCode}');
    print('Error response body: ${response.body}');
    throw Exception('Failed to load ingredient details: ${response.statusCode}');
  }
}

void main() async {
  // Create an API client to use the real Food API
  final apiClient = FoodApiClient(
    baseUrl: 'https://foodapi.dzolotov.pro',
    useMockData: false, // Try to use the real API first
  );

  try {
    print('Fetching recipes...');
    final recipes = await apiClient.getRecipes();

    if (recipes.isEmpty) {
      print('No recipes found.');
      return;
    }

    print('Found ${recipes.length} recipes:');
    print('----------------------------');

    // Create a map to store all unique ingredients
    // Using a map with ingredient ID as key to avoid duplicates
    final allIngredients = <int, Map<String, dynamic>>{};

    // Display each recipe with its ingredients
    for (final recipe in recipes) {
      print('Recipe: ${recipe.name} (ID: ${recipe.id})');
      print('Duration: ${recipe.duration} minutes');
      print('Photo: ${recipe.photo}');

      // Fetch and display ingredients using the recipe_ingredient endpoint
      print('\nIngredients:');
      try {
        final recipeIngredients = await getRecipeIngredientsFromApi(apiClient.baseUrl, recipe.id);

        if (recipeIngredients.isEmpty) {
          print('  No ingredients found for this recipe.');
        } else {
          print('  Found ${recipeIngredients.length} ingredients:');

          for (final recipeIngredient in recipeIngredients) {
            final ingredientId = recipeIngredient['ingredient']['id'] as int;
            final count = recipeIngredient['count'] as int;

            try {
              // Fetch ingredient details from the ingredient endpoint
              final ingredientDetails = await getIngredientDetailsFromApi(apiClient.baseUrl, ingredientId);

              // Add ingredient to the map of all ingredients
              allIngredients[ingredientId] = ingredientDetails;

              final ingredientName = ingredientDetails['name'] as String;
              final caloriesForUnit = ingredientDetails['caloriesForUnit'] as num;
              final measureUnitId = ingredientDetails['measureUnit']['id'] as int;

              print('  - $ingredientName: $count (Measure Unit ID: $measureUnitId, Calories: $caloriesForUnit per unit)');
            } catch (e) {
              print('  - Ingredient ID: $ingredientId, Count: $count (Error fetching details: $e)');
            }
          }
        }
      } catch (e) {
        print('  Error fetching ingredients: $e');
      }

      print('----------------------------');
    }

    // Display all unique ingredients from all recipes
    print('\nAll Ingredients from All Recipes:');
    print('----------------------------');

    if (allIngredients.isEmpty) {
      print('No ingredients found in any recipe.');
    } else {
      // Convert the map values to a list and sort by name for better readability
      final sortedIngredients = allIngredients.values.toList()
        ..sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));

      for (final ingredient in sortedIngredients) {
        final name = ingredient['name'] as String;
        final caloriesForUnit = ingredient['caloriesForUnit'] as num;
        final measureUnitId = ingredient['measureUnit']['id'] as int;

        print('- $name (${caloriesForUnit} calories per unit, Measure Unit ID: $measureUnitId)');
      }
    }

    print('----------------------------');
  } catch (e) {
    print('Error: $e');
  }
}
