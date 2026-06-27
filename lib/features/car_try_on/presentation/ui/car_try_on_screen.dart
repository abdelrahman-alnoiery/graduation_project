import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../data/datasources/car_try_on_remote_datasource_impl.dart';
import '../../data/repository/car_try_on_repo_impl.dart';
import '../../domain/usecases/car_try_on_usecase.dart';
import '../bloc/car_try_on_bloc.dart';
import '../bloc/car_try_on_event.dart';
import '../bloc/car_try_on_state.dart';

class CarTryOnScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;

  const CarTryOnScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.productImage,
  });

  @override
  State<CarTryOnScreen> createState() => _CarTryOnScreenState();
}

class _CarTryOnScreenState extends State<CarTryOnScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null && mounted) {
        setState(() {
          _selectedImage = File(image.path);
        });
        // ✅ reset الـ BLoC لو كان فيه نتيجة قديمة
        context.read<CarTryOnBloc>().add(const ResetCarTryOnEvent());
      }
    } catch (e) {
      _showSnack('Failed to pick image', Colors.red);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
      ),
    );
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppPadding.p24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.r24),
            topRight: Radius.circular(AppRadius.r24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSize.s40,
              height: AppSize.s4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppRadius.r4),
              ),
            ),
            const SizedBox(height: AppSize.s20),
            Text(
              'Select Your Car Photo',
              style: getBoldStyle(
                color: const Color(0xFF1a237e),
                fontSize: FontSize.s18,
              ),
            ),
            const SizedBox(height: AppSize.s20),
            Row(
              children: [
                Expanded(
                  child: _sourceButton(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    filled: true,
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ),
                const SizedBox(width: AppSize.s16),
                Expanded(
                  child: _sourceButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    filled: false,
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.s8),
          ],
        ),
      ),
    );
  }

  Widget _sourceButton({
    required IconData icon,
    required String label,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
        decoration: BoxDecoration(
          gradient: filled
              ? const LinearGradient(
                  colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                )
              : null,
          color: filled ? null : const Color(0xFFF0F2F8),
          borderRadius: BorderRadius.circular(AppRadius.r16),
          border: filled
              ? null
              : Border.all(color: const Color(0xFF1a237e).withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: filled ? Colors.white : const Color(0xFF1a237e),
              size: AppSize.s32,
            ),
            const SizedBox(height: AppSize.s8),
            Text(
              label,
              style: getMediumStyle(
                color: filled ? Colors.white : const Color(0xFF1a237e),
                fontSize: FontSize.s14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarTryOnBloc(
        carTryOnUseCase: CarTryOnUseCase(
          CarTryOnRepoImpl(
            remoteDataSource: CarTryOnRemoteDatasourceImpl(),
            networkInfo: CheckInternetConnectionImpl(
              InternetConnectionChecker(),
            ),
          ),
        ),
      ),
      child: BlocConsumer<CarTryOnBloc, CarTryOnState>(
        listener: (context, state) {
          if (state is CarTryOnErrorState) {
            _showSnack(state.message, Colors.red);
          }
        },
        builder: (context, state) {
          final isLoading = state is CarTryOnLoadingState;
          final result = state is CarTryOnSuccessState ? state.result : null;

          return Scaffold(
            backgroundColor: const Color(0xFFF0F2F8),
            body: Column(
              children: [
                // ── Header ──────────────────────────
                _buildHeader(),

                // ── Content ─────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(AppPadding.p16),
                    child: Column(
                      children: [
                        // ── Product Preview ───────────
                        _buildProductPreview(),
                        const SizedBox(height: AppSize.s16),

                        // ── Car Image Upload ──────────
                        _buildImageUploadBox(),
                        const SizedBox(height: AppSize.s16),

                        // ── Loading ───────────────────
                        if (isLoading) _buildLoadingCard(),

                        // ── Result ────────────────────
                        if (result != null)
                          _buildResultCard(result.resultImageUrl),

                        const SizedBox(height: AppSize.s24),
                      ],
                    ),
                  ),
                ),

                // ── Generate Button ──────────────────
                if (_selectedImage != null && !isLoading)
                  _buildGenerateButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Header ─────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0d1b4b), Color(0xFF1a237e), Color(0xFF283593)],
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppPadding.p20,
          AppPadding.p52,
          AppPadding.p20,
          AppPadding.p24,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(AppPadding.p8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                  size: AppSize.s20,
                ),
              ),
            ),
            const SizedBox(width: AppSize.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Try on Your Car 🚗',
                    style: getBoldStyle(
                      color: Colors.white,
                      fontSize: FontSize.s20,
                    ),
                  ),
                  Text(
                    widget.productName,
                    style: getRegularStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: FontSize.s12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Product Preview ────────────────────────────────
  Widget _buildProductPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.p16),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            child: Image.network(
              widget.productImage,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: const Color(0xFFF0F2F8),
                child: const Icon(Icons.directions_car, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: AppSize.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product to install',
                  style: getRegularStyle(
                    color: Colors.grey,
                    fontSize: FontSize.s11,
                  ),
                ),
                const SizedBox(height: AppSize.s4),
                Text(
                  widget.productName,
                  style: getMediumStyle(
                    color: const Color(0xFF1a237e),
                    fontSize: FontSize.s14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p10,
              vertical: AppPadding.p4,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1a237e).withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppRadius.r50),
            ),
            child: Text(
              'AI Ready ✨',
              style: getMediumStyle(
                color: const Color(0xFF1a237e),
                fontSize: FontSize.s11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Image Upload Box ───────────────────────────────
  Widget _buildImageUploadBox() {
    return GestureDetector(
      onTap: _showImageSourceSheet,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r20),
          border: Border.all(
            color: const Color(0xFF1a237e).withOpacity(0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.r18),
                child: Stack(
                  children: [
                    Image.file(
                      _selectedImage!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: _showImageSourceSheet,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: AppPadding.p40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppPadding.p16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1a237e).withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate_rounded,
                        color: Color(0xFF1a237e),
                        size: AppSize.s44,
                      ),
                    ),
                    const SizedBox(height: AppSize.s12),
                    Text(
                      'Upload Your Car Photo',
                      style: getMediumStyle(
                        color: const Color(0xFF1a237e),
                        fontSize: FontSize.s16,
                      ),
                    ),
                    const SizedBox(height: AppSize.s4),
                    Text(
                      'Tap to choose from camera or gallery',
                      style: getRegularStyle(
                        color: Colors.grey,
                        fontSize: FontSize.s13,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // ── Loading Card ───────────────────────────────────
  Widget _buildLoadingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.p24),
      margin: const EdgeInsets.only(bottom: AppMargin.m16),
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
          const CircularProgressIndicator(color: Color(0xFF1a237e)),
          const SizedBox(height: AppSize.s16),
          Text(
            'AI is working its magic... ✨',
            style: getMediumStyle(
              color: const Color(0xFF1a237e),
              fontSize: FontSize.s15,
            ),
          ),
          const SizedBox(height: AppSize.s4),
          Text(
            'This may take up to 60 seconds',
            style: getRegularStyle(color: Colors.grey, fontSize: FontSize.s13),
          ),
        ],
      ),
    );
  }

  // ── Result Card ────────────────────────────────────
  Widget _buildResultCard(String imageUrl) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppMargin.m16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppPadding.p16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSize.s8),
                Text(
                  'AI Result',
                  style: getBoldStyle(
                    color: const Color(0xFF1a237e),
                    fontSize: FontSize.s16,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    context.read<CarTryOnBloc>().add(
                      const ResetCarTryOnEvent(),
                    );
                    setState(() => _selectedImage = null);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p10,
                      vertical: AppPadding.p4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1a237e).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppRadius.r50),
                    ),
                    child: Text(
                      'Try Again',
                      style: getMediumStyle(
                        color: const Color(0xFF1a237e),
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppRadius.r20),
              bottomRight: Radius.circular(AppRadius.r20),
            ),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (ctx, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 250,
                  color: const Color(0xFFF0F2F8),
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1a237e)),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: const Color(0xFFF0F2F8),
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Generate Button ────────────────────────────────
  Widget _buildGenerateButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            if (_selectedImage == null) return;
            context.read<CarTryOnBloc>().add(
              TryOnCarEvent(
                productId: widget.productId,
                carImage: _selectedImage!,
                productImageUrl: widget.productImage, // ✅ أضف ده
              ),
            );
          },
          icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
          label: Text(
            'Generate AI Try-On ✨',
            style: getBoldStyle(color: Colors.white, fontSize: FontSize.s16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1a237e),
            padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r16),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
