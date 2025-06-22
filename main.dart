import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lib/models/recipe.dart';
import 'lib/models/recipe_step.dart';
import 'lib/models/ingredient.dart';
import 'lib/api_client.dart';
import 'lib/models/recipe_ingredient.dart' as ri;

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

    // Find recipe with ID 2 (Домашний рататуй)
    Recipe? targetRecipe;
    for (final recipe in recipes) {
      if (recipe.id == 2) {
        targetRecipe = recipe;
        break;
      }
    }

    if (targetRecipe != null) {
      print('\nAdding ingredient with ID 666 to recipe: ${targetRecipe.name} (ID: ${targetRecipe.id})');

      try {
        // First, check if the ingredient with ID 666 exists
        print('Checking if ingredient with ID 666 exists...');
        final ingredientUri = Uri.parse('${apiClient.baseUrl}/ingredient/666');
        final ingredientResponse = await http.get(ingredientUri);

        if (ingredientResponse.statusCode != 200) {
          print('Ingredient with ID 666 does not exist. Creating it...');

          // Create the ingredient
          final createIngredientUri = Uri.parse('${apiClient.baseUrl}/ingredient');
          final createIngredientBody = {
            'id': 666,
            'name': 'Special Ingredient 666',
            'caloriesForUnit': 666.0,
            'measureUnit': {'id': 1} // Assuming measure unit with ID 1 exists
          };

          print('Sending request to ${createIngredientUri.toString()}');
          print('Request body: ${json.encode(createIngredientBody)}');

          final createIngredientResponse = await http.post(
            createIngredientUri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(createIngredientBody),
          );

          if (createIngredientResponse.statusCode != 200) {
            print('Error creating ingredient: ${createIngredientResponse.statusCode}');
            print('Error response body: ${createIngredientResponse.body}');
            throw Exception('Failed to create ingredient: ${createIngredientResponse.statusCode}');
          }

          print('Successfully created ingredient 666');
        } else {
          print('Ingredient with ID 666 exists');
        }

        // Now create the recipe ingredient
        final recipeIngredientUri = Uri.parse('${apiClient.baseUrl}/recipe_ingredient');
        final recipeIngredientBody = {
          'count': 1,
          'ingredient': {'id': 666},
          'recipe': {'id': targetRecipe.id}
        };

        print('Sending request to ${recipeIngredientUri.toString()}');
        print('Request body: ${json.encode(recipeIngredientBody)}');

        final recipeIngredientResponse = await http.post(
          recipeIngredientUri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(recipeIngredientBody),
        );

        if (recipeIngredientResponse.statusCode == 200) {
          final responseJson = json.decode(recipeIngredientResponse.body);
          print('Successfully added ingredient 666 to recipe. Response: ${recipeIngredientResponse.body}');

          // Fetch the recipe again to see if the ingredient is now associated with it
          print('\nFetching recipe again to verify ingredient was added...');
          final recipeUri = Uri.parse('${apiClient.baseUrl}/recipe/${targetRecipe.id}');
          final recipeResponse = await http.get(recipeUri);

          if (recipeResponse.statusCode == 200) {
            final recipeJson = json.decode(recipeResponse.body);
            final recipeIngredients = recipeJson['recipeIngredients'] as List<dynamic>?;

            if (recipeIngredients != null && recipeIngredients.isNotEmpty) {
              print('Recipe now has ${recipeIngredients.length} ingredients:');
              for (final ingredient in recipeIngredients) {
                final ingredientId = ingredient['ingredient']['id'];
                final count = ingredient['count'];
                print('- Ingredient ID: $ingredientId, Count: $count');
              }
            } else {
              print('Recipe still has no ingredients associated with it in the recipe object.');
              print('This might be because the API does not immediately update the recipe\'s ingredients list.');

              // Try to directly fetch the recipe ingredients
              print('\nTrying to directly fetch recipe ingredients...');
              final recipeIngredientsUri = Uri.parse('${apiClient.baseUrl}/recipe_ingredient');
              final recipeIngredientsResponse = await http.get(recipeIngredientsUri);

              if (recipeIngredientsResponse.statusCode == 200) {
                final recipeIngredientsJson = json.decode(recipeIngredientsResponse.body) as List<dynamic>;

                // Filter recipe ingredients for this recipe
                final filteredIngredients = recipeIngredientsJson.where((ingredient) {
                  return ingredient['recipe'] != null && 
                         ingredient['recipe']['id'] == targetRecipe?.id;
                }).toList();

                if (filteredIngredients.isNotEmpty) {
                  print('Found ${filteredIngredients.length} ingredients for recipe ${targetRecipe?.id}:');
                  for (final ingredient in filteredIngredients) {
                    final ingredientId = ingredient['ingredient']['id'];
                    final count = ingredient['count'];
                    print('- Ingredient ID: $ingredientId, Count: $count');
                  }
                } else {
                  print('No ingredients found for recipe ${targetRecipe.id} in the recipe_ingredient endpoint.');
                }
              } else {
                print('Error fetching recipe ingredients: ${recipeIngredientsResponse.statusCode}');
                print('Error response body: ${recipeIngredientsResponse.body}');
              }
            }
          } else {
            print('Error fetching recipe: ${recipeResponse.statusCode}');
            print('Error response body: ${recipeResponse.body}');
          }
        } else {
          print('Error creating recipe ingredient: ${recipeIngredientResponse.statusCode}');
          print('Error response body: ${recipeIngredientResponse.body}');
          throw Exception('Failed to create recipe ingredient: ${recipeIngredientResponse.statusCode}');
        }
      } catch (e) {
        print('Error adding ingredient 666 to recipe: $e');
      }
    } else {
      print('\nRecipe with ID 2 (Домашний рататуй) not found.');
    }

    // Create a map to store all unique ingredients
    // Using a map with ingredient ID as key to avoid duplicates
    final allIngredients = <int, Ingredient>{};

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
            // Add ingredient to the map of all ingredients
            allIngredients[ingredient.id] = ingredient;

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

    // Display all unique ingredients from all recipes
    print('\nAll Ingredients from All Recipes:');
    print('----------------------------');

    if (allIngredients.isEmpty) {
      print('No ingredients found in any recipe.');
    } else {
      // Convert the map values to a list and sort by name for better readability
      final sortedIngredients = allIngredients.values.toList()
        ..sort((a, b) => a.name.compareTo(b.name));

      for (final ingredient in sortedIngredients) {
        print('- ${ingredient.name} (${ingredient.caloriesForUnit} calories per unit, Measure Unit ID: ${ingredient.measureUnit.id})');
      }
    }

    print('----------------------------');
  } catch (e) {
    print('Error: $e');
  }
}
