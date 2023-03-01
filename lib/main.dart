import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nfungible/models/cubit/graphql_cubit.dart';
import 'package:nfungible/models/cubit/openai_cubit.dart';
import 'package:nfungible/screens/create_nft_screen.dart';
import 'package:nfungible/screens/create_set_screen.dart';
import 'package:sizer/sizer.dart';
import 'screens/home_screen.dart';
import 'theme_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(
    Sizer(
      builder: (context, _, __) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => OpenAICubit(),
          ),
        ],
        child: const App(),
      ),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeHelper.lightTheme,
      darkTheme: ThemeHelper.darkTheme,
      themeMode: ThemeHelper.themeMode,
      routes: {
        "/": (context) => BlocProvider(
              create: (context) => GraphqlCubit(),
              child: const HomeScreen(),
            ),
        CreateNFTScreen.routeName: (context) => BlocProvider(
              create: (context) => GraphqlCubit(),
              child: const CreateNFTScreen(),
            ),
        CreateSetScreen.routeName: (context) => BlocProvider(
              create: (context) => GraphqlCubit(),
              child: const CreateSetScreen(),
            ),
      },
      initialRoute: "/",
    );
  }
}
