import 'dart:io';

import 'package:agile_helper/common/config/config.dart';
import 'package:agile_helper/data/model/user/token_login.dart';
import 'package:agile_helper/module/authentication/authentication_bloc/authentication_event.dart';
import 'package:agile_helper/module/home/view/home_view.dart';
import 'package:agile_helper/module/planning_poker/bloc/planning_poker_bloc.dart';
import 'package:agile_helper/module/planning_poker/board_game/bloc/board_game_bloc.dart';
import 'package:agile_helper/module/retro/board_retro/bloc/board_retro_bloc.dart';
import 'package:agile_helper/module/retro/dashboard/bloc/dashboard_bloc.dart';
import 'package:agile_helper/module/retro/home/bloc/retro_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'data/repository/socket_repository.dart';
import 'data/repository/user/user_repository.dart';
import 'module/authentication/authentication_bloc/authentication_bloc.dart';
import 'module/authentication/authentication_bloc/authentication_state.dart';
import 'module/authentication/simple_bloc_observer.dart';
import 'module/login/bloc/login_bloc.dart';
import 'module/login/view/login_view.dart';
import 'module/planning_poker/create_game/bloc/create_game_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  TokenLogin tokenLogin;
  try {
    var stringTokenLogin =
        await const FlutterSecureStorage().read(key: "tokenLogin");
    tokenLogin = TokenLogin.deserialize(stringTokenLogin);
  } catch (error) {
    tokenLogin = null;
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  BlocOverrides.runZoned(
    () {
      runApp(
        BlocProvider(
          create: (context) => AuthenticationBloc()
            ..add(AuthenticationTokenExpired(tokenLogin: tokenLogin)),
          child: const MyApp(),
        ),
      );
    },
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  IO.Socket socket;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoginBloc(userRepository: UserRepository()),
        ),
        BlocProvider(
          create: (_) => CreateGameBloc(
              socketRepository:
                  SocketRepository(urlSocket: GetHost.urlApiSocket())),
        ),
        BlocProvider(
          create: (_) => PlanningPokerBloc(),
        ),
        BlocProvider(
          create: (_) => BoardGameBloc(
              socketRepository:
                  SocketRepository(urlSocket: GetHost.urlApiSocket())),
        ),
        BlocProvider(
          create: (_) => DashBoardBloc(),
        ),
        BlocProvider(
          create: (_) => BoardRetroBloc(
            socketRepository:
                SocketRepository(urlSocket: GetHost.urlApiSocketRetro()),
          ),
        ),
        BlocProvider(
          create: (_) => RetroHomeBloc(),
        ),
      ],
      child: ScreenUtilInit(
          designSize:
              const Size(414, 896), // todo: Get real size screen from device
          builder: (BuildContext context, child) => GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    onGenerateRoute: ConfigRoutes.generateRoute,
                    useInheritedMediaQuery: true,
                    title: 'Baby Care',
                    theme: ThemeData(
                      scaffoldBackgroundColor: AppColors.whiteBackground,
                      brightness: Brightness.light,
                      primaryColor: AppColors.primary,
                      textTheme: GoogleFonts.montserratTextTheme(
                        TextTheme(
                          caption: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22.sp,
                            color: AppColors.whiteBackground,
                          ),
                          headline1: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            color: AppColors.text,
                          ),
                          headline2: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: AppColors.text,
                          ),
                          bodyText1: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: AppColors.text,
                          ),
                          bodyText2: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: AppColors.text,
                          ),
                          button: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 22.sp,
                            color: AppColors.whiteBackground,
                          ),
                        ),
                      ),
                    ),
                    builder: (context, widget) {
                      return MediaQuery(
                        data:
                            MediaQuery.of(context).copyWith(textScaleFactor: 1),
                        child: widget,
                      );
                    },
                    home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) {
                        if (state.isTokenExpire) {
                          return const LoginView();
                        } else {
                          return const HomeView();
                        }
                      },
                    )),
              )),
    );
  }
}

//Accept HTTPS://Host:Port without a trusted certificate
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
