import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_bloc.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_event.dart';
import 'package:graduation_project/features/profile_tab/presentation/bloc/profile_state.dart';

import '../../../../core/utils/color_maanger.dart';
import '../../../../core/utils/components/main_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const GetProfileEvent());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LogoutSuccessState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.signInRoute,
              (route) => false,
            );
          } else if (state is UpdateProfileSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Profile updated successfully",
                  style: getRegularStyle(color: ColorManager.white),
                ),
                backgroundColor: ColorManager.success,
              ),
            );
          } else if (state is ProfileErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: ColorManager.error,
              ),
            );
          } else if (state is GetProfileSuccessState) {
            _firstNameController.text = state.profile.firstName;
            _lastNameController.text = state.profile.lastName;
            _phoneController.text = state.profile.phone;
            _emailController.text = state.profile.email;
            _selectedLanguage = state.profile.language;
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // ── Header ──────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppPadding.p16),
                decoration: const BoxDecoration(
                  color: ColorManager.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppRadius.r24),
                    bottomRight: Radius.circular(AppRadius.r24),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppSize.s40),
                    Text(
                      "CarGo",
                      style: GoogleFonts.mali(
                        fontSize: 44,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: state is ProfileLoadingState
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primary,
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(AppPadding.p16),
                        child: Column(
                          children: [
                            // ── Profile Image ──────
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: AppSize.s48,
                                  backgroundColor: ColorManager.lightGrey,
                                  backgroundImage:
                                      state is GetProfileSuccessState &&
                                          state.profile.image != null
                                      ? NetworkImage(state.profile.image!)
                                      : null,
                                  child:
                                      state is GetProfileSuccessState &&
                                          state.profile.image == null
                                      ? const Icon(
                                          Icons.person,
                                          size: AppSize.s60,
                                          color: ColorManager.grey,
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                      AppPadding.p4,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: ColorManager.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: ColorManager.white,
                                      size: AppSize.s16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: AppSize.s8),

                            // ── Name & Email ───────
                            if (state is GetProfileSuccessState) ...[
                              Text(
                                state.profile.fullName,
                                style: getBoldStyle(
                                  color: ColorManager.textPrimary,
                                  fontSize: FontSize.s18,
                                ),
                              ),
                              Text(
                                state.profile.email,
                                style: getRegularStyle(
                                  color: ColorManager.textSecondary,
                                  fontSize: FontSize.s14,
                                ),
                              ),
                            ],

                            const SizedBox(height: AppSize.s20),

                            // ── Fields ─────────────
                            _buildField("First Name", _firstNameController),
                            const SizedBox(height: AppSize.s12),
                            _buildField("Last Name", _lastNameController),
                            const SizedBox(height: AppSize.s12),
                            _buildField(
                              "Phone Number",
                              _phoneController,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: AppSize.s12),
                            _buildField(
                              "E-Mail",
                              _emailController,
                              enabled: false,
                            ),
                            const SizedBox(height: AppSize.s12),

                            // ── Language ───────────
                            _buildLanguageDropdown(),

                            const SizedBox(height: AppSize.s20),

                            // ── Save Button ────────
                            MainButton(
                              title: "Save Changes",
                              isLoading: state is ProfileLoadingState,
                              onPressed: () {
                                context.read<ProfileBloc>().add(
                                  UpdateProfileEvent(
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    phone: _phoneController.text,
                                    language: _selectedLanguage,
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: AppSize.s12),

                            // ── Logout Button ───────
                            MainButton(
                              title: "Log Out",
                              isOutlined: true,
                              onPressed: () {
                                _showLogoutDialog(context);
                              },
                            ),

                            const SizedBox(height: AppSize.s20),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Field Builder ─────────────────────────────────
  Widget _buildField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getMediumStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s14,
          ),
        ),
        const SizedBox(height: AppSize.s4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          style: getRegularStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s14,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? ColorManager.white : ColorManager.lightGrey,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p16,
              vertical: AppPadding.p12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r8),
              borderSide: const BorderSide(color: ColorManager.lightGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r8),
              borderSide: const BorderSide(color: ColorManager.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r8),
              borderSide: const BorderSide(
                color: ColorManager.primary,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r8),
              borderSide: const BorderSide(color: ColorManager.lightGrey),
            ),
          ),
        ),
      ],
    );
  }

  // ── Language Dropdown ─────────────────────────────
  Widget _buildLanguageDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Language",
          style: getMediumStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s14,
          ),
        ),
        const SizedBox(height: AppSize.s4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(AppRadius.r8),
            border: Border.all(color: ColorManager.lightGrey),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedLanguage,
              isExpanded: true,
              items: ['English', 'Arabic'].map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Text(
                    lang,
                    style: getRegularStyle(
                      color: ColorManager.textPrimary,
                      fontSize: FontSize.s14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
              },
            ),
          ),
        ),
      ],
    );
  }

  // ── Logout Dialog ─────────────────────────────────
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Log Out",
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s18,
          ),
        ),
        content: Text(
          "Are you sure you want to log out?",
          style: getRegularStyle(
            color: ColorManager.textSecondary,
            fontSize: FontSize.s14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: getMediumStyle(
                color: ColorManager.grey,
                fontSize: FontSize.s14,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileBloc>().add(const LogoutEvent());
            },
            child: Text(
              "Log Out",
              style: getMediumStyle(
                color: ColorManager.error,
                fontSize: FontSize.s14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
