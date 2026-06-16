import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_bloc.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_event.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_state.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../core/network/check_internet_connection.dart';
import '../../../../core/utils/color_maanger.dart';
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
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
        );
    _cardsFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _cardsController, curve: Curves.easeOut));

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
                  // ── Animated Header ────────────
                  FadeTransition(
                    opacity: _headerFade,
                    child: SlideTransition(
                      position: _headerSlide,
                      child: _buildHeader(
                        context,
                        name: name,
                        email: email,
                        role: role,
                        initial: initial,
                      ),
                    ),
                  ),

                  // ── Animated Cards ─────────────
                  FadeTransition(
                    opacity: _cardsFade,
                    child: Padding(
                      padding: const EdgeInsets.all(AppPadding.p16),
                      child: Column(
                        children: [
                          // ── Stats Row ──────────
                          // _buildStatsRow(),
                          const SizedBox(height: AppSize.s20),

                          // ── Menu Section ───────
                          _buildMenuSection(context, user),

                          const SizedBox(height: AppSize.s20),

                          // ── Logout Button ───────
                          _buildLogoutButton(context),

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

  // ── Header ────────────────────────────────────────
  Widget _buildHeader(
    BuildContext context, {
    required String name,
    required String email,
    required String role,
    required String initial,
  }) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.r32),
          bottomRight: Radius.circular(AppRadius.r32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x441a237e),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Decorative circles ────────────────
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // ── Content ───────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppPadding.p20,
              AppPadding.p52,
              AppPadding.p20,
              AppPadding.p32,
            ),
            child: Column(
              children: [
                // ── Avatar ──────────────────────
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: AppSize.s100,
                      height: AppSize.s100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          initial,
                          style: getBoldStyle(
                            color: Colors.white,
                            fontSize: FontSize.s40,
                          ),
                        ),
                      ),
                    ),
                    // ── Edit Badge ───────────────
                    GestureDetector(
                      onTap: () => _showEditDialog(context),
                      child: Container(
                        padding: const EdgeInsets.all(AppPadding.p6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: Color(0xFF1a237e),
                          size: AppSize.s16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSize.s16),

                // ── Name ──────────────────────
                Text(
                  name,
                  style: getBoldStyle(
                    color: Colors.white,
                    fontSize: FontSize.s22,
                  ),
                ),

                const SizedBox(height: AppSize.s4),

                // ── Email ─────────────────────
                if (email.isNotEmpty)
                  Text(
                    email,
                    style: getRegularStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: FontSize.s14,
                    ),
                  ),

                const SizedBox(height: AppSize.s12),

                // ── Role Badge ────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p16,
                    vertical: AppPadding.p6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppRadius.r50),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        color: Colors.white,
                        size: AppSize.s14,
                      ),
                      const SizedBox(width: AppSize.s6),
                      Text(
                        role.toUpperCase(),
                        style: getMediumStyle(
                          color: Colors.white,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Row ─────────────────────────────────────
  // Widget _buildStatsRow() {
  //   return Row(
  //     children: [
  //       _buildStatCard(
  //         icon: Icons.shopping_bag_outlined,
  //         label: "Orders",
  //         value: "0",
  //         color: const Color(0xFF1a237e),
  //       ),
  //       const SizedBox(width: AppSize.s12),
  //       _buildStatCard(
  //         icon: Icons.favorite_outline,
  //         label: "Favourites",
  //         value: "0",
  //         color: const Color(0xFFb71c1c),
  //       ),
  //       const SizedBox(width: AppSize.s12),
  //       _buildStatCard(
  //         icon: Icons.star_outline,
  //         label: "Reviews",
  //         value: "0",
  //         color: const Color(0xFFe65100),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppPadding.p8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: AppSize.s20),
            ),
            const SizedBox(height: AppSize.s8),
            Text(
              value,
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s18,
              ),
            ),
            Text(
              label,
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Menu Section ──────────────────────────────────
  Widget _buildMenuSection(BuildContext context, user) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.person_outline_rounded,
            title: "Edit Profile",
            subtitle: "Update your information",
            color: const Color(0xFF1a237e),
            onTap: () => _showEditDialog(context),
          ),
          _buildDivider(),

          // ✅ Add Product
          _buildMenuItem(
            icon: Icons.add_box_outlined,
            title: "Add Product",
            subtitle: "List a new product for sale",
            color: const Color(0xFF1b5e20),
            onTap: () => Navigator.push(
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
            ),
          ),
          _buildDivider(),

          _buildMenuItem(
            icon: Icons.shopping_bag_outlined,
            title: "My Orders",
            subtitle: "Track your orders",
            color: const Color(0xFF0d47a1),
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.info_outline_rounded,
            title: "About CarGo",
            subtitle: "Version 1.0.0",
            color: const Color(0xFF1b5e20),
            onTap: () => _showAboutDialog(context),
            showArrow: false,
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r24),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppPadding.p24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Logo ──────────────────────────────
              Container(
                width: AppSize.s80,
                height: AppSize.s80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.r20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1a237e).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.directions_car_rounded,
                    color: Colors.white,
                    size: AppSize.s40,
                  ),
                ),
              ),

              const SizedBox(height: AppSize.s16),

              Text(
                "CarGo",
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s24,
                ),
              ),

              const SizedBox(height: AppSize.s4),

              Text(
                "Version 1.0.0",
                style: getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s13,
                ),
              ),

              const SizedBox(height: AppSize.s16),

              Container(
                padding: const EdgeInsets.all(AppPadding.p16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F8),
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                child: Text(
                  "CarGo is your one-stop shop for car accessories and parts. Find everything you need for your vehicle at the best prices.",
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppSize.s20),

              // ── Info Rows ──────────────────────────
              _buildAboutRow(Icons.code_rounded, "Developed by CarGo Team"),
              const SizedBox(height: AppSize.s8),
              _buildAboutRow(Icons.school_rounded, "Graduation Project 2026"),

              const SizedBox(height: AppSize.s24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1a237e),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppPadding.p14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Close",
                    style: getBoldStyle(
                      color: Colors.white,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF1a237e), size: AppSize.s16),
        const SizedBox(width: AppSize.s8),
        Text(
          text,
          style: getMediumStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s13,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p14,
        ),
        child: Row(
          children: [
            // ── Icon ──────────────────────────────
            Container(
              padding: const EdgeInsets.all(AppPadding.p10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: Icon(icon, color: color, size: AppSize.s22),
            ),

            const SizedBox(width: AppSize.s14),

            // ── Text ──────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getMediumStyle(
                      color: ColorManager.textPrimary,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: getRegularStyle(
                      color: ColorManager.textSecondary,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ),
            ),

            // ── Arrow ─────────────────────────────
            if (showArrow)
              Container(
                padding: const EdgeInsets.all(AppPadding.p4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ColorManager.grey,
                  size: AppSize.s14,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.withOpacity(0.08),
      indent:
          AppPadding.p16 + AppSize.s22 + AppPadding.p10 * 2 + AppPadding.p14,
    );
  }

  // ── Logout Button ─────────────────────────────────
  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFb71c1c), Color(0xFFe53935)],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFb71c1c).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: AppSize.s20,
            ),
            const SizedBox(width: AppSize.s8),
            Text(
              "Logout",
              style: getBoldStyle(color: Colors.white, fontSize: FontSize.s16),
            ),
          ],
        ),
      ),
    );
  }

  // ── Edit Dialog ───────────────────────────────────
  void _showEditDialog(BuildContext context) {
    final state = context.read<ProfileBloc>().state;
    final user = state is ProfileSuccessState ? state.user : null;

    final nameController = TextEditingController(text: user?.fullName ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r24),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppPadding.p24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Title ───────────────────────────
              Container(
                padding: const EdgeInsets.all(AppPadding.p12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1a237e).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Color(0xFF1a237e),
                  size: AppSize.s28,
                ),
              ),

              const SizedBox(height: AppSize.s12),

              Text(
                "Edit Profile",
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s20,
                ),
              ),

              const SizedBox(height: AppSize.s4),

              Text(
                "Update your personal information",
                style: getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s13,
                ),
              ),

              const SizedBox(height: AppSize.s24),

              // ── Name Field ──────────────────────
              _buildTextField(
                controller: nameController,
                label: "Full Name",
                icon: Icons.person_outline_rounded,
              ),

              const SizedBox(height: AppSize.s16),

              // ── Email Field ─────────────────────
              _buildTextField(
                controller: emailController,
                label: "Email Address",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: AppSize.s24),

              // ── Buttons ─────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.p14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: getMediumStyle(
                          color: ColorManager.textSecondary,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSize.s12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(
                          UpdateProfileEvent(
                            username: nameController.text.trim(),
                            email: emailController.text.trim(),
                          ),
                        );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "Profile updated successfully!",
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.r12,
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1a237e),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.p14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Save",
                        style: getBoldStyle(
                          color: Colors.white,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F8),
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: getRegularStyle(
            color: ColorManager.textSecondary,
            fontSize: FontSize.s14,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF1a237e),
            size: AppSize.s20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFF0F2F8),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p16,
            vertical: AppPadding.p14,
          ),
        ),
      ),
    );
  }

  // ── Logout Dialog ─────────────────────────────────
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r24),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppPadding.p24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icon ────────────────────────────
              Container(
                padding: const EdgeInsets.all(AppPadding.p16),
                decoration: BoxDecoration(
                  color: const Color(0xFFb71c1c).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFb71c1c),
                  size: AppSize.s32,
                ),
              ),

              const SizedBox(height: AppSize.s16),

              Text(
                "Logout",
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s20,
                ),
              ),

              const SizedBox(height: AppSize.s8),

              Text(
                "Are you sure you want to\nlogout from your account?",
                style: getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s14,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSize.s24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.p14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: getMediumStyle(
                          color: ColorManager.textSecondary,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSize.s12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.read<ProfileBloc>().add(const LogoutEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFb71c1c),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.p14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Logout",
                        style: getBoldStyle(
                          color: Colors.white,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
