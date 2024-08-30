import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polygonid_flutter_sdk/registers/domain/usecases/register_usecase.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/bloc/register_bloc.dart';
import 'package:polygonid_flutter_sdk_example/themes/theme_data.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_colors.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/qr_code_parser_utils.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late final RegisterBloc _registerBloc ;

  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
      providers: [
        // BlocProvider<HomeBloc>(
        //   create: (context) => HomeBloc(),
        // ),
        BlocProvider<RegisterBloc>(
          create: (context) => _registerBloc,
          ),
        
      ],child: MaterialApp(
      title: CustomStrings.appTitle,
      initialRoute: Routes.initialPath,
      routes: Routes.getRoutes(context),
      navigatorKey: navigatorKey,

      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      // theme: ThemeData(
      //   primarySwatch: CustomColors.primaryWhite,
      //   buttonTheme: const ButtonThemeData(
      //     buttonColor: CustomColors.primaryOrange,
      //     textTheme: ButtonTextTheme.accent,
      //   ),
      // ),
      ),
    );

  }
}
