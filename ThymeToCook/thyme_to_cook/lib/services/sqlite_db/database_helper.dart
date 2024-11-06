
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'recipes.db');
    return openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE recipes(
          recipeId TEXT PRIMARY KEY,
          recipeName TEXT,
          cookingTime TEXT,
          createDate TEXT,
          updateDate TEXT,
          calories INTEGER,
          imageSrc TEXT,
          recipeDescription TEXT,
          recipeServings INTEGER,
          cuisinePath TEXT,
          identifier TEXT,
          prepTime TEXT,
          rating TEXT,
          totalTime TEXT
          );
          ''');

      db.execute('''
        CREATE TABLE ingredients(
          ingredientName TEXT,
          quantity REAL,
          unit TEXT,
          isChecked INTEGER,
          recipeId TEXT,
          FOREIGN KEY(recipeId) REFERENCES recipes(recipeId)ON DELETE CASCADE
          );
          ''');
    });
  }
  Future<void>close() async{
    final db=await database;
    db.close();
  }
}
