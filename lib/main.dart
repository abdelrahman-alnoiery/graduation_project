import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:graduation_project/config/routes_manager/route_generator.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/core/di/app_providers.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/local_db/hive_constants.dart';
import 'features/cart/data/models/cart_item_model.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Hive.initFlutter();
  Hive.registerAdapter(CartItemModelAdapter());
  await Hive.openBox<CartItemModel>(HiveConstants.cartBox);
  await Hive.openBox(HiveConstants.favoritesBox);
  await Hive.openBox(HiveConstants.userBox);
  await SharedPref.init();

  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppProviders.getProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CarGo',
        initialRoute: Routes.splashRoute,
        onGenerateRoute: RouteGenerator.getRoute,
      ),
    );
  }
}
