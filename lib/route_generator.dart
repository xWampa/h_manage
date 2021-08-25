import 'package:flutter/material.dart';
import 'package:h_manage/pages/pages.dart';
import 'package:h_manage/pages/sixth_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => FirstPage());

      case '/second':
        // Validation of correct data type
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => SecondPage(
                    data: args,
                  ));
        }
        // If args is not of the correct type, return an error page.
        // While in development you can also throw an exception
        return _errorRoute();

      case '/third':
        return MaterialPageRoute(
            builder: (_) => ThirdPage(
                  title: "TITLE PAGE 3",
                ));

      case '/fourth':
        return MaterialPageRoute(
            builder: (_) => FourthPage(
                  title: "comemeloswebosCuarta",
                ));
      case '/fifth':
        return MaterialPageRoute(
            builder: (_) => FifthPage(
                  data: "comemeloswebosCuarta",
                ));
      case '/sixth':
          return MaterialPageRoute(
              builder: (_) => SixthPage(
                title: 'args',
              ));

      default:
        // If there is no such named route in the switch statement, eg /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
