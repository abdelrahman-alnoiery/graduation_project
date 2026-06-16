import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/products_screen/presentation/bloc/products_event.dart';
import 'package:image_picker/image_picker.dart';

import '../../../products_screen/presentation/bloc/products_bloc.dart';
import '../../presentation/bloc/add_product_bloc.dart';
import '../../presentation/bloc/add_product_event.dart';
import '../../presentation/bloc/add_product_state.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen>
    with TickerProviderStateMixin {
  // ── Controllers ───────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  // ── State ─────────────────────────────────────────
  String? _selectedCategory;
  final List<File> _selectedImages = [];

  // ── Animation ─────────────────────────────────────
  late AnimationController _headerController;
  late AnimationController _formController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _formFade;
  late Animation<Offset> _formSlide;

  // ── Categories ────────────────────────────────────
  static const List<String> _categories = [
    'Car Door',
    'Auto Lighting Systems',
    'wheels',
    'car accessories',
    'Engine Parts',
    'Brakes',
    'Suspension',
    'Interior',
  ];

  // ── Category Icons ────────────────────────────────
  IconData _getCategoryIcon(String cat) {
    switch (cat) {
      case 'Car Door':
        return Icons.directions_car_outlined;
      case 'Auto Lighting Systems':
        return Icons.bolt_outlined;
      case 'wheels':
        return Icons.tire_repair_outlined;
      case 'car accessories':
        return Icons.auto_awesome_outlined;
      case 'Engine Parts':
        return Icons.settings_outlined;
      case 'Brakes':
        return Icons.radio_button_checked_outlined;
      case 'Suspension':
        return Icons.car_repair_outlined;
      case 'Interior':
        return Icons.airline_seat_recline_extra_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
        );
    _formFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOut));
    _formSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOut));

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _formController.forward();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _headerController.dispose();
    _formController.dispose();
    super.dispose();
  }

  // ── Pick Images ───────────────────────────────────
  Future<void> _pickImages() async {
    try {
      final picker = ImagePicker();
      final images = await picker.pickMultiImage(imageQuality: 80);
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(
            images.take(5 - _selectedImages.length).map((x) => File(x.path)),
          );
        });
      }
    } catch (e) {
      _showSnack("Failed to pick images", Colors.red);
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null && _selectedImages.length < 5) {
        setState(() => _selectedImages.add(File(image.path)));
      }
    } catch (e) {
      _showSnack("Failed to open camera", Colors.red);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
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
              "Add Product Images",
              style: getBoldStyle(
                color: const Color(0xFF1a237e),
                fontSize: FontSize.s18,
              ),
            ),
            const SizedBox(height: AppSize.s20),
            Row(
              children: [
                Expanded(
                  child: _buildSourceButton(
                    icon: Icons.camera_alt_rounded,
                    label: "Camera",
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickFromCamera();
                    },
                  ),
                ),
                const SizedBox(width: AppSize.s16),
                Expanded(
                  child: _buildSourceButton(
                    icon: Icons.photo_library_rounded,
                    label: "Gallery",
                    isOutlined: true,
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickImages();
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

  Widget _buildSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isOutlined = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
        decoration: BoxDecoration(
          gradient: isOutlined
              ? null
              : const LinearGradient(
                  colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                ),
          border: isOutlined
              ? Border.all(color: const Color(0xFF1a237e).withOpacity(0.3))
              : null,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          boxShadow: isOutlined
              ? null
              : [
                  BoxShadow(
                    color: const Color(0xFF1a237e).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isOutlined ? const Color(0xFF1a237e) : Colors.white,
              size: AppSize.s32,
            ),
            const SizedBox(height: AppSize.s8),
            Text(
              label,
              style: getMediumStyle(
                color: isOutlined ? const Color(0xFF1a237e) : Colors.white,
                fontSize: FontSize.s14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Reset Form ────────────────────────────────────
  void _resetForm() {
    _nameController.clear();
    _descController.clear();
    _priceController.clear();
    _stockController.clear();
    setState(() {
      _selectedCategory = null;
      _selectedImages.clear();
    });
  }

  // ── Submit ────────────────────────────────────────
  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      _showSnack('Please select a category', Colors.orange);
      return;
    }
    if (_selectedImages.isEmpty) {
      _showSnack('Please add at least one image', Colors.orange);
      return;
    }

    context.read<AddProductBloc>().add(
      SubmitAddProductEvent(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        category: _selectedCategory!,
        price: double.parse(_priceController.text.trim()),
        stock: int.parse(_stockController.text.trim()),
        images: _selectedImages,
      ),
    );
  }

  // ── Build ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddProductBloc, AddProductState>(
      listener: (context, state) {
        if (state is AddProductSuccessState) {
          // ✅ أعد تحميل الـ products
          context.read<ProductsBloc>().add(const GetProductsEvent());
          _resetForm();
          context.read<AddProductBloc>().add(ResetAddProductEvent());
          _showSnack('Product added successfully! 🎉', Colors.green);
        }
        if (state is AddProductErrorState) {
          _showSnack(state.message, Colors.red);
        }
      },
      builder: (context, state) {
        final isLoading = state is AddProductLoadingState;

        return Scaffold(
          backgroundColor: const Color(0xFFF0F2F8),
          body: Column(
            children: [
              // ── Header ──────────────────────────
              FadeTransition(
                opacity: _headerFade,
                child: SlideTransition(
                  position: _headerSlide,
                  child: _buildHeader(context),
                ),
              ),

              // ── Form ────────────────────────────
              Expanded(
                child: FadeTransition(
                  opacity: _formFade,
                  child: SlideTransition(
                    position: _formSlide,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(AppPadding.p16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Success Banner ─────
                            if (state is AddProductSuccessState)
                              _buildBanner(
                                'Product added successfully! 🎉',
                                Colors.green,
                                Icons.check_circle_rounded,
                              ),

                            // ── Error Banner ───────
                            if (state is AddProductErrorState)
                              _buildBanner(
                                state.message,
                                Colors.red,
                                Icons.error_rounded,
                              ),

                            // ── Images ────────────
                            _buildSectionTitle(
                              'Product Images',
                              Icons.image_rounded,
                            ),
                            const SizedBox(height: AppSize.s12),
                            _buildImagesSection(),
                            const SizedBox(height: AppSize.s24),

                            // ── Info ──────────────
                            _buildSectionTitle(
                              'Product Information',
                              Icons.info_outline_rounded,
                            ),
                            const SizedBox(height: AppSize.s12),
                            _buildInfoSection(),
                            const SizedBox(height: AppSize.s24),

                            // ── Category ──────────
                            _buildSectionTitle(
                              'Category',
                              Icons.grid_view_rounded,
                            ),
                            const SizedBox(height: AppSize.s12),
                            _buildCategorySection(),
                            const SizedBox(height: AppSize.s24),

                            // ── Price & Stock ──────
                            _buildSectionTitle(
                              'Price & Stock',
                              Icons.attach_money_rounded,
                            ),
                            const SizedBox(height: AppSize.s12),
                            _buildPriceStockSection(),
                            const SizedBox(height: AppSize.s32),

                            // ── Submit ─────────────
                            _buildSubmitButton(isLoading, context),
                            const SizedBox(height: AppSize.s24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Header ────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
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
            color: Color(0x551a237e),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Padding(
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
                        'Add New Product',
                        style: getBoldStyle(
                          color: Colors.white,
                          fontSize: FontSize.s22,
                        ),
                      ),
                      Text(
                        'Fill in the details below',
                        style: getRegularStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: FontSize.s13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p12,
                    vertical: AppPadding.p6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppRadius.r50),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.store_rounded,
                        color: Colors.white,
                        size: AppSize.s14,
                      ),
                      const SizedBox(width: AppSize.s4),
                      Text(
                        'Seller',
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

  // ── Section Title ─────────────────────────────────
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppPadding.p6),
          decoration: BoxDecoration(
            color: const Color(0xFF1a237e).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.r8),
          ),
          child: Icon(icon, color: const Color(0xFF1a237e), size: AppSize.s18),
        ),
        const SizedBox(width: AppSize.s10),
        Text(
          title,
          style: getBoldStyle(
            color: const Color(0xFF1a237e),
            fontSize: FontSize.s16,
          ),
        ),
      ],
    );
  }

  // ── Images Section ────────────────────────────────
  Widget _buildImagesSection() {
    return Container(
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
      child: Column(
        children: [
          if (_selectedImages.isNotEmpty) ...[
            SizedBox(
              height: AppSize.s100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _selectedImages.length,
                itemBuilder: (ctx, i) => _buildImageTile(i),
              ),
            ),
            const SizedBox(height: AppSize.s12),
          ],
          if (_selectedImages.length < 5)
            GestureDetector(
              onTap: _showImageSourceSheet,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1a237e).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  border: Border.all(
                    color: const Color(0xFF1a237e).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppPadding.p12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1a237e).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate_rounded,
                        color: Color(0xFF1a237e),
                        size: AppSize.s28,
                      ),
                    ),
                    const SizedBox(height: AppSize.s8),
                    Text(
                      _selectedImages.isEmpty
                          ? 'Add Product Images'
                          : 'Add More Images',
                      style: getMediumStyle(
                        color: const Color(0xFF1a237e),
                        fontSize: FontSize.s14,
                      ),
                    ),
                    Text(
                      '${_selectedImages.length}/5 images',
                      style: getRegularStyle(
                        color: Colors.grey,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageTile(int index) {
    return Stack(
      children: [
        Container(
          width: AppSize.s100,
          height: AppSize.s100,
          margin: const EdgeInsets.only(right: AppPadding.p8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            child: Image.file(_selectedImages[index], fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 4,
          right: 12,
          child: GestureDetector(
            onTap: () => setState(() => _selectedImages.removeAt(index)),
            child: Container(
              padding: const EdgeInsets.all(AppPadding.p4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: AppSize.s14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Info Section ──────────────────────────────────
  Widget _buildInfoSection() {
    return Container(
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
      child: Column(
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Product Name',
            hint: 'e.g. BMW Steering Wheel Cover',
            icon: Icons.inventory_2_outlined,
            validator: (v) =>
                v == null || v.isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: AppSize.s16),
          _buildTextField(
            controller: _descController,
            label: 'Description',
            hint: 'Describe your product...',
            icon: Icons.description_outlined,
            maxLines: 4,
            validator: (v) =>
                v == null || v.isEmpty ? 'Description is required' : null,
          ),
        ],
      ),
    );
  }

  // ── Category Section ──────────────────────────────
  Widget _buildCategorySection() {
    return Container(
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
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSize.s10,
          crossAxisSpacing: AppSize.s10,
          childAspectRatio: 2.8,
        ),
        itemCount: _categories.length,
        itemBuilder: (ctx, i) {
          final cat = _categories[i];
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                      )
                    : null,
                color: isSelected ? null : const Color(0xFFF0F2F8),
                borderRadius: BorderRadius.circular(AppRadius.r10),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : const Color(0xFF1a237e).withOpacity(0.1),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF1a237e).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getCategoryIcon(cat),
                    color: isSelected ? Colors.white : const Color(0xFF1a237e),
                    size: AppSize.s16,
                  ),
                  const SizedBox(width: AppSize.s6),
                  Flexible(
                    child: Text(
                      cat,
                      style: getMediumStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF1a237e),
                        fontSize: FontSize.s11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Price & Stock ─────────────────────────────────
  Widget _buildPriceStockSection() {
    return Container(
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
          Expanded(
            child: _buildTextField(
              controller: _priceController,
              label: 'Price (EGP)',
              hint: '0.00',
              icon: Icons.payments_outlined,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (double.tryParse(v) == null) return 'Invalid';
                return null;
              },
            ),
          ),
          const SizedBox(width: AppSize.s12),
          Expanded(
            child: _buildTextField(
              controller: _stockController,
              label: 'Stock',
              hint: '0',
              icon: Icons.inventory_outlined,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (int.tryParse(v) == null) return 'Invalid';
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Text Field ────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: getRegularStyle(
        color: const Color(0xFF1a237e),
        fontSize: FontSize.s14,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: getMediumStyle(color: Colors.grey, fontSize: FontSize.s13),
        hintStyle: getRegularStyle(
          color: Colors.grey.withOpacity(0.6),
          fontSize: FontSize.s13,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF1a237e).withOpacity(0.7),
          size: AppSize.s20,
        ),
        filled: true,
        fillColor: const Color(0xFFF0F2F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          borderSide: const BorderSide(color: Color(0xFF1a237e), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p14,
        ),
      ),
    );
  }

  // ── Submit Button ─────────────────────────────────
  Widget _buildSubmitButton(bool isLoading, BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : () => _onSubmit(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppPadding.p18),
        decoration: BoxDecoration(
          gradient: isLoading
              ? LinearGradient(
                  colors: [
                    const Color(0xFF1a237e).withOpacity(0.5),
                    const Color(0xFF3949ab).withOpacity(0.5),
                  ],
                )
              : const LinearGradient(
                  colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                ),
          borderRadius: BorderRadius.circular(AppRadius.r16),
          boxShadow: isLoading
              ? null
              : [
                  BoxShadow(
                    color: const Color(0xFF1a237e).withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: AppSize.s24,
                  height: AppSize.s24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.white,
                    size: AppSize.s22,
                  ),
                  const SizedBox(width: AppSize.s10),
                  Text(
                    'Add Product',
                    style: getBoldStyle(
                      color: Colors.white,
                      fontSize: FontSize.s16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ── Banner ────────────────────────────────────────
  Widget _buildBanner(String msg, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppMargin.m16),
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: AppSize.s20),
          const SizedBox(width: AppSize.s12),
          Expanded(
            child: Text(
              msg,
              style: getMediumStyle(color: color, fontSize: FontSize.s13),
            ),
          ),
        ],
      ),
    );
  }
}
