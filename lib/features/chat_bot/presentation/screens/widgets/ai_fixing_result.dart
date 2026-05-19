import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/chat_bot/data/models/ai_fixing_result_model.dart';

import '../../../../../core/utils/color_maanger.dart';

class AiFixingResult extends StatelessWidget {
  final AiFixingResultModel result;

  const AiFixingResult({super.key, required this.result});

  Uint8List _decodeBase64Image(String base64String) {
    String cleanBase64 = base64String
        .replaceAll('\n', '')
        .replaceAll('\r', '')
        .replaceAll(' ', '');

    if (cleanBase64.contains(',')) {
      cleanBase64 = cleanBase64.split(',').last;
    }

    while (cleanBase64.length % 4 != 0) {
      cleanBase64 += '=';
    }

    return base64Decode(cleanBase64);
  }

  @override
  Widget build(BuildContext context) {
    // ✅ لو مش صورة عربية اعرض رسالة خطأ
    if (!result.isCarImage) {
      return _buildNotCarMessage();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Analyzed Image ───────────────────────
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          child: Stack(
            children: [
              result.imageBase64.isNotEmpty
                  ? Image.memory(
                      _decodeBase64Image(result.imageBase64),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildImageError(),
                    )
                  : _buildImageError(),

              // ── AI Badge ──────────────────────
              Positioned(
                bottom: AppSize.s8,
                left: AppSize.s8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p8,
                    vertical: AppPadding.p4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.primary.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(AppRadius.r8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_fix_high,
                        color: ColorManager.white,
                        size: AppSize.s14,
                      ),
                      const SizedBox(width: AppSize.s4),
                      Text(
                        "AI Analyzed",
                        style: getMediumStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSize.s16),

        // ── Stats Row ────────────────────────────
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.car_crash_outlined,
                value: "${result.totalScratches}",
                label: "Total Damages",
                color: ColorManager.error,
              ),
            ),
            const SizedBox(width: AppSize.s12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.attach_money,
                value: "${result.totalEstimatedCost.toStringAsFixed(0)}",
                label: "Total Cost (EGP)",
                color: ColorManager.primary,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSize.s16),

        // ── Detections List ──────────────────────
        if (result.detections.isNotEmpty) ...[
          Text(
            "Detected Damages",
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(height: AppSize.s8),
          ...result.detections.map(
            (detection) => Container(
              margin: const EdgeInsets.only(bottom: AppMargin.m8),
              padding: const EdgeInsets.all(AppPadding.p12),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(AppRadius.r12),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.grey.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // ── Icon ──────────────────────
                  Container(
                    padding: const EdgeInsets.all(AppPadding.p8),
                    decoration: BoxDecoration(
                      color: ColorManager.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                    ),
                    child: const Icon(
                      Icons.warning_amber_outlined,
                      color: ColorManager.error,
                      size: AppSize.s20,
                    ),
                  ),

                  const SizedBox(width: AppSize.s12),

                  // ── Info ──────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Class Name
                        Text(
                          detection.className,
                          style: getBoldStyle(
                            color: ColorManager.textPrimary,
                            fontSize: FontSize.s14,
                          ),
                        ),

                        const SizedBox(height: AppSize.s4),

                        // Confidence & Severity
                        Row(
                          children: [
                            Text(
                              "Confidence: ${(detection.confidence * 100).toStringAsFixed(1)}%",
                              style: getRegularStyle(
                                color: ColorManager.textSecondary,
                                fontSize: FontSize.s12,
                              ),
                            ),
                            const SizedBox(width: AppSize.s8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppPadding.p4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getSeverityColor(detection.severity),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.r4,
                                ),
                              ),
                              child: Text(
                                detection.severity,
                                style: getMediumStyle(
                                  color: _getSeverityColor(
                                    detection.severity,
                                  ).withOpacity(0.1),
                                  fontSize: FontSize.s10,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSize.s4),

                        // Estimated Cost
                        Text(
                          "Est. Cost: EGP ${detection.estimatedCost.toStringAsFixed(0)}",
                          style: getMediumStyle(
                            color: ColorManager.primary,
                            fontSize: FontSize.s12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Confidence Bar ────────────
                  Column(
                    children: [
                      SizedBox(
                        width: AppSize.s60,
                        child: LinearProgressIndicator(
                          value: detection.confidence,
                          backgroundColor: ColorManager.lightGrey,
                          color: detection.confidence > 0.7
                              ? ColorManager.error
                              : ColorManager.warning,
                          borderRadius: BorderRadius.circular(AppRadius.r4),
                        ),
                      ),
                      const SizedBox(height: AppSize.s4),
                      Text(
                        "${(detection.confidence * 100).toStringAsFixed(0)}%",
                        style: getBoldStyle(
                          color: detection.confidence > 0.7
                              ? ColorManager.error
                              : ColorManager.warning,
                          fontSize: FontSize.s10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],

        const SizedBox(height: AppSize.s16),

        // ── Status Card ──────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppPadding.p16),
          decoration: BoxDecoration(
            color: result.success
                ? ColorManager.success.withOpacity(0.1)
                : ColorManager.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(
              color: result.success
                  ? ColorManager.success.withOpacity(0.3)
                  : ColorManager.error.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                result.success
                    ? Icons.check_circle_outline
                    : Icons.error_outline,
                color: result.success
                    ? ColorManager.success
                    : ColorManager.error,
                size: AppSize.s24,
              ),
              const SizedBox(width: AppSize.s12),
              Expanded(
                child: Text(
                  result.success
                      ? "Found ${result.totalScratches} damage(s) — Est. total repair cost: EGP ${result.totalEstimatedCost.toStringAsFixed(0)}"
                      : "Could not analyze the image. Please try again.",
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s12,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSize.s16),
      ],
    );
  }

  // ── Helper: Severity Color ────────────────────────
  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'severe':
      case 'high':
        return ColorManager.error;
      case 'moderate':
      case 'medium':
        return ColorManager.warning;
      case 'minor':
      case 'low':
        return ColorManager.success;
      default:
        return ColorManager.grey;
    }
  }

  // ── Helper: Image Error ───────────────────────────
  Widget _buildImageError() {
    return Container(
      height: AppSize.s200,
      width: double.infinity,
      color: ColorManager.lightGrey,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: ColorManager.grey,
          size: AppSize.s60,
        ),
      ),
    );
  }

  // ── Helper: Stat Card ─────────────────────────────
  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSize.s32),
          const SizedBox(height: AppSize.s8),
          Text(
            value,
            style: getBoldStyle(color: color, fontSize: FontSize.s24),
          ),
          Text(
            label,
            style: getRegularStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotCarMessage() {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppPadding.p20),
            decoration: BoxDecoration(
              color: ColorManager.warning.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_car_outlined,
              color: ColorManager.warning,
              size: AppSize.s60,
            ),
          ),

          const SizedBox(height: AppSize.s16),

          Text(
            "Not a Car Image!",
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s20,
            ),
          ),

          const SizedBox(height: AppSize.s8),

          Text(
            "Please send a clear photo of a car to analyze damages. The image you sent doesn't appear to contain a car.",
            style: getRegularStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s14,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSize.s24),

          // ── Tips ──────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppPadding.p16),
            decoration: BoxDecoration(
              color: ColorManager.primary,
              borderRadius: BorderRadius.circular(AppRadius.r12),
              border: Border.all(color: ColorManager.primary),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tips for best results:",
                  style: getMediumStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s14,
                  ),
                ),
                const SizedBox(height: AppSize.s8),
                _buildTip("📸 Take a clear photo of the damaged area"),
                _buildTip("🚗 Make sure the car is visible in the image"),
                _buildTip("💡 Use good lighting for better detection"),
                _buildTip("📐 Get close to the damaged area"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.p4),
      child: Text(
        tip,
        style: getRegularStyle(
          color: ColorManager.textSecondary,
          fontSize: FontSize.s12,
        ),
      ),
    );
  }
}
