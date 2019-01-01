import 'package:flutter/material.dart';
import 'recipe.dart';
import 'uniWidgets.dart';

class RecipePage extends StatefulWidget {
  RecipePage({Key key, this.recipeID, this.title}) : super(key: key);

  final String recipeID;
  final String title;
  @override
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  Future<Recipe> getRecipe() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FutureBuilder<Recipe>(
                future: getRecipe(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return ErrorWidgetUni();
                    }
                    return new Text(snapshot.data.title);
                  } else
                    return CircularProgressIndicator();
                })
          ],
        ),
      ),
    );
  }
}
