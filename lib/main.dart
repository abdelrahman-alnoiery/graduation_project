import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/core/local_db/hive_helper.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
import 'package:graduation_project/core/utils/observer.dart';
// ── Auth ───────────────────────────────────────────
import 'package:graduation_project/features/auth/data/dataSources/local/local_data_source.dart';
import 'package:graduation_project/features/auth/data/dataSources/remote/auth_remote_ds_impl.dart';
import 'package:graduation_project/features/auth/data/repository/auth_repo_impl.dart';
import 'package:graduation_project/features/auth/domin/usecases/login_usecase.dart';
import 'package:graduation_project/features/auth/domin/usecases/signUp_usecase.dart';
import 'package:graduation_project/features/auth/presentation/bloc/auth_bloc.dart';
// ── Cart ───────────────────────────────────────────
import 'package:graduation_project/features/cart/data/dataSources/local/cart_local_data_source.dart';
import 'package:graduation_project/features/cart/data/dataSources/remote/cart_remote_data_source.dart';
import 'package:graduation_project/features/cart/data/repository/cart_repo_impl.dart';
import 'package:graduation_project/features/cart/domain/usecases/add_cart_item_usecase.dart';
import 'package:graduation_project/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:graduation_project/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:graduation_project/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:graduation_project/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
// ── Categories ─────────────────────────────────────
import 'package:graduation_project/features/categories/data/repository/categories_repo_impl.dart';
import 'package:graduation_project/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:graduation_project/features/categories/presentation/bloc/categories_event.dart';
// ── Favourite ──────────────────────────────────────
import 'package:graduation_project/features/favourite/data/repository/favourite_repo_impl.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_bloc.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_event.dart';
// ── Home ───────────────────────────────────────────
import 'package:graduation_project/features/home/data/repository/home_repo_impl.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_event.dart';
// ── Product Details ────────────────────────────────
import 'package:graduation_project/features/product_details/data/repository/product_details_repo_impl.dart';
import 'package:graduation_project/features/product_details/presentation/bloc/product_details_bloc.dart';
// ── Products Screen ────────────────────────────────
import 'package:graduation_project/features/products_screen/data/repository/products_repo_impl.dart';
import 'package:graduation_project/features/products_screen/presentation/bloc/products_bloc.dart';
// ── Profile ────────────────────────────────────────
import 'package:graduation_project/features/profile_tab/data/repository/profile_repo_impl.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_bloc.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_event.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// ── Chatbot ────────────────────────────────────────

