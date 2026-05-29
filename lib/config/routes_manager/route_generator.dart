import 'package:flutter/material.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';

import '../../features/Onboarding/Onboarding1.dart';
import '../../features/auth/presentation/ui/screens/sign_in_screen.dart';
import '../../features/auth/presentation/ui/screens/sign_up_screen.dart';
import '../../features/cart/presentation/ui/screens/cart_screen.dart';
import '../../features/categories/presentation/screens/categories_screen.dart';
import '../../features/chat_bot/presentation/screens/chatbot_screen.dart';
import '../../features/favourite/presentation/ui/screens/favourites_screen.dart';
import '../../features/home/domain/entity/product_entity.dart';
import '../../features/main_layout/main_layout.dart';
import '../../features/product_details/presentation/screens/product_details_screen.dart';
import '../../features/products_screen/presentation/screens/products_screen.dart';
import '../../features/profile_tab/presentation/screens/profile_screen.dart';
import '../../features/splashScreen/presentation/ui/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case Routes.onboarding1Route:
        return MaterialPageRoute(builder: (_) => Onboarding());

      case Routes.signInRoute:
        return MaterialPageRoute(builder: (_) => SignInScreen());

      case Routes.signUpRoute:
        return MaterialPageRoute(builder: (_) => SignUpScreen());

      // case Routes.otpRoute:
      //   return MaterialPageRoute(builder: (_) => OtpScreen());
      //
      // case Routes.verifyRoute:
      //   return MaterialPageRoute(builder: (_) => VerifyScreen());

      case Routes.homePageLayoutRoute:
        return MaterialPageRoute(builder: (_) => const HomePageLayout());

      case Routes.categoriesRoute:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());

      case Routes.favoritesRoute:
        return MaterialPageRoute(builder: (_) => const FavouriteScreen());

      case Routes.profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case Routes.productsScreenRoute:
        return MaterialPageRoute(builder: (_) => const ProductsScreen());

      case Routes.productDetails:
        final product = settings.arguments as ProductEntity;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        );

      // case Routes.itemPreviewRoute:
      //   return MaterialPageRoute(builder: (_) => const ItemPreviewScreen());

      case Routes.cartRoute:
        return MaterialPageRoute(builder: (_) => const CartScreen());

      case Routes.chatbotRoute:
        return MaterialPageRoute(builder: (_) => const ChatbotScreen());
      //
      // case Routes.aiFixingRoute:
      //   return MaterialPageRoute(builder: (_) => const AiFixingScreen());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text("No Route Found")),
        body: Center(child: Text("No Route Found")),
      ),
    );
  }
}
