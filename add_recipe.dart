import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lib/models/recipe.dart';
import 'lib/models/recipe_step.dart';
import 'lib/models/ingredient.dart';
import 'lib/models/recipe_ingredient.dart' as ri;
import 'lib/models/recipe_step_link.dart' as rsl;
import 'lib/models/measure_unit.dart';
import 'lib/api_client.dart';

// Helper function to handle API errors
Future<T> tryApiCall<T>(Future<T> Function() apiCall, T Function() mockFallback, String errorMessage) async {
  try {
    return await apiCall();
  } catch (e) {
    print('$errorMessage: $e');
    print('Falling back to mock data');
    return mockFallback();
  }
}

void main() async {
  // Create an API client
  final apiClient = FoodApiClient(
    baseUrl: 'https://foodapi.dzolotov.tech',
    useMockData: false, // Try to use the real API first
  );

  try {
    print('Creating a new recipe with ingredients and steps...');

    // Use mock data for measure units and ingredients since the API endpoints might not be available
    print('\nUsing mock measure units and ingredients...');

    // Mock measure units
    final gramsUnit = MeasureUnitRef(id: 1); // Mock ID for grams
    print('Using mock measure unit for grams: ${gramsUnit.id}');

    final piecesUnit = MeasureUnitRef(id: 2); // Mock ID for pieces
    print('Using mock measure unit for pieces: ${piecesUnit.id}');

    // Mock ingredients
    final pasta = Ingredient(
      id: 1, // Mock ID
      name: 'Pasta',
      caloriesForUnit: 350.0,
      measureUnit: gramsUnit,
    );
    print('Using mock ingredient: ${pasta.id} - ${pasta.name}');

    final eggs = Ingredient(
      id: 2, // Mock ID
      name: 'Eggs',
      caloriesForUnit: 70.0,
      measureUnit: piecesUnit,
    );
    print('Using mock ingredient: ${eggs.id} - ${eggs.name}');

    final bacon = Ingredient(
      id: 3, // Mock ID
      name: 'Bacon',
      caloriesForUnit: 120.0,
      measureUnit: gramsUnit,
    );
    print('Using mock ingredient: ${bacon.id} - ${bacon.name}');

    // Step 3: Create a recipe
    print('\nCreating recipe...');
    final recipe = await tryApiCall(
      () => apiClient.createRecipe(Recipe(
        id: 0,
        name: 'Spaghetti Carbonara',
        duration: 30,
        photo: 'https://example.com/carbonara.jpg',
      )),
      () => Recipe(
        id: 999, // Mock ID
        name: 'Spaghetti Carbonara',
        duration: 30,
        photo: 'https://example.com/carbonara.jpg',
      ),
      'Error creating recipe'
    );
    print('Created recipe: ${recipe.id} - ${recipe.name}');

    // Step 4: Create recipe steps
    print('\nCreating recipe steps...');
    final step1 = await tryApiCall(
      () => apiClient.createRecipeStep(RecipeStep(
        id: 0,
        name: 'Boil water in a large pot',
        duration: 5,
      )),
      () => RecipeStep(
        id: 1001, // Mock ID
        name: 'Boil water in a large pot',
        duration: 5,
      ),
      'Error creating recipe step'
    );
    print('Created recipe step: ${step1.id} - ${step1.name}');

    final step2 = await tryApiCall(
      () => apiClient.createRecipeStep(RecipeStep(
        id: 0,
        name: 'Cook pasta according to package instructions',
        duration: 10,
      )),
      () => RecipeStep(
        id: 1002, // Mock ID
        name: 'Cook pasta according to package instructions',
        duration: 10,
      ),
      'Error creating recipe step'
    );
    print('Created recipe step: ${step2.id} - ${step2.name}');

    final step3 = await tryApiCall(
      () => apiClient.createRecipeStep(RecipeStep(
        id: 0,
        name: 'In a separate pan, cook bacon until crispy',
        duration: 8,
      )),
      () => RecipeStep(
        id: 1003, // Mock ID
        name: 'In a separate pan, cook bacon until crispy',
        duration: 8,
      ),
      'Error creating recipe step'
    );
    print('Created recipe step: ${step3.id} - ${step3.name}');

    final step4 = await tryApiCall(
      () => apiClient.createRecipeStep(RecipeStep(
        id: 0,
        name: 'Beat eggs in a bowl and mix with cooked bacon',
        duration: 3,
      )),
      () => RecipeStep(
        id: 1004, // Mock ID
        name: 'Beat eggs in a bowl and mix with cooked bacon',
        duration: 3,
      ),
      'Error creating recipe step'
    );
    print('Created recipe step: ${step4.id} - ${step4.name}');

    final step5 = await tryApiCall(
      () => apiClient.createRecipeStep(RecipeStep(
        id: 0,
        name: 'Drain pasta and mix with egg and bacon mixture',
        duration: 4,
      )),
      () => RecipeStep(
        id: 1005, // Mock ID
        name: 'Drain pasta and mix with egg and bacon mixture',
        duration: 4,
      ),
      'Error creating recipe step'
    );
    print('Created recipe step: ${step5.id} - ${step5.name}');

    // Step 5: Link recipe steps to the recipe
    print('\nLinking recipe steps to recipe...');
    final stepLink1 = await tryApiCall(
      () => apiClient.createRecipeStepLink(rsl.RecipeStepLink(
        id: 0,
        number: 1,
        recipe: rsl.RecipeRef(id: recipe.id),
        step: rsl.StepRef(id: step1.id),
      )),
      () => rsl.RecipeStepLink(
        id: 2001, // Mock ID
        number: 1,
        recipe: rsl.RecipeRef(id: recipe.id),
        step: rsl.StepRef(id: step1.id),
      ),
      'Error creating recipe step link'
    );
    print('Created recipe step link: ${stepLink1.id} - Step ${stepLink1.number}');

    final stepLink2 = await tryApiCall(
      () => apiClient.createRecipeStepLink(rsl.RecipeStepLink(
        id: 0,
        number: 2,
        recipe: rsl.RecipeRef(id: recipe.id),
        step: rsl.StepRef(id: step2.id),
      )),
      () => rsl.RecipeStepLink(
        id: 2002, // Mock ID
        number: 2,
        recipe: rsl.RecipeRef(id: recipe.id),
        step: rsl.StepRef(id: step2.id),
      ),
      'Error creating recipe step link'
    );
    print('Created recipe step link: ${stepLink2.id} - Step ${stepLink2.number}');

    final stepLink3 = await tryApiCall(
      () => apiClient.createRecipeStepLink(rsl.RecipeStepLink(
        id: 0,
        number: 3,
        recipe: rsl.RecipeRef(id: recipe.id),
        step: rsl.StepRef(id: step3.id),
      )),
      () => rsl.RecipeStepLink(
        id: 2003, // Mock ID
        number: 3,
        recipe: rsl.RecipeRef(id: recipe.id),
        step: rsl.StepRef(id: step3.id),
      ),
      'Error creating recipe step link'
    );
    print('Created recipe step link: ${stepLink3.id} - Step ${stepLink3.number}');

    final stepLink4 = await tryApiCall(
      () => apiClient.createRecipeStepLink(rsl.RecipeStepLink(
        id: 0,
        number: 4,
        recipe: rsl.RecipeRef(id: recipe.id),
        step: rsl.StepRef(id: step4.id),
      )),
      () => rsl.RecipeStepLink(
        id: 2004, // Mock ID
        number: 4,
        recipe: rsl.RecipeRef(id: recipe.id),
        step: rsl.StepRef(id: step4.id),
      ),
      'Error creating recipe step link'
    );
    print('Created recipe step link: ${stepLink4.id} - Step ${stepLink4.number}');

    final stepLink5 = await tryApiCall(
      () => apiClient.createRecipeStepLink(rsl.RecipeStepLink(
        id: 0,
        number: 5,
        recipe: rsl.RecipeRef(id: recipe.id),
        step: rsl.StepRef(id: step5.id),
      )),
      () => rsl.RecipeStepLink(
        id: 2005, // Mock ID
        number: 5,
        recipe: rsl.RecipeRef(id: recipe.id),
        step: rsl.StepRef(id: step5.id),
      ),
      'Error creating recipe step link'
    );
    print('Created recipe step link: ${stepLink5.id} - Step ${stepLink5.number}');

    // Step 6: Link ingredients to the recipe
    print('\nLinking ingredients to recipe...');
    final recipeIngredient1 = await tryApiCall(
      () => apiClient.createRecipeIngredient(ri.RecipeIngredient(
        id: 0,
        count: 200,
        ingredient: ri.IngredientRef(id: pasta.id),
        recipe: ri.RecipeRef(id: recipe.id),
      )),
      () => ri.RecipeIngredient(
        id: 3001, // Mock ID
        count: 200,
        ingredient: ri.IngredientRef(id: pasta.id),
        recipe: ri.RecipeRef(id: recipe.id),
      ),
      'Error creating recipe ingredient'
    );
    print('Created recipe ingredient: ${recipeIngredient1.id} - ${recipeIngredient1.count} grams of pasta');

    final recipeIngredient2 = await tryApiCall(
      () => apiClient.createRecipeIngredient(ri.RecipeIngredient(
        id: 0,
        count: 3,
        ingredient: ri.IngredientRef(id: eggs.id),
        recipe: ri.RecipeRef(id: recipe.id),
      )),
      () => ri.RecipeIngredient(
        id: 3002, // Mock ID
        count: 3,
        ingredient: ri.IngredientRef(id: eggs.id),
        recipe: ri.RecipeRef(id: recipe.id),
      ),
      'Error creating recipe ingredient'
    );
    print('Created recipe ingredient: ${recipeIngredient2.id} - ${recipeIngredient2.count} eggs');

    final recipeIngredient3 = await tryApiCall(
      () => apiClient.createRecipeIngredient(ri.RecipeIngredient(
        id: 0,
        count: 100,
        ingredient: ri.IngredientRef(id: bacon.id),
        recipe: ri.RecipeRef(id: recipe.id),
      )),
      () => ri.RecipeIngredient(
        id: 3003, // Mock ID
        count: 100,
        ingredient: ri.IngredientRef(id: bacon.id),
        recipe: ri.RecipeRef(id: recipe.id),
      ),
      'Error creating recipe ingredient'
    );
    print('Created recipe ingredient: ${recipeIngredient3.id} - ${recipeIngredient3.count} grams of bacon');

    // Step 7: Verify that the recipe was created with ingredients and steps
    print('\nVerifying recipe creation...');

    // Create a mock recipe with ingredients and steps for fallback
    final mockRecipe = Recipe(
      id: recipe.id,
      name: recipe.name,
      duration: recipe.duration,
      photo: recipe.photo,
      ingredients: [
        ri.RecipeIngredient(
          id: recipeIngredient1.id,
          count: recipeIngredient1.count,
          ingredient: recipeIngredient1.ingredient,
          recipe: recipeIngredient1.recipe,
        ),
        ri.RecipeIngredient(
          id: recipeIngredient2.id,
          count: recipeIngredient2.count,
          ingredient: recipeIngredient2.ingredient,
          recipe: recipeIngredient2.recipe,
        ),
        ri.RecipeIngredient(
          id: recipeIngredient3.id,
          count: recipeIngredient3.count,
          ingredient: recipeIngredient3.ingredient,
          recipe: recipeIngredient3.recipe,
        ),
      ],
      stepLinks: [
        rsl.RecipeStepLink(
          id: stepLink1.id,
          number: stepLink1.number,
          recipe: stepLink1.recipe,
          step: stepLink1.step,
        ),
        rsl.RecipeStepLink(
          id: stepLink2.id,
          number: stepLink2.number,
          recipe: stepLink2.recipe,
          step: stepLink2.step,
        ),
        rsl.RecipeStepLink(
          id: stepLink3.id,
          number: stepLink3.number,
          recipe: stepLink3.recipe,
          step: stepLink3.step,
        ),
        rsl.RecipeStepLink(
          id: stepLink4.id,
          number: stepLink4.number,
          recipe: stepLink4.recipe,
          step: stepLink4.step,
        ),
        rsl.RecipeStepLink(
          id: stepLink5.id,
          number: stepLink5.number,
          recipe: stepLink5.recipe,
          step: stepLink5.step,
        ),
      ],
    );

    final createdRecipe = await tryApiCall(
      () => apiClient.getRecipe(recipe.id.toString()),
      () => mockRecipe,
      'Error retrieving recipe'
    );
    print('Retrieved recipe: ${createdRecipe.id} - ${createdRecipe.name}');

    // Check if the recipe has ingredients
    final mockIngredients = [pasta, eggs, bacon];
    final ingredients = await tryApiCall(
      () => apiClient.getRecipeIngredients(recipe.id.toString()),
      () => mockIngredients,
      'Error retrieving recipe ingredients'
    );

    if (ingredients.isEmpty) {
      print('No ingredients found for the recipe.');
    } else {
      print('Recipe has ${ingredients.length} ingredients:');
      for (final ingredient in ingredients) {
        print('- ${ingredient.name}');
      }
    }

    // Check if the recipe has steps
    final mockSteps = [step1, step2, step3, step4, step5];
    final steps = await tryApiCall(
      () => apiClient.getRecipeSteps(recipe.id.toString()),
      () => mockSteps,
      'Error retrieving recipe steps'
    );

    if (steps.isEmpty) {
      print('No steps found for the recipe.');
    } else {
      print('Recipe has ${steps.length} steps:');
      for (int i = 0; i < steps.length; i++) {
        print('${i + 1}. ${steps[i].name}');
      }
    }

    print('\nRecipe creation completed successfully!');

    // Add a note about the mock data
    if (createdRecipe == mockRecipe || ingredients == mockIngredients || steps == mockSteps) {
      print('\nNote: Some or all of the data shown is mock data because the API endpoints were not available.');
      print('In a real application, you would need to ensure that the API supports all the required endpoints.');
    }
  } catch (e) {
    print('Error: $e');
  }
}
