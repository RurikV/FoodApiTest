import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lib/models/recipe.dart';
import 'lib/models/recipe_step.dart';
import 'lib/models/ingredient.dart';
import 'lib/api_client.dart';

void main() async {
  // Create an API client to use the real Food API
  // The client will attempt to use the real API first, but will fall back to mock data
  // if the API is unavailable or returns an error
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

    // Display each recipe with its ingredients and steps
    for (final recipe in recipes) {
      print('Recipe: ${recipe.name}');
      print('Duration: ${recipe.duration} minutes');
      print('Photo: ${recipe.photo}');

      // Fetch and display ingredients
      print('\nIngredients:');
      try {
        final ingredients = await apiClient.getRecipeIngredients(recipe.id.toString());
        if (ingredients.isEmpty) {
          print('  No ingredients found for this recipe.');
        } else {
          for (final ingredient in ingredients) {
            // Find the corresponding recipe ingredient to get the count
            final recipeIngredient = recipe.ingredients?.firstWhere(
              (ri) => ri.ingredient.id == ingredient.id,
              orElse: () => throw Exception('Recipe ingredient not found'),
            );

            final count = recipeIngredient?.count ?? 0;
            print('  - ${ingredient.name}: $count ${ingredient.measureUnit.id}');
          }
        }
      } catch (e) {
        print('  Error fetching ingredients: $e');
      }

      // Fetch and display steps
      print('\nSteps:');
      try {
        final steps = await apiClient.getRecipeSteps(recipe.id.toString());
        if (steps.isEmpty) {
          print('  No steps found for this recipe.');
        } else {
          for (int i = 0; i < steps.length; i++) {
            final step = steps[i];
            print('  ${i + 1}. ${step.name} (${step.duration} minutes)');
          }
        }
      } catch (e) {
        print('  Error fetching steps: $e');
      }

      print('----------------------------');
    }
  } catch (e) {
    print('Error: $e');
  }
}