import 'config/routes_manager/route_generator.dart';
import 'features/categories/data/dataSources/remote/categories_remote_data_source_impl.dart';
import 'features/categories/domain/usecases/get_categories_usecase.dart';
import 'features/chat_bot/data/dataSources/remote/chatbot_remote_data_source_impl.dart';
import 'features/chat_bot/data/repository/chatbot_repo_impl.dart';
import 'features/chat_bot/domain/usecases/send_image_usecase.dart';
import 'features/chat_bot/domain/usecases/send_message_usecase.dart';
import 'features/chat_bot/presentation/bloc/chatbot_bloc.dart';
import 'features/favourite/data/dataSources/remote/favourite_remote_data_source_impl.dart';
import 'features/favourite/domain/usecases/add_favourite_usecase.dart';
import 'features/favourite/domain/usecases/get_favourites_usecase.dart';
import 'features/favourite/domain/usecases/remove_favourite_usecase.dart';
import 'features/home/data/dataSources/remote/home_remote_data_source_impl.dart';
import 'features/home/domain/usecases/get_best_price_usecase.dart';
import 'features/home/domain/usecases/get_brands_usecase.dart';
import 'features/home/domain/usecases/get_trends_usecase.dart';
import 'features/home/domain/usecases/search_products_usecase.dart';
import 'features/product_details/data/dataSources/remote/product_details_remote_data_source_impl.dart';
import 'features/product_details/domain/usecases/get_product_details_usecase.dart';
import 'features/products_screen/data/dataSources/remote/products_remote_data_source_impl.dart';
import 'features/products_screen/domain/usecases/get_all_products_usecase.dart';
import 'features/products_screen/domain/usecases/get_products_by_category_usecase.dart';
import 'features/profile_tab/data/dataSources/remote/profile_remote_data_source_impl.dart';
import 'features/profile_tab/domain/usecases/get_profile_usecase.dart';
import 'features/profile_tab/domain/usecases/logout_usecase.dart';
import 'features/profile_tab/domain/usecases/update_profile_usecase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await SharedPref.init();
  await HiveHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Dependencies ───────────────────────────────
    final networkInfo = CheckInternetConnectionImpl(
      InternetConnectionChecker(),
    );

    // ── Repos ──────────────────────────────────────
    final authRepoImpl = AuthRepoImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(),
      localDataSource: AuthLocalDataSourceImpl(),
      networkInfo: networkInfo,
    );

    final cartRepoImpl = CartRepoImpl(
      remoteDataSource: CartRemoteDataSourceImpl(),
      localDataSource: CartLocalDataSourceImpl(),
      networkInfo: networkInfo,
    );

    final homeRepoImpl = HomeRepoImpl(
      remoteDataSource: HomeRemoteDataSourceImpl(),
      networkInfo: networkInfo,
    );

    final categoriesRepoImpl = CategoriesRepoImpl(
      remoteDataSource: CategoriesRemoteDataSourceImpl(),
      networkInfo: networkInfo,
    );

    final favouriteRepoImpl = FavouriteRepoImpl(
      remoteDataSource: FavouriteRemoteDataSourceImpl(),
      networkInfo: networkInfo,
    );

    final profileRepoImpl = ProfileRepoImpl(
      remoteDataSource: ProfileRemoteDataSourceImpl(),
      networkInfo: networkInfo,
    );

    final productsRepoImpl = ProductsRepoImpl(
      remoteDataSource: ProductsRemoteDataSourceImpl(),
      networkInfo: networkInfo,
    );

    final productDetailsRepoImpl = ProductDetailsRepoImpl(
      remoteDataSource: ProductDetailsRemoteDataSourceImpl(),
      networkInfo: networkInfo,
    );

    final chatbotRepoImpl = ChatbotRepoImpl(
      remoteDataSource: ChatbotRemoteDataSourceImpl(),
      networkInfo: networkInfo,
    );

    return MultiBlocProvider(
      providers: [
        // ── Auth Bloc ──────────────────────────────
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            loginUseCase: LoginUseCase(authRepoImpl),
            signUpUseCase: SignUpUseCase(authRepoImpl),
          ),
        ),

        // ── Cart Bloc ──────────────────────────────
        BlocProvider<CartBloc>(
          create: (_) => CartBloc(
            getCartItemsUseCase: GetCartItemsUseCase(cartRepoImpl),
            addCartItemUseCase: AddCartItemUseCase(cartRepoImpl),
            removeCartItemUseCase: RemoveCartItemUseCase(cartRepoImpl),
            updateCartItemUseCase: UpdateCartItemUseCase(cartRepoImpl),
            clearCartUseCase: ClearCartUseCase(cartRepoImpl),
          )..add(const GetCartItemsEvent()),
        ),

        // ── Home Bloc ──────────────────────────────
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(
            getBrandsUseCase: GetBrandsUseCase(homeRepoImpl),
            getTrendsUseCase: GetTrendsUseCase(homeRepoImpl),
            getBestPriceUseCase: GetBestPriceUseCase(homeRepoImpl),
            searchProductsUseCase: SearchProductsUseCase(homeRepoImpl),
          )..add(const GetHomeDataEvent()),
        ),

        // ── Categories Bloc ────────────────────────
        BlocProvider<CategoriesBloc>(
          create: (_) => CategoriesBloc(
            getCategoriesUseCase: GetCategoriesUseCase(categoriesRepoImpl),
          )..add(const GetCategoriesEvent()),
        ),

        // ── Favourite Bloc ─────────────────────────
        BlocProvider<FavouriteBloc>(
          create: (_) => FavouriteBloc(
            getFavouritesUseCase: GetFavouritesUseCase(favouriteRepoImpl),
            addFavouriteUseCase: AddFavouriteUseCase(favouriteRepoImpl),
            removeFavouriteUseCase: RemoveFavouriteUseCase(favouriteRepoImpl),
          )..add(const GetFavouritesEvent()),
        ),

        // ── Profile Bloc ───────────────────────────
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            getProfileUseCase: GetProfileUseCase(profileRepoImpl),
            updateProfileUseCase: UpdateProfileUseCase(profileRepoImpl),
            logoutUseCase: LogoutUseCase(profileRepoImpl),
          )..add(const GetProfileEvent()),
        ),

        // ── Products Bloc ──────────────────────────
        BlocProvider<ProductsBloc>(
          create: (_) => ProductsBloc(
            getProductsByCategoryUseCase: GetProductsByCategoryUseCase(
              productsRepoImpl,
            ),
            getAllProductsUseCase: GetAllProductsUseCase(productsRepoImpl),
          ),
        ),

        // ── Product Details Bloc ───────────────────
        BlocProvider<ProductDetailsBloc>(
          create: (context) => ProductDetailsBloc(
            getProductDetailsUseCase: GetProductDetailsUseCase(
              productDetailsRepoImpl,
            ),
            favouriteBloc: context.read<FavouriteBloc>(),
          ),
        ),

        // ── Chatbot Bloc ───────────────────────────
        BlocProvider<ChatbotBloc>(
          create: (_) => ChatbotBloc(
            sendMessageUseCase: SendMessageUseCase(chatbotRepoImpl),
            sendImageUseCase: SendImageUseCase(chatbotRepoImpl),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CarGo',
        initialRoute: Routes.homePageLayoutRoute,
        onGenerateRoute: RouteGenerator.getRoute,
      ),
    );
  }
}
