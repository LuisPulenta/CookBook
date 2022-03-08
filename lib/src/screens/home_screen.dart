import 'package:cookbook/connection/server_controller.dart';
import 'package:cookbook/src/components/recipe_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/recipe.dart';
import 'package:flutter_modulo1_fake_backend/user.dart';

import '../components/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  final ServerController serverController;
  const HomeScreen(this.serverController, {Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//********************************************************************
//********************* Pantalla *************************************
//********************************************************************
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My CookBook"),
        backgroundColor: Color(0xff4dd0e1),
        centerTitle: true,
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
        backgroundColor: Color(0xff4dd0e1),
        onPressed: () {
          Navigator.of(context).pushNamed("/add_recipe");
        },
      ),
      drawer: MyDrawer(serverController: widget.serverController),
    );
  }
}
