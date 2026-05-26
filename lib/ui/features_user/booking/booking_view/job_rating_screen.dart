// ignore_for_file: use_build_context_synchronously
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/bookings_list_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Full-screen rating bottom sheet.
/// Call via [JobRatingSheet.show] — returns true if the user submitted.
class JobRatingSheet extends StatefulWidget {
  const JobRatingSheet({super.key, required this.booking});
  final BookingModel booking;

  static Future<bool> show(BuildContext context, BookingModel booking) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => JobRatingSheet(booking: booking),
    );
    return result == true;
  }

  @override
  State<JobRatingSheet> createState() => _JobRatingSheetState();
}

class _JobRatingSheetState extends State<JobRatingSheet>
    with SingleTickerProviderStateMixin {
  final _ctrl = Get.find<BookingsListController>();
  final _reviewCtrl = TextEditingController();
  double _selectedRating = 0;
  late AnimationController _bounceCtrl;

  static const _labels = {
    1: 'Poor',
    2: 'Fair',
    3: 'Good',
    4: 'Great',
    5: 'Excellent!',
  };

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _reviewCtrl.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  void _onStarTap(int star) {
    setState(() => _selectedRating = star.toDouble());
    _bounceCtrl.forward(from: 0);
  }

  Future<void> _submit() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a star rating')),
      );
      return;
    }
    final success = await _ctrl.submitRating(
      booking: widget.booking,
      rating: _selectedRating,
      review: _reviewCtrl.text,
    );
    if (success && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final service = widget.booking.service?.name ?? 'Cleaning';
    final date = widget.booking.dateTime != null
        ? DateFormat('MMMM d, y').format(widget.booking.dateTime!)
        : '';

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: GetBuilder<BookingsListController>(
              builder: (_) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Drag handle ────────────────────────────────────────
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  verticalSpacer(20),

                  // ── Icon ───────────────────────────────────────────────
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primaryThemeColor
                          .withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cleaning_services_rounded,
                      color: AppColors.primaryThemeColor,
                      size: 32,
                    ),
                  ),
                  verticalSpacer(16),

                  // ── Headline ───────────────────────────────────────────
                  Text(
                    'How was your clean?',
                    style: AppStyles.keyStringStyle(
                        20, AppColors.fullBlack),
                  ),
                  verticalSpacer(6),
                  Text(
                    '$service • $date',
                    style: AppStyles.subStringStyle(
                        14, AppColors.darkGray),
                  ),
                  verticalSpacer(24),

                  // ── Star selector ──────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final star = i + 1;
                      final filled = star <= _selectedRating;
                      return GestureDetector(
                        onTap: () => _onStarTap(star),
                        child: AnimatedBuilder(
                          animation: _bounceCtrl,
                          builder: (_, child) {
                            final scale = filled
                                ? 1.0 +
                                    0.25 *
                                        (1 - _bounceCtrl.value)
                                            .clamp(0.0, 1.0)
                                : 1.0;
                            return Transform.scale(
                                scale: scale, child: child);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6),
                            child: Icon(
                              filled
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: filled
                                  ? const Color(0xFFF59E0B)
                                  : AppColors.lightGray,
                              size: 44,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  verticalSpacer(10),

                  // ── Label ──────────────────────────────────────────────
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _selectedRating > 0
                        ? Text(
                            _labels[_selectedRating.toInt()] ?? '',
                            key: ValueKey(_selectedRating),
                            style: AppStyles.regularStringStyle(
                              16,
                              _selectedRating >= 4
                                  ? AppColors.normalGreen
                                  : _selectedRating >= 3
                                      ? AppColors.deepBlue
                                      : AppColors.coolRed,
                            ),
                          )
                        : Text(
                            'Tap a star to rate',
                            key: const ValueKey('prompt'),
                            style: AppStyles.subStringStyle(
                                15, AppColors.lightGray),
                          ),
                  ),
                  verticalSpacer(20),

                  // ── Review text field ──────────────────────────────────
                  TextField(
                    controller: _reviewCtrl,
                    maxLines: 3,
                    maxLength: 200,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText:
                          'Share details (optional) — what went well, '
                          'what could improve?',
                      hintStyle: AppStyles.subStringStyle(
                          13, AppColors.lightGray),
                      filled: true,
                      fillColor: const Color(0xFFF5F6FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(14),
                      counterStyle: AppStyles.subStringStyle(
                          11, AppColors.darkGray),
                    ),
                    style: AppStyles.subStringStyle(
                        14, AppColors.fullBlack),
                  ),
                  verticalSpacer(20),

                  // ── Submit / cancel ────────────────────────────────────
                  _ctrl.ratingLoading
                      ? loadingWidget()
                      : CustomButton(
                          buttonText: 'Submit Rating',
                          width: double.infinity,
                          onPressed: _submit,
                        ),
                  verticalSpacer(8),
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      'Maybe later',
                      style: AppStyles.subStringStyle(
                          14, AppColors.darkGray),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
