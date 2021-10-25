import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/shared/components/constants.dart';
import 'package:shop_application/shared/network/local/cache_helper.dart';
import 'package:shop_application/shared/network/remote/dio_helper.dart';
import 'package:shop_application/shared/styles/colors.dart';
import 'bloc_observer.dart';
import 'layout/cubit/shop_cubit.dart';
import 'layout/cubit/shop_states.dart';
import 'layout/shop_layout.dart';
import 'modules/log_in_screen/LogIn_Screen.dart';
import 'modules/on_boarding/on_boarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //handling red Screen
  ErrorWidget.builder = (FlutterErrorDetails details) => Center(
        child: Text("Please, close app and open it again to refresh settings"),
      );

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print(token);

  if (onBoarding != null) {
    if (token != null)
      widget = ShopLayout();
    else
      widget = LoginScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;

  MyApp({
    this.isDark,
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => ShopCubit()
              ..getHomeData()
              ..getCategoriesModel()
              ..getFavorites()
              ..getUserData()
            /*..changeThemeMode(
              fromShared: isDark,
            ),*/
            ),
      ],
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: defaultColor,
              canvasColor: Colors.white,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                backwardsCompatibility: false,
                //made it false to control in status bar
                iconTheme: IconThemeData(color: Colors.black),
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 0.0,
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: defaultColor,
                unselectedItemColor: Colors.grey,
                elevation: 20,
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: defaultColor,
              ),
              textTheme: ThemeData.light().textTheme.copyWith(
                    bodyText1: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
            darkTheme: ThemeData(
              primarySwatch: defaultColor,
              canvasColor: Color.fromRGBO(14, 22, 33, 1.0),
              appBarTheme: AppBarTheme(
                backgroundColor: Color.fromRGBO(14, 22, 33, 1),
                backwardsCompatibility: false,
                //made it false to control in status bar
                iconTheme: IconThemeData(color: Colors.white),
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Color.fromRGBO(14, 22, 33, 1),
                  statusBarIconBrightness: Brightness.light,
                ),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 0.0,
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: defaultColor,
                unselectedItemColor: Colors.grey,
                elevation: 20,
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: defaultColor,
              ),
              textTheme: ThemeData.dark().textTheme.copyWith(
                    bodyText1: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
            title: 'Flutter Demo',
            themeMode: ThemeMode.light,
            //ShopCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
