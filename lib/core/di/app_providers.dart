import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
import 'package:graduation_project/features/auth/data/dataSources/local/auth_local_data_source_impl.dart';
import 'package:graduation_project/features/auth/data/dataSources/remote/auth_remote_ds_impl.dart';
import 'package:graduation_project/features/auth/data/repository/auth_repo_impl.dart';
import 'package:graduation_project/features/auth/domin/usecases/login_usecase.dart';
import 'package:graduation_project/features/auth/domin/usecases/signUp_usecase.dart';
import 'package:graduation_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_project/features/cart/data/dataSources/local/cart_local_data_source_impl.dart';
import 'package:graduation_project/features/cart/data/dataSources/remote/cart_remote_data_source.dart';
import 'package:graduation_project/features/cart/data/repository/cart_repo_impl.dart';
import 'package:graduation_project/features/cart/domain/usecases/add_cart_item_usecase.dart';
import 'package:graduation_project/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:graduation_project/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:graduation_project/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:graduation_project/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:graduation_project/features/categories/data/dataSources/remote/categories_remote_data_source_impl.dart';
import 'package:graduation_project/features/categories/data/repository/categories_repo_impl.dart';
import 'package:graduation_project/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:graduation_project/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:graduation_project/features/categories/presentation/bloc/categories_event.dart';
import 'package:graduation_project/features/chat_bot/data/dataSources/remote/chatbot_remote_data_source_impl.dart';
import 'package:graduation_project/features/chat_bot/data/repository/chatbot_repo_impl.dart';
import 'package:graduation_project/features/chat_bot/domain/usecases/send_image_usecase.dart';
import 'package:graduation_project/features/chat_bot/domain/usecases/send_message_usecase.dart';
import 'package:graduation_project/features/chat_bot/presentation/bloc/chatbot_bloc.dart';
import 'package:graduation_project/features/favourite/data/dataSources/remote/favourite_remote_data_source_impl.dart';
import 'package:graduation_project/features/favourite/data/repository/favourite_repo_impl.dart';
import 'package:graduation_project/features/favourite/domain/usecases/add_favourite_usecase.dart';
import 'package:graduation_project/features/favourite/domain/usecases/get_favourites_usecase.dart';
import 'package:graduation_project/features/favourite/domain/usecases/remove_favourite_usecase.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_bloc.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_event.dart';
import 'package:graduation_project/features/home/data/dataSources/remote/home_remote_data_source_impl.dart';
import 'package:graduation_project/features/home/data/repository/home_repo_impl.dart';
import 'package:graduation_project/features/home/domain/usecases/get_best_price_usecase.dart';
import 'package:graduation_project/features/home/domain/usecases/get_brands_usecase.dart';
import 'package:graduation_project/features/home/domain/usecases/get_trends_usecase.dart';
import 'package:graduation_project/features/home/domain/usecases/search_products_usecase.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_event.dart';
import 'package:graduation_project/features/product_details/data/dataSources/remote/product_details_remote_data_source_impl.dart';
import 'package:graduation_project/features/product_details/data/repository/product_details_repo_impl.dart';
import 'package:graduation_project/features/product_details/domain/usecases/get_product_details_usecase.dart';
import 'package:graduation_project/features/product_details/presentation/bloc/product_details_bloc.dart';
import 'package:graduation_project/features/products_screen/data/dataSources/remote/products_remote_data_source_impl.dart';
import 'package:graduation_project/features/products_screen/data/repository/products_repo_impl.dart';
import 'package:graduation_project/features/products_screen/domain/usecases/get_all_products_usecase.dart';
import 'package:graduation_project/features/products_screen/domain/usecases/get_products_by_category_usecase.dart';
import 'package:graduation_project/features/products_screen/presentation/bloc/products_bloc.dart';
import 'package:graduation_project/features/profile_tab/data/dataSources/remote/profile_remote_data_source_impl.dart';
import 'package:graduation_project/features/profile_tab/data/repository/profile_repo_impl.dart';
import 'package:graduation_project/features/profile_tab/domain/usecases/get_profile_usecase.dart';
import 'package:graduation_project/features/profile_tab/domain/usecases/logout_usecase.dart';
import 'package:graduation_project/features/profile_tab/domain/usecases/update_profile_usecase.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_bloc.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_event.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AppProviders {
  // ── Singleton Network ─────────────────────────────
  static final _networkInfo = CheckInternetConnectionImpl(
    InternetConnectionChecker(),
  );

  // ── Repos ─────────────────────────────────────────
  static AuthRepoImpl get _authRepo => AuthRepoImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(),
    localDataSource: AuthLocalDataSourceImpl(),
    networkInfo: _networkInfo,
  );

  static CartRepoImpl get _cartRepo => CartRepoImpl(
    remoteDataSource: CartRemoteDataSourceImpl(),
    localDataSource: CartLocalDataSourceImpl(),
    networkInfo: _networkInfo,
  );

  static HomeRepoImpl get _homeRepo => HomeRepoImpl(
    remoteDataSource: HomeRemoteDataSourceImpl(),
    networkInfo: _networkInfo,
  );

  static CategoriesRepoImpl get _categoriesRepo => CategoriesRepoImpl(
    remoteDataSource: CategoriesRemoteDataSourceImpl(),
    networkInfo: _networkInfo,
  );

  static FavouriteRepoImpl get _favouriteRepo => FavouriteRepoImpl(
    remoteDataSource: FavouriteRemoteDataSourceImpl(),
    networkInfo: _networkInfo,
  );

  static ProfileRepoImpl get _profileRepo => ProfileRepoImpl(
    remoteDataSource: ProfileRemoteDataSourceImpl(),
    networkInfo: _networkInfo,
  );

  static ProductsRepoImpl get _productsRepo => ProductsRepoImpl(
    remoteDataSource: ProductsRemoteDataSourceImpl(),
    networkInfo: _networkInfo,
  );

  static ProductDetailsRepoImpl get _productDetailsRepo =>
      ProductDetailsRepoImpl(
        remoteDataSource: ProductDetailsRemoteDataSourceImpl(),
        networkInfo: _networkInfo,
      );

  static ChatbotRepoImpl get _chatbotRepo => ChatbotRepoImpl(
    remoteDataSource: ChatbotRemoteDataSourceImpl(),
    networkInfo: _networkInfo,
  );

  // ── Providers ─────────────────────────────────────
  static List<BlocProvider> getProviders() => [
    BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(
        loginUseCase: LoginUseCase(_authRepo),
        signUpUseCase: SignUpUseCase(_authRepo),
      ),
    ),

    BlocProvider<CartBloc>(
      create: (_) => CartBloc(
        getCartItemsUseCase: GetCartItemsUseCase(_cartRepo),
        addCartItemUseCase: AddCartItemUseCase(_cartRepo),
        removeCartItemUseCase: RemoveCartItemUseCase(_cartRepo),
        updateCartItemUseCase: UpdateCartItemUseCase(_cartRepo),
        clearCartUseCase: ClearCartUseCase(_cartRepo),
      )..add(const GetCartItemsEvent()),
    ),

    BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(
        getBrandsUseCase: GetBrandsUseCase(_homeRepo),
        getTrendsUseCase: GetTrendsUseCase(_homeRepo),
        getBestPriceUseCase: GetBestPriceUseCase(_homeRepo),
        searchProductsUseCase: SearchProductsUseCase(_homeRepo),
      )..add(const GetHomeDataEvent()),
    ),

    BlocProvider<CategoriesBloc>(
      create: (_) => CategoriesBloc(
        getCategoriesUseCase: GetCategoriesUseCase(_categoriesRepo),
      )..add(const GetCategoriesEvent()),
    ),

    BlocProvider<FavouriteBloc>(
      create: (_) => FavouriteBloc(
        getFavouritesUseCase: GetFavouritesUseCase(_favouriteRepo),
        addFavouriteUseCase: AddFavouriteUseCase(_favouriteRepo),
        removeFavouriteUseCase: RemoveFavouriteUseCase(_favouriteRepo),
      )..add(const GetFavouritesEvent()),
    ),

    BlocProvider<ProfileBloc>(
      create: (_) => ProfileBloc(
        getProfileUseCase: GetProfileUseCase(_profileRepo),
        updateProfileUseCase: UpdateProfileUseCase(_profileRepo),
        logoutUseCase: LogoutUseCase(_profileRepo),
      )..add(const GetProfileEvent()),
    ),

    BlocProvider<ProductsBloc>(
      create: (_) => ProductsBloc(
        getAllProductsUseCase: GetAllProductsUseCase(_productsRepo),
        getProductsByCategoryUseCase: GetProductsByCategoryUseCase(
          _productsRepo,
        ),
      ),
    ),

    BlocProvider<ProductDetailsBloc>(
      create: (ctx) => ProductDetailsBloc(
        getProductDetailsUseCase: GetProductDetailsUseCase(_productDetailsRepo),
        favouriteBloc: ctx.read<FavouriteBloc>(),
      ),
    ),

    BlocProvider<ChatbotBloc>(
      create: (_) => ChatbotBloc(
        sendMessageUseCase: SendMessageUseCase(_chatbotRepo),
        sendImageUseCase: SendImageUseCase(_chatbotRepo),
      ),
    ),
  ];
}
