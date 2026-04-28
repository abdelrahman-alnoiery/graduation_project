// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:graduation_project/config/routes_manager/routes.dart';
//
// import '../widgets/social_button.dart';
// import '../widgets/text_field.dart';
//
// class SignInScreen extends StatelessWidget {
//   const SignInScreen({super.key});
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
//                       "Sign In",
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     const Text(
//                       "E-Mail",
//                       style: TextStyle(fontSize: 16, color: Colors.black),
//                     ),
//                     const SizedBox(height: 6),
//                     textField("example@gmail.com"),
//
//                     const SizedBox(height: 15),
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
//
//                     const SizedBox(height: 5),
//
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () {},
//                         child: const Text(
//                           "Forget Password?",
//                           style: TextStyle(color: Color(0xFF1F3C88)),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 10),
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
//                     const SizedBox(height: 15),
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
//                         onPressed: () {
//                           Navigator.pushNamed(
//                             context,
//                             Routes.homePageLayoutRoute,
//                           );
//                         },
//                         child: const Text(
//                           "Log In",
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
//                           Navigator.pushNamed(context, Routes.signUpRoute);
//                         },
//                         child: RichText(
//                           text: const TextSpan(
//                             text: "Don’t have an account? ",
//                             style: TextStyle(color: Colors.black),
//                             children: [
//                               TextSpan(
//                                 text: "Sign Up",
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

// // screens by ai
//
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

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignInSuccessState) {
            Navigator.pushReplacementNamed(context, Routes.homePageLayoutRoute);
          } else if (state is SignInErrorState) {
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
                          "Sign In",
                          style: getBoldStyle(
                            color: ColorManager.primary,
                            fontSize: FontSize.s32,
                          ),
                        ),

                        const SizedBox(height: AppSize.s20),

                        // ── Email Field ──────────────
                        MainTextField(
                          hintText: "example@gmail.com",
                          labelText: "E-Mail",
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: Validators.validateEmail,
                        ),

                        const SizedBox(height: AppSize.s16),

                        // ── Password Field ───────────
                        MainTextField(
                          hintText: "At least 8 characters",
                          labelText: "Password",
                          controller: _passwordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          validator: Validators.validatePassword,
                        ),

                        // ── Forget Password ──────────
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forget Password?",
                              style: getMediumStyle(
                                color: ColorManager.primary,
                                fontSize: FontSize.s14,
                              ),
                            ),
                          ),
                        ),

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

                        // ── Log In Button ────────────
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return MainButton(
                              title: "Log In",
                              isLoading: state is AuthLoadingState,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    SignInEvent(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    ),
                                  );
                                }
                              },
                            );
                          },
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

                        // ── Sign Up Navigation ───────
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.signUpRoute);
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: getRegularStyle(
                                  color: ColorManager.textPrimary,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: getBoldStyle(
                                      color: ColorManager.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
