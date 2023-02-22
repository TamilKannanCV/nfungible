import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';

class RouteHelper {
  static get routerConfig => GoRouter(
        initialLocation: HomeScreen.routeName,
        routes: [
          GoRoute(
            path: HomeScreen.routeName,
            builder: (context, state) => const HomeScreen(),
          ),
        ],
      );
}
