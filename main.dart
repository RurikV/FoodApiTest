import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lib/models/recipe.dart';
import 'lib/models/recipe_step.dart';
import 'lib/models/ingredient.dart';
import 'lib/api_client.dart';
import 'lib/models/recipe_ingredient.dart' as ri;
import 'lib/models/recipe_step_link.dart' as rsl;

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

// Function to fetch measure unit details from the measure_unit endpoint
Future<Map<String, dynamic>> getMeasureUnitDetailsFromApi(String baseUrl, int measureUnitId) async {
  final uri = Uri.parse('$baseUrl/measure_unit/$measureUnitId');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return json.decode(response.body) as Map<String, dynamic>;
  } else {
    print('Error fetching measure unit details: ${response.statusCode}');
    print('Error response body: ${response.body}');
    throw Exception('Failed to load measure unit details: ${response.statusCode}');
  }
}

// Function to fetch recipe step links directly from the recipe_step_link endpoint
Future<List<Map<String, dynamic>>> getRecipeStepLinksFromApi(String baseUrl, int recipeId) async {
  final uri = Uri.parse('$baseUrl/recipe_step_link');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final List<dynamic> allRecipeStepLinks = json.decode(response.body);

    // Filter recipe step links for this recipe
    final recipeStepLinks = allRecipeStepLinks.where((stepLink) {
      return stepLink['recipe'] != null && 
             stepLink['recipe']['id'] == recipeId;
    }).toList();

    // Sort step links by number to ensure correct order
    recipeStepLinks.sort((a, b) => (a['number'] as int).compareTo(b['number'] as int));

    return recipeStepLinks.cast<Map<String, dynamic>>();
  } else {
    print('Error fetching recipe step links: ${response.statusCode}');
    print('Error response body: ${response.body}');
    throw Exception('Failed to load recipe step links: ${response.statusCode}');
  }
}

// Function to fetch recipe step details from the recipe_step endpoint
Future<Map<String, dynamic>> getRecipeStepDetailsFromApi(String baseUrl, int stepId) async {
  final uri = Uri.parse('$baseUrl/recipe_step/$stepId');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return json.decode(response.body) as Map<String, dynamic>;
  } else {
    print('Error fetching recipe step details: ${response.statusCode}');
    print('Error response body: ${response.body}');
    throw Exception('Failed to load recipe step details: ${response.statusCode}');
  }
}

// Function to check if an ingredient exists
Future<bool> checkIngredientExists(String baseUrl, int ingredientId) async {
  final uri = Uri.parse('$baseUrl/ingredient/$ingredientId');
  try {
    final response = await http.get(uri);
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}

// Function to create an ingredient
Future<Map<String, dynamic>> createIngredient(String baseUrl, int id, String name, double caloriesForUnit, int measureUnitId) async {
  final uri = Uri.parse('$baseUrl/ingredient');
  final body = {
    'id': id,
    'name': name,
    'caloriesForUnit': caloriesForUnit,
    'measureUnit': {'id': measureUnitId}
  };

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body) as Map<String, dynamic>;
  } else {
    print('Error creating ingredient: ${response.statusCode}');
    print('Error response body: ${response.body}');
    throw Exception('Failed to create ingredient: ${response.statusCode}');
  }
}

// Function to create a recipe ingredient
Future<Map<String, dynamic>> createRecipeIngredient(String baseUrl, int recipeId, int ingredientId, int count) async {
  final uri = Uri.parse('$baseUrl/recipe_ingredient');
  final body = {
    'count': count,
    'ingredient': {'id': ingredientId},
    'recipe': {'id': recipeId}
  };

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body) as Map<String, dynamic>;
  } else {
    print('Error creating recipe ingredient: ${response.statusCode}');
    print('Error response body: ${response.body}');
    throw Exception('Failed to create recipe ingredient: ${response.statusCode}');
  }
}

// Function to create a recipe step
Future<Map<String, dynamic>> createRecipeStep(String baseUrl, String name, int duration) async {
  final uri = Uri.parse('$baseUrl/recipe_step');
  final body = {
    'name': name,
    'duration': duration
  };

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body) as Map<String, dynamic>;
  } else {
    print('Error creating recipe step: ${response.statusCode}');
    print('Error response body: ${response.body}');
    throw Exception('Failed to create recipe step: ${response.statusCode}');
  }
}

