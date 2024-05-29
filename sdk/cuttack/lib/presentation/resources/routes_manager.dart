import 'package:cuttack/presentation/resources/strings_manager.dart';
import 'package:cuttack/presentation/screen/otp/otpverification.dart';
import 'package:cuttack/presentation/screen/registration/registration.dart';
import 'package:flutter/material.dart';
import '../home/homeScreen.dart';
import '../screen/advertisementBooking/advertisementBooking.dart';
import '../screen/login/login.dart';
import '../screen/splash/splash.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String otpRoute = "/otpverfication";
  static const String advertisement = "/advertisement";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
}
class RouteGenerator
{
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
           return MaterialPageRoute(builder: (_) => SplashView());
        case Routes.loginRoute:
       // initLoginModule();
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.registerRoute:
        return MaterialPageRoute(builder: (_) => RegistrationScreen());
      case Routes.otpRoute:
      //  initRegisterModule();
        return MaterialPageRoute(builder: (_) => OtpPage());
      case Routes.mainRoute:
      //  initRegisterModule();
        return MaterialPageRoute(builder: (_) => HomePage());
      case Routes.advertisement:
      //  initFogotPasswordModule();
        return MaterialPageRoute(builder: (_) => Advertisement());
      // case Routes.mainRoute:
      //    initHomeModule();
      //   return MaterialPageRoute(builder: (_) => MainView());
      // case Routes.storeDetailsRoute:
      //   initStoreDetailsModule();
      //   return MaterialPageRoute(builder: (_) => StoreDetailsView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(AppStrings.noRouteFound),
              ),
              body: Center(child: Text(AppStrings.noRouteFound)),
            ));
  }
}
