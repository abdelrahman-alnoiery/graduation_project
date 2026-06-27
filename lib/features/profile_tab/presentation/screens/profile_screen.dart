import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/color_maanger.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_bloc.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_state.dart';
import 'package:graduation_project/features/profile_tab/presentation/widgets/profile_about_dialog.dart';
import 'package:graduation_project/features/profile_tab/presentation/widgets/profile_edit_dialog.dart';
import 'package:graduation_project/features/profile_tab/presentation/widgets/profile_header.dart';
import 'package:graduation_project/features/profile_tab/presentation/widgets/profile_logout_button.dart';
import 'package:graduation_project/features/profile_tab/presentation/widgets/profile_logout_dialog.dart';
import 'package:graduation_project/features/profile_tab/presentation/widgets/profile_menu_section.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../core/network/check_internet_connection.dart';
import '../../../add_product/data/dataSources/remote/add_product_remote_datasource_impl.dart';
import '../../../add_product/data/repository/add_product_repo_impl.dart';
import '../../../add_product/domain/usecases/add_product_usecase.dart';
import '../../../add_product/presentation/bloc/add_product_bloc.dart';
import '../../../add_product/presentation/ui/add_product_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardsController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _cardsFade;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerSlide =
        Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
        );
    _cardsFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardsController, curve: Curves.easeOut),
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _cardsController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  void _navigateToAddProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AddProductBloc(
            addProductUseCase: AddProductUseCase(
              AddProductRepoImpl(
                remoteDataSource: AddProductRemoteDatasourceImpl(),
                networkInfo: CheckInternetConnectionImpl(
                  InternetConnectionChecker(),
                ),
              ),
            ),
          ),
          child: const AddProductScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LogoutSuccessState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.signInRoute,
              (route) => false,
            );
          }
          if (state is ProfileErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorManager.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: ColorManager.primary),
            );
          }

          if (state is ProfileSuccessState || state is ProfileErrorState) {
            final user = state is ProfileSuccessState ? state.user : null;
            final name = user?.fullName ?? 'User';
            final email = user?.email ?? '';
            final role = user?.role ?? 'seller';
            final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  FadeTransition(
                    opacity: _headerFade,
                    child: SlideTransition(
                      position: _headerSlide,
                      child: ProfileHeader(
                        name: name,
                        email: email,
                        role: role,
                        initial: initial,
                        onEditTap: () => showProfileEditDialog(context),
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _cardsFade,
                    child: Padding(
                      padding: const EdgeInsets.all(AppPadding.p16),
                      child: Column(
                        children: [
                          const SizedBox(height: AppSize.s20),
                          ProfileMenuSection(
                            onEditProfile: () =>
                                showProfileEditDialog(context),
                            onAddProduct: _navigateToAddProduct,
                            onOrders: () {},
                            onAbout: () => showProfileAboutDialog(context),
                          ),
                          const SizedBox(height: AppSize.s20),
                          ProfileLogoutButton(
                            onTap: () => showProfileLogoutDialog(context),
                          ),
                          const SizedBox(height: AppSize.s32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