// Function to create a recipe step link
Future<Map<String, dynamic>> createRecipeStepLink(String baseUrl, int recipeId, int stepId, int number) async {
  final uri = Uri.parse('$baseUrl/recipe_step_link');
  final body = {
    'number': number,
    'recipe': {'id': recipeId},
    'step': {'id': stepId}
  };

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body) as Map<String, dynamic>;
  } else {
    print('Error creating recipe step link: ${response.statusCode}');
    print('Error response body: ${response.body}');
    throw Exception('Failed to create recipe step link: ${response.statusCode}');
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

    // Look for recipe ID 10
    Recipe? recipe10;
    for (final recipe in recipes) {
      if (recipe.id == 10) {
        recipe10 = recipe;
        break;
      }
    }

    // If recipe ID 10 is not found, try to fetch it directly
    if (recipe10 == null) {
      try {
        print('Recipe ID 10 not found in the list. Trying to fetch it directly...');
        recipe10 = await apiClient.getRecipe('10');
        print('Successfully fetched recipe ID 10: ${recipe10.name}');
      } catch (e) {
        print('Error fetching recipe ID 10: $e');
        print('Recipe ID 10 not found. Cannot proceed with adding ingredients and steps.');
      }
    }

    // If recipe ID 10 is found, add ingredients and steps
    if (recipe10 != null) {
      print('\nFound recipe ID 10: ${recipe10.name}');
      print('Adding ingredients and steps to recipe ID 10...');

      // Define ingredients to add with names and measure units
      final ingredientsToAdd = [
        {
          'id': 666, // Using ingredient ID 666 which we know exists
          'count': 2,
          'name': 'Special Ingredient for Recipe 10',
          'measureUnitId': 1 // Assuming measure unit ID 1 exists (штука)
        },
        {
          'id': 667, // New ingredient ID
          'count': 3,
          'name': 'Another Ingredient for Recipe 10',
          'measureUnitId': 2 // Assuming measure unit ID 2 exists (грамм)
        },
        {
          'id': 668, // New ingredient ID
          'count': 100,
          'name': 'Third Ingredient for Recipe 10',
          'measureUnitId': 3 // Assuming measure unit ID 3 exists (миллилитр)
        },
      ];

      // Check if recipe already has ingredients
      print('\nChecking if recipe ID 10 already has ingredients...');
      final existingIngredients = await getRecipeIngredientsFromApi(apiClient.baseUrl, recipe10.id);

      if (existingIngredients.isNotEmpty) {
        print('Recipe ID 10 already has ${existingIngredients.length} ingredients. Skipping adding new ingredients.');
      } else {
        // Add ingredients to recipe
        print('\nAdding ingredients to recipe ID 10...');
        for (final ingredient in ingredientsToAdd) {
          try {
            final ingredientId = ingredient['id'] as int;
            final ingredientName = ingredient['name'] as String;
            final measureUnitId = ingredient['measureUnitId'] as int;

            // Check if ingredient exists
            final exists = await checkIngredientExists(apiClient.baseUrl, ingredientId);

            if (!exists) {
              // Create ingredient if it doesn't exist
              print('Ingredient ID $ingredientId does not exist. Creating it...');
              try {
                await createIngredient(
                  apiClient.baseUrl,
                  ingredientId,
                  ingredientName,
                  666.0, // Default calories for unit
                  measureUnitId
                );
                print('Successfully created ingredient ID $ingredientId: $ingredientName');
              } catch (e) {
                print('Error creating ingredient ID $ingredientId: $e');
                continue; // Skip adding this ingredient to the recipe
              }
            } else {
              print('Ingredient ID $ingredientId already exists');
            }

            // Add ingredient to recipe
            final result = await createRecipeIngredient(
              apiClient.baseUrl,
              recipe10.id,
              ingredientId,
              ingredient['count'] as int
            );
            print('Successfully added ingredient ID $ingredientId to recipe ID 10');
          } catch (e) {
            print('Error adding ingredient ID ${ingredient['id']} to recipe ID 10: $e');
          }
        }
      }

      // Define steps to add
      final stepsToAdd = [
        {'name': 'Prepare ingredients', 'duration': 5},
        {'name': 'Cook the main dish', 'duration': 15},
        {'name': 'Serve and enjoy', 'duration': 2},
      ];

      // Check if recipe already has steps
      print('\nChecking if recipe ID 10 already has steps...');
      final existingSteps = await getRecipeStepLinksFromApi(apiClient.baseUrl, recipe10.id);

      if (existingSteps.isNotEmpty) {
        print('Recipe ID 10 already has ${existingSteps.length} steps. Skipping adding new steps.');
      } else {
        // Add steps to recipe
        print('\nAdding steps to recipe ID 10...');
        final createdSteps = <Map<String, dynamic>>[];
        for (final step in stepsToAdd) {
          try {
            final result = await createRecipeStep(
              apiClient.baseUrl,
              step['name'] as String,
              step['duration'] as int
            );
            createdSteps.add(result);
            print('Successfully created step: ${result['name']}');
          } catch (e) {
            print('Error creating step ${step['name']}: $e');
          }
        }

        // Link steps to recipe
        print('\nLinking steps to recipe ID 10...');
        for (int i = 0; i < createdSteps.length; i++) {
          try {
            final result = await createRecipeStepLink(
              apiClient.baseUrl,
              recipe10.id,
              createdSteps[i]['id'] as int,
              i + 1 // Step number (1-based)
            );
            print('Successfully linked step ${i + 1} to recipe ID 10');
          } catch (e) {
            print('Error linking step ${i + 1} to recipe ID 10: $e');
          }
        }
      }

      print('\nFinished processing ingredients and steps for recipe ID 10');
    }

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

              // Fetch measure unit details
              try {
                final measureUnitDetails = await getMeasureUnitDetailsFromApi(apiClient.baseUrl, measureUnitId);
                final measureUnitOne = measureUnitDetails['one'] as String;
                final measureUnitFew = measureUnitDetails['few'] as String;
                final measureUnitMany = measureUnitDetails['many'] as String;

                // Determine which form to use based on count
                String measureUnitForm;
                if (count == 1) {
                  measureUnitForm = measureUnitOne;
                } else if (count >= 2 && count <= 4) {
                  measureUnitForm = measureUnitFew;
                } else {
                  measureUnitForm = measureUnitMany;
                }

                print('  - $ingredientName: $count $measureUnitForm (Calories: $caloriesForUnit per unit)');
              } catch (e) {
                print('  - $ingredientName: $count (Measure Unit ID: $measureUnitId, Calories: $caloriesForUnit per unit, Error fetching measure unit details: $e)');
              }
            } catch (e) {
              print('  - Ingredient ID: $ingredientId, Count: $count (Error fetching details: $e)');
            }
          }
        }
      } catch (e) {
        print('  Error fetching ingredients: $e');
      }

      // Fetch and display steps using the recipe_step_link endpoint
      print('\nSteps:');
      try {
        final recipeStepLinks = await getRecipeStepLinksFromApi(apiClient.baseUrl, recipe.id);

        if (recipeStepLinks.isEmpty) {
          print('  No steps found for this recipe.');
        } else {
          print('  Found ${recipeStepLinks.length} steps:');

          for (int i = 0; i < recipeStepLinks.length; i++) {
            final recipeStepLink = recipeStepLinks[i];
            final stepId = recipeStepLink['step']['id'] as int;
            final stepNumber = recipeStepLink['number'] as int;

            try {
              // Fetch step details from the recipe_step endpoint
              final stepDetails = await getRecipeStepDetailsFromApi(apiClient.baseUrl, stepId);

              final stepName = stepDetails['name'] as String;
              final stepDuration = stepDetails['duration'] as int;

              print('  ${i + 1}. $stepName (${stepDuration} minutes)');
            } catch (e) {
              print('  ${i + 1}. Step ID: $stepId, Number: $stepNumber (Error fetching details: $e)');
            }
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
        ..sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));

      for (final ingredient in sortedIngredients) {
        final name = ingredient['name'] as String;
        final caloriesForUnit = ingredient['caloriesForUnit'] as num;
        final measureUnitId = ingredient['measureUnit']['id'] as int;

        try {
          // Fetch measure unit details
          final measureUnitDetails = await getMeasureUnitDetailsFromApi(apiClient.baseUrl, measureUnitId);
          final measureUnitOne = measureUnitDetails['one'] as String;
          final measureUnitFew = measureUnitDetails['few'] as String;
          final measureUnitMany = measureUnitDetails['many'] as String;

          print('- $name (${caloriesForUnit} calories per unit, Measure Units: one: $measureUnitOne, few: $measureUnitFew, many: $measureUnitMany)');
        } catch (e) {
          print('- $name (${caloriesForUnit} calories per unit, Measure Unit ID: $measureUnitId, Error fetching measure unit details: $e)');
        }
      }
    }

    print('----------------------------');
  } catch (e) {
    print('Error: $e');
  }
}
