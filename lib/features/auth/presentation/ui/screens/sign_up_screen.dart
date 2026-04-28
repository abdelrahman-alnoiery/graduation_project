// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:graduation_project/config/routes_manager/routes.dart';
//
// import '../widgets/social_button.dart';
// import '../widgets/text_field.dart';
//
// class SignUpScreen extends StatelessWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: const Color(0xFF0B1B5B),
//       body: Container(
//         color: Colors.grey.shade300,
//         child: Column(
//           children: [
//             // Header
//             Container(
//               width: double.infinity,
//               height: 200,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF1F3C88),
//                 borderRadius: BorderRadius.only(
//                   bottomRight: Radius.circular(80),
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   "CarGo",
//                   style: GoogleFonts.mali(
//                     fontSize: 44,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//               ),
//             ),
//
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 10,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Sign Up",
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       children: [
//                         SizedBox(width: 5),
//                         Text(
//                           "First Name",
//                           style: TextStyle(fontSize: 16, color: Colors.black),
//                         ),
//                         const SizedBox(width: 100),
//                         Text(
//                           "Last Name",
//                           style: TextStyle(fontSize: 16, color: Colors.black),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 5),
//                     Row(
//                       children: [
//                         Expanded(child: textField("Enter First Name")),
//                         const SizedBox(width: 10),
//                         Expanded(child: textField("Enter Last Name")),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     const Text(
//                       "E-Mail",
//                       style: TextStyle(fontSize: 16, color: Colors.black),
//                     ),
//                     const SizedBox(height: 6),
//                     textField("example@gmail.com"),
//
//                     const SizedBox(height: 12),
//
//                     const Text(
//                       "Password",
//                       style: TextStyle(fontSize: 16, color: Colors.black),
//                     ),
//                     const SizedBox(height: 6),
//                     textField(
//                       "At least 8 - Digital Characters",
//                       isPassword: true,
//                     ),
//                     const SizedBox(height: 12),
//
//                     const Text(
//                       "Confirm Password",
//                       style: TextStyle(fontSize: 16, color: Colors.black),
//                     ),
//                     const SizedBox(height: 6),
//                     textField(
//                       "At least 8 - Digital Characters",
//                       isPassword: true,
//                     ),
//                     const SizedBox(height: 5),
//
//                     Row(
//                       children: const [
//                         Expanded(
//                           child: Divider(
//                             thickness: 2,
//                             color: Color(0xFF2D4A9D),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 8),
//                           child: Text(
//                             "Or",
//                             style: TextStyle(color: Color(0xFF2D4A9D)),
//                           ),
//                         ),
//                         Expanded(
//                           child: Divider(
//                             thickness: 2,
//                             color: Color(0xFF2D4A9D),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 10),
//
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF1F3C88),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         onPressed: () {},
//                         child: const Text(
//                           "Sign Up",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 15),
//
//                     Row(
//                       children: [
//                         Expanded(child: socialButton("Google")),
//                         const SizedBox(width: 10),
//                         Expanded(child: socialButton("Facebook")),
//                       ],
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     Center(
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.pushNamed(context, Routes.signInRoute);
//                         },
//                         child: RichText(
//                           text: const TextSpan(
//                             text: "Have an account? ",
//                             style: TextStyle(color: Colors.black),
//                             children: [
//                               TextSpan(
//                                 text: "Sign In",
//                                 style: TextStyle(
//                                   color: Color(0xFF1F3C88),
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:graduation_project/features/auth/presentation/bloc/auth_state.dart';

import '../../../../../core/utils/color_maanger.dart';
import '../../../../../core/utils/components/main_button.dart';
import '../../../../../core/utils/components/main_text_field.dart';
import '../../../../../core/utils/components/validators.dart';
import '../widgets/social_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignUpSuccessState) {
            Navigator.pushReplacementNamed(context, Routes.otpRoute);
          } else if (state is SignUpErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: ColorManager.error,
              ),
            );
          }
        },
        child: Container(
          color: Colors.grey.shade300,
          child: Column(
            children: [
              // ── Header ──────────────────────────────
              Container(
                width: double.infinity,
                height: AppSize.s200,
                decoration: const BoxDecoration(
                  color: ColorManager.primary,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(AppRadius.r50),
                  ),
                ),
                child: Center(
                  child: Text(
                    "CarGo",
                    style: getBoldStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s28,
                    ).copyWith(fontStyle: FontStyle.italic),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p20,
                    vertical: AppPadding.p12,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sign Up",
                          style: getBoldStyle(
                            color: ColorManager.primary,
                            fontSize: FontSize.s32,
                          ),
                        ),

                        const SizedBox(height: AppSize.s20),

                        // ── First & Last Name ────────
                        Row(
                          children: [
                            Expanded(
                              child: MainTextField(
                                hintText: "First Name",
                                labelText: "First Name",
                                controller: _firstNameController,
                                prefixIcon: Icons.person_outline,
                                validator: (value) =>
                                    Validators.validateName(value),
                              ),
                            ),
                            const SizedBox(width: AppSize.s12),
                            Expanded(
                              child: MainTextField(
                                hintText: "Last Name",
                                labelText: "Last Name",
                                controller: _lastNameController,
                                prefixIcon: Icons.person_outline,
                                validator: (value) =>
                                    Validators.validateName(value),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSize.s16),

                        // ── Email ────────────────────
                        MainTextField(
                          hintText: "example@gmail.com",
                          labelText: "E-Mail",
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: Validators.validateEmail,
                        ),

                        const SizedBox(height: AppSize.s16),

                        // ── Phone ────────────────────
                        MainTextField(
                          hintText: "010XXXXXXXX",
                          labelText: "Phone Number",
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                          validator: Validators.validatePhone,
                        ),

                        const SizedBox(height: AppSize.s16),

                        // ── Password ─────────────────
                        MainTextField(
                          hintText: "At least 8 characters",
                          labelText: "Password",
                          controller: _passwordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          validator: Validators.validatePassword,
                        ),

                        const SizedBox(height: AppSize.s16),

                        // ── Confirm Password ─────────
                        MainTextField(
                          hintText: "Confirm your password",
                          labelText: "Confirm Password",
                          controller: _confirmPasswordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          validator: (value) =>
                              Validators.validateConfirmPassword(
                                value,
                                _passwordController.text,
                              ),
                        ),

                        const SizedBox(height: AppSize.s20),

                        // ── Sign Up Button ───────────
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return MainButton(
                              title: "Sign Up",
                              isLoading: state is AuthLoadingState,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    SignUpEvent(
                                      firstName: _firstNameController.text
                                          .trim(),
                                      lastName: _lastNameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                      phone: _phoneController.text.trim(),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),

                        const SizedBox(height: AppSize.s16),

                        // ── Divider ──────────────────
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                thickness: 2,
                                color: ColorManager.primary,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppPadding.p8,
                              ),
                              child: Text(
                                "Or",
                                style: getMediumStyle(
                                  color: ColorManager.primary,
                                  fontSize: FontSize.s14,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                thickness: 2,
                                color: ColorManager.primary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSize.s16),

                        // ── Social Buttons ───────────
                        Row(
                          children: [
                            Expanded(child: socialButton("Google")),
                            const SizedBox(width: 10),
                            Expanded(child: socialButton("Facebook")),
                          ],
                        ),

                        const SizedBox(height: AppSize.s20),

                        // ── Sign In Navigation ───────
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.signInRoute);
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Already have an account? ",
                                style: getRegularStyle(
                                  color: ColorManager.textPrimary,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign In",
                                    style: getBoldStyle(
                                      color: ColorManager.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSize.s20),
                      ],
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
}
