class CloudRecipeExceptions implements Exception {
  const CloudRecipeExceptions();
}

class CouldNotCreateRecipeException extends CloudRecipeExceptions{}
class CouldNotGetAllRecipesException extends CloudRecipeExceptions{}
class CouldNotUpdateRecipeException extends CloudRecipeExceptions {}