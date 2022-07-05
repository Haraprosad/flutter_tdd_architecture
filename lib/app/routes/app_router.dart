import 'package:flutter/material.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/presentation/pages/home_page.dart';

part 'app_routes.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.MAIN:
        return MaterialPageRoute(
            builder: (_) => const MyHomePage(title: "My Home Page"));
      default:
        return MaterialPageRoute(
            builder: (_) => const MyHomePage(title: "My Home Page"));
    }
  }

  //For disposing any bloc or cubit
  void dispose() {
    //dispose the counter or bloc
  }
}
