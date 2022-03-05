import 'package:cookbook/connection/server_controller.dart';
import 'package:cookbook/src/addRecipe_screen.dart';
import 'package:cookbook/src/screens/details_screen.dart';
import 'package:cookbook/src/screens/home_screen.dart';
import 'package:cookbook/src/screens/login_screen.dart';
import 'package:cookbook/src/screens/myFavorites_screen.dart';
import 'package:cookbook/src/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/models.dart';
import 'package:flutter_modulo1_fake_backend/user.dart';

import 'myRecipes_screen.dart';

ServerController _serverController = ServerController();

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.cyan,
        appBarTheme: AppBarTheme(
            backgroundColor: Color(0xff4dd0e1), foregroundColor: Colors.white),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan[300]),
      ),
      home: LoginScreen(_serverController, context),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          switch (settings.name) {
            case "/":
              return LoginScreen(_serverController, context);

            case "/home":
              User loggedUser = settings.arguments;
              _serverController.loggedUser = loggedUser;
              return HomeScreen(_serverController);

            case "/register":
              User loggedUser = settings.arguments;
              return RegisterScreen(_serverController, context,
                  userToEdit: loggedUser);

            case "/favorites":
              return MyFavoritesScreen(_serverController);

            case "/myrecipes":
              return MyRecipesScreen(_serverController);

            case "/details":
              Recipe recipe = settings.arguments;
              return DetailsScreen(recipe, _serverController);

            case "/add_recipe":
              return AddRecipeScreen(
                _serverController,
              );

            case "/edit_recipe":
              Recipe recipe = settings.arguments;
              return AddRecipeScreen(
                _serverController,
                recipe: recipe,
              );

            default:
              return LoginScreen(_serverController, context);
          }
        });
      },
    );
  }
}
