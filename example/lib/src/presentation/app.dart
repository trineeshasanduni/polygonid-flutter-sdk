import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polygonid_flutter_sdk/registers/domain/usecases/register_usecase.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard_bloc/dashboard_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/download_bloc/download_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/file_bloc/file_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/login/bloc/login_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/profile/bloc/profile_bloc.dart';
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
  late final RegisterBloc _registerBloc;
  late final LoginBloc _loginBloc;
  late final FileBloc _fileBloc;
  late final DownloadBloc _downloadBloc;
  late final ProfileBloc _profileBloc;
  late final DashboardBloc _dashboardBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => _loginBloc,
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => _registerBloc,
        ),
        BlocProvider<FileBloc>(
          create: (context) => _fileBloc,
        ),
        BlocProvider<DownloadBloc>(
          create: (context) => _downloadBloc,
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => _profileBloc,
        ),
        BlocProvider<DashboardBloc>(
          create: (context) => _dashboardBloc,
        ),
      ],
      child: MaterialApp(
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
