import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/config/routes_manager/route_generator.dart';
// Config
import 'package:graduation_project/config/routes_manager/routes.dart';
// Core
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
// Auth
import 'package:graduation_project/features/auth/data/dataSources/local/auth_local_data_source_impl.dart';
import 'package:graduation_project/features/auth/data/dataSources/remote/auth_remote_ds_impl.dart';
import 'package:graduation_project/features/auth/data/repository/auth_repo_impl.dart';
import 'package:graduation_project/features/auth/domin/usecases/login_usecase.dart';
import 'package:graduation_project/features/auth/domin/usecases/signUp_usecase.dart';
import 'package:graduation_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_project/features/cart/data/dataSources/remote/cart_remote_data_source.dart';
import 'package:graduation_project/features/cart/data/repository/cart_repo_impl.dart';
import 'package:graduation_project/features/cart/domain/usecases/add_cart_item_usecase.dart';
import 'package:graduation_project/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:graduation_project/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:graduation_project/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:graduation_project/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
// Categories
import 'package:graduation_project/features/categories/data/dataSources/remote/categories_remote_data_source_impl.dart';
import 'package:graduation_project/features/categories/data/repository/categories_repo_impl.dart';
import 'package:graduation_project/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:graduation_project/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:graduation_project/features/categories/presentation/bloc/categories_event.dart';
// Chatbot
import 'package:graduation_project/features/chat_bot/data/dataSources/remote/chatbot_remote_data_source_impl.dart';
import 'package:graduation_project/features/chat_bot/data/repository/chatbot_repo_impl.dart';
import 'package:graduation_project/features/chat_bot/domain/usecases/send_image_usecase.dart';
import 'package:graduation_project/features/chat_bot/domain/usecases/send_message_usecase.dart';
import 'package:graduation_project/features/chat_bot/presentation/bloc/chatbot_bloc.dart';
// Favourite
import 'package:graduation_project/features/favourite/data/dataSources/remote/favourite_remote_data_source_impl.dart';
import 'package:graduation_project/features/favourite/data/repository/favourite_repo_impl.dart';
import 'package:graduation_project/features/favourite/domain/usecases/add_favourite_usecase.dart';
import 'package:graduation_project/features/favourite/domain/usecases/get_favourites_usecase.dart';
import 'package:graduation_project/features/favourite/domain/usecases/remove_favourite_usecase.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_bloc.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_event.dart';
// Home
import 'package:graduation_project/features/home/data/dataSources/remote/home_remote_data_source_impl.dart';
import 'package:graduation_project/features/home/data/repository/home_repo_impl.dart';
import 'package:graduation_project/features/home/domain/usecases/get_best_price_usecase.dart';
import 'package:graduation_project/features/home/domain/usecases/get_brands_usecase.dart';
import 'package:graduation_project/features/home/domain/usecases/get_trends_usecase.dart';
import 'package:graduation_project/features/home/domain/usecases/search_products_usecase.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_bloc.dart';
// Product Details
import 'package:graduation_project/features/product_details/data/dataSources/remote/product_details_remote_data_source_impl.dart';
import 'package:graduation_project/features/product_details/data/repository/product_details_repo_impl.dart';
import 'package:graduation_project/features/product_details/domain/usecases/get_product_details_usecase.dart';
import 'package:graduation_project/features/product_details/presentation/bloc/product_details_bloc.dart';
// Products Screen
import 'package:graduation_project/features/products_screen/data/dataSources/remote/products_remote_data_source_impl.dart';
import 'package:graduation_project/features/products_screen/data/repository/products_repo_impl.dart';
import 'package:graduation_project/features/products_screen/domain/usecases/get_all_products_usecase.dart';
import 'package:graduation_project/features/products_screen/domain/usecases/get_products_by_category_usecase.dart';
import 'package:graduation_project/features/products_screen/presentation/bloc/products_bloc.dart';
// Profile
import 'package:graduation_project/features/profile_tab/data/dataSources/remote/profile_remote_data_source_impl.dart';
import 'package:graduation_project/features/profile_tab/data/repository/profile_repo_impl.dart';
import 'package:graduation_project/features/profile_tab/domain/usecases/get_profile_usecase.dart';
import 'package:graduation_project/features/profile_tab/domain/usecases/logout_usecase.dart';
import 'package:graduation_project/features/profile_tab/domain/usecases/update_profile_usecase.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_bloc.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_event.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/local_db/hive_constants.dart';
import 'features/cart/data/dataSources/local/cart_local_data_source_impl.dart';
import 'features/cart/data/models/cart_item_model.dart';
import 'features/home/presentation/bloc/home_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(CartItemModelAdapter());
  await Hive.openBox<CartItemModel>(HiveConstants.cartBox);
  await Hive.openBox(HiveConstants.favoritesBox); // ✅ مهم
  await Hive.openBox(HiveConstants.userBox);

  await SharedPref.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _getBlocProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CarGo',
        initialRoute: Routes.homePageLayoutRoute,
        onGenerateRoute: RouteGenerator.getRoute,
      ),
    );
  }

  List<BlocProvider> _getBlocProviders() {
    // Core dependencies
    final networkInfo = CheckInternetConnectionImpl(
      InternetConnectionChecker(),
    );

    // Initialize repos
    final authRepo = _initAuthRepo(networkInfo);
    final cartRepo = _initCartRepo(networkInfo);
    final homeRepo = _initHomeRepo(networkInfo);
    final categoriesRepo = _initCategoriesRepo(networkInfo);
    final favouriteRepo = _initFavouriteRepo(networkInfo);
    final profileRepo = _initProfileRepo(networkInfo);
    final productsRepo = _initProductsRepo(networkInfo);
    final productDetailsRepo = _initProductDetailsRepo(networkInfo);
    final chatbotRepo = _initChatbotRepo(networkInfo);

    return [
      // Auth Bloc
      BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(
          loginUseCase: LoginUseCase(authRepo),
          signUpUseCase: SignUpUseCase(authRepo),
        ),
      ),

      // Cart Bloc
      BlocProvider<CartBloc>(
        create: (_) => CartBloc(
          getCartItemsUseCase: GetCartItemsUseCase(cartRepo),
          addCartItemUseCase: AddCartItemUseCase(cartRepo),
          removeCartItemUseCase: RemoveCartItemUseCase(cartRepo),
          updateCartItemUseCase: UpdateCartItemUseCase(cartRepo),
          clearCartUseCase: ClearCartUseCase(cartRepo),
        )..add(const GetCartItemsEvent()),
      ),

      // Home Bloc
      BlocProvider<HomeBloc>(
        create: (_) => HomeBloc(
          getBrandsUseCase: GetBrandsUseCase(homeRepo),
          getTrendsUseCase: GetTrendsUseCase(homeRepo),
          getBestPriceUseCase: GetBestPriceUseCase(homeRepo),
          searchProductsUseCase: SearchProductsUseCase(homeRepo),
        )..add(const GetHomeDataEvent()),
      ),

      // Categories Bloc
      BlocProvider<CategoriesBloc>(
        create: (_) => CategoriesBloc(
          getCategoriesUseCase: GetCategoriesUseCase(categoriesRepo),
        )..add(const GetCategoriesEvent()),
      ),

      // Favourite Bloc
      BlocProvider<FavouriteBloc>(
        create: (_) => FavouriteBloc(
          getFavouritesUseCase: GetFavouritesUseCase(favouriteRepo),
          addFavouriteUseCase: AddFavouriteUseCase(favouriteRepo),
          removeFavouriteUseCase: RemoveFavouriteUseCase(favouriteRepo),
        )..add(const GetFavouritesEvent()),
      ),

      // Profile Bloc
      BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(
          getProfileUseCase: GetProfileUseCase(profileRepo),
          updateProfileUseCase: UpdateProfileUseCase(profileRepo),
          logoutUseCase: LogoutUseCase(profileRepo),
        )..add(const GetProfileEvent()),
      ),

      // Products Bloc
      BlocProvider(
        create: (context) => ProductsBloc(
          getAllProductsUseCase: GetAllProductsUseCase(productsRepo),
          getProductsByCategoryUseCase: GetProductsByCategoryUseCase(
            productsRepo,
          ),
        ),
      ),

      // Product Details Bloc
      BlocProvider<ProductDetailsBloc>(
        create: (context) => ProductDetailsBloc(
          getProductDetailsUseCase: GetProductDetailsUseCase(
            productDetailsRepo,
          ),
          favouriteBloc: context.read<FavouriteBloc>(),
        ),
      ),

      // Chatbot Bloc
      BlocProvider<ChatbotBloc>(
        create: (_) => ChatbotBloc(
          sendMessageUseCase: SendMessageUseCase(chatbotRepo),
          sendImageUseCase: SendImageUseCase(chatbotRepo),
        ),
      ),
    ];
  }

  // Repository initialization methods
  AuthRepoImpl _initAuthRepo(CheckInternetConnectionImpl networkInfo) {
    return AuthRepoImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(),
      localDataSource: AuthLocalDataSourceImpl(),
      networkInfo: networkInfo,
    );
  }

  CartRepoImpl _initCartRepo(CheckInternetConnectionImpl networkInfo) {
    return CartRepoImpl(
      remoteDataSource: CartRemoteDataSourceImpl(),
      localDataSource: CartLocalDataSourceImpl(),
      networkInfo: networkInfo,
    );
  }

  HomeRepoImpl _initHomeRepo(CheckInternetConnectionImpl networkInfo) {
    return HomeRepoImpl(
      remoteDataSource: HomeRemoteDataSourceImpl(),
      networkInfo: networkInfo,
    );
  }

  CategoriesRepoImpl _initCategoriesRepo(
    CheckInternetConnectionImpl networkInfo,
  ) {
    return CategoriesRepoImpl(
      remoteDataSource: CategoriesRemoteDataSourceImpl(),
      networkInfo: networkInfo,
    );
  }

  FavouriteRepoImpl _initFavouriteRepo(
    CheckInternetConnectionImpl networkInfo,
  ) {
    return FavouriteRepoImpl(
      remoteDataSource: FavouriteRemoteDataSourceImpl(),
      networkInfo: networkInfo,
    );
  }

  ProfileRepoImpl _initProfileRepo(CheckInternetConnectionImpl networkInfo) {
    return ProfileRepoImpl(
      remoteDataSource: ProfileRemoteDataSourceImpl(),
      networkInfo: networkInfo,
    );
  }

  ProductsRepoImpl _initProductsRepo(CheckInternetConnectionImpl networkInfo) {
    return ProductsRepoImpl(
      remoteDataSource: ProductsRemoteDataSourceImpl(),
      networkInfo: networkInfo,
    );
  }

  ProductDetailsRepoImpl _initProductDetailsRepo(
    CheckInternetConnectionImpl networkInfo,
  ) {
    return ProductDetailsRepoImpl(
      remoteDataSource: ProductDetailsRemoteDataSourceImpl(),
      networkInfo: networkInfo,
    );
  }

  ChatbotRepoImpl _initChatbotRepo(CheckInternetConnectionImpl networkInfo) {
    return ChatbotRepoImpl(
      remoteDataSource: ChatbotRemoteDataSourceImpl(),
      networkInfo: networkInfo,
    );
  }
}
