// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_recipe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeIngredientAdapter extends TypeAdapter<RecipeIngredient> {
  @override
  final int typeId = 1;

  @override
  RecipeIngredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeIngredient(
      ingredientName: fields[0] as String?,
      quantity: fields[1] as double?,
      unit: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeIngredient obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.ingredientName)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.unit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeIngredientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecipeInstructionsAdapter extends TypeAdapter<RecipeInstructions> {
  @override
  final int typeId = 2;

  @override
  RecipeInstructions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeInstructions(
      instruction: fields[0] as String?,
      time: fields[1] as int?,
      unit: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeInstructions obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.instruction)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.unit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeInstructionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CloudRecipeAdapter extends TypeAdapter<CloudRecipe> {
  @override
  final int typeId = 0;

  @override
  CloudRecipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CloudRecipe(
      recipeId: fields[0] as String,
      cookingTime: fields[1] as String?,
      createDate: fields[2] as DateTime,
      imageSrc: fields[4] as String?,
      tags: (fields[5] as Map).cast<String, dynamic>(),
      recipeDescription: fields[6] as String?,
      recipeIngredients: (fields[7] as List).cast<RecipeIngredient>(),
      recipeInstructions: (fields[8] as List).cast<RecipeInstructions>(),
      recipeName: fields[10] as String,
      recipeServings: fields[11] as int?,
      updateDate: fields[12] as DateTime,
      calories: fields[3] as int?,
      nutritionalInfo: (fields[9] as List).cast<String>(),
      cuisinePath: (fields[13] as List?)?.cast<String>(),
      imageUrl: fields[14] as String?,
      identifier: fields[15] as String?,
      prepTime: fields[16] as String?,
      rating: fields[17] as String?,
      totalTime: fields[18] as String?,
      recipeSearchKeywords: (fields[19] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CloudRecipe obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.recipeId)
      ..writeByte(1)
      ..write(obj.cookingTime)
      ..writeByte(2)
      ..write(obj.createDate)
      ..writeByte(3)
      ..write(obj.calories)
      ..writeByte(4)
      ..write(obj.imageSrc)
      ..writeByte(5)
      ..write(obj.tags)
      ..writeByte(6)
      ..write(obj.recipeDescription)
      ..writeByte(7)
      ..write(obj.recipeIngredients)
      ..writeByte(8)
      ..write(obj.recipeInstructions)
      ..writeByte(9)
      ..write(obj.nutritionalInfo)
      ..writeByte(10)
      ..write(obj.recipeName)
      ..writeByte(11)
      ..write(obj.recipeServings)
      ..writeByte(12)
      ..write(obj.updateDate)
      ..writeByte(13)
      ..write(obj.cuisinePath)
      ..writeByte(14)
      ..write(obj.imageUrl)
      ..writeByte(15)
      ..write(obj.identifier)
      ..writeByte(16)
      ..write(obj.prepTime)
      ..writeByte(17)
      ..write(obj.rating)
      ..writeByte(18)
      ..write(obj.totalTime)
      ..writeByte(19)
      ..write(obj.recipeSearchKeywords);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CloudRecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
