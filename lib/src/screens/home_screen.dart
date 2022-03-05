import 'package:cookbook/connection/server_controller.dart';
import 'package:cookbook/src/components/my_drawer.dart';
import 'package:cookbook/src/components/recipe_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/recipe.dart';

class HomeScreen extends StatefulWidget {
  final ServerController serverController;
  const HomeScreen(this.serverController, {Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recetas"),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: widget.serverController.getRecipeList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final list = snapshot.data;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                Recipe recipe = list[index];
                return RecipeWidget(
                  recipe: recipe,
                  serverController: widget.serverController,
                  onChange: () {
                    setState(() {});
                  },
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed("/add_recipe");
        },
      ),
      drawer: MyDrawer(serverController: widget.serverController),
    );
  }
}
