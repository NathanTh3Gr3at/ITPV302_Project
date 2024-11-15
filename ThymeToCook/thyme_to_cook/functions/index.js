const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const algoliasearch = require('algoliasearch');
const ALGOLIA_APP_ID = "1J68RMGS9G";
const ALGOLIA_ADMIN_KEY = "d2c8cfd4795410ace7a9d54ef9007fe9";
const ALGOLIA_INDEX_NAME = "recipes";
const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
const index = client.initIndex(ALGOLIA_INDEX_NAME);
// When a new recipe is created in Firestore
// saves this recipe data to the Algolia index.
exports.onRecipeCreate = functions.firestore
    .document("recipes/{recipeId}")
    .onCreate((snapshot, context) => {
      const data = snapshot.data();
      data.objectID = context.param.recipeId;
      return index.saveObject(data);
    });
// When an existing recipe is updated in Firestore
// updates the recipe data in Algolia to match Firestore.
exports.onRecipeUpdate = functions.firestore
    .document("recipes/{recipeId}")
    .onUpdate((change, context) => {
      const newData = change.after.data();
      newData.objectID = context.params.recipeId;
      return index.saveObject(newData);
    });
// When a recipe is deleted in Firestore
// deletes the corresponding entry in Algolia
exports.onRecipeDelete = functions.firestore
    .document("recipes/{recipeId}")
    .onDelete((snap, context) => {
      const objectID = context.params.recipeId;
      return index.deleteObject(objectID);
    });
