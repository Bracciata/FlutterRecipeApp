import 'package:flutter/material.dart';
import 'recipe.dart';
import 'uniWidgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;
import 'dart:convert';

class RecipePage extends StatefulWidget {
  RecipePage({Key key, this.recipeID, this.title}) : super(key: key);

  final String recipeID;
  final String title;
  @override
  RecipePageState createState() => RecipePageState();
}

class IngredientListView extends StatelessWidget {
  final List<dynamic> ingredients;

  IngredientListView({Key key, this.ingredients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: ingredients.length,
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (context, position) {
          return Column(
            children: <Widget>[
              Divider(height: 1.0),
              ListTile(
                title: Text('${ingredients[position]}'),
              ),
            ],
          );
        });
  }
}

class RecipePageState extends State<RecipePage> {
  Future<Recipe> getRecipe() async {
    String url =
        'https://www.food2fork.com/api/get?key=c170274c40994703421ea66c402d9d05&rId=' +
            widget.recipeID;
    final response = await http.get('$url');
    //Below can be compressed to one line easily
    var decoded = json.decode(response.body);
    var decStuffNeeded = decoded['recipe'];
    Recipe theRecipe = Recipe.fromJsonIndividual(decStuffNeeded);
    return theRecipe;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: FutureBuilder<Recipe>(
                future: getRecipe(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return ErrorWidgetUni();
                    }
                    return Column(children: [
                      Text(snapshot.data.title),
                      new Container(
                          width: 190.0,
                          height: 190.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      NetworkImage(snapshot.data.imageUrl)))),
                      Container(
                          child: new Expanded(
                              child: IngredientListView(
                        ingredients: snapshot.data.ingredients,
                      )))
                    ]);
                  } else
                    return CircularProgressIndicator();
                })));
  }
}
