import 'package:flutter/material.dart';
import 'recipe.dart';
class RecipePage extends StatefulWidget {
  RecipePage({Key key, this.recipeID,this.title}) : super(key: key);

  final String recipeID;
  final String title;
  @override
  RecipePageState createState() => RecipePageState();
}
class RecipePageState extends State<RecipePage> {

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}