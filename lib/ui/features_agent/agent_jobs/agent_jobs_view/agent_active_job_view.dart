import 'package:biztidy_mobile_app/ui/features_agent/agent_jobs/agent_jobs_controller/agent_jobs_controller.dart';
import 'package:biztidy_mobile_app/ui/features_agent/agent_jobs/agent_jobs_model/agent_job_model.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AgentActiveJobView extends StatefulWidget {
  const AgentActiveJobView({super.key, required this.job});
  final AgentJobModel job;

  @override
  State<AgentActiveJobView> createState() => _AgentActiveJobViewState();
}

class _AgentActiveJobViewState extends State<AgentActiveJobView> {
  final controller = Get.put(AgentJobsController());

  @override
  void initState() {
    super.initState();
    controller.selectJob(widget.job);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryThemeColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: GetBuilder<AgentJobsController>(
        builder: (_) {
          final job = controller.selectedJob;
          final booking = job?.booking;
          final isInProgress = job?.status == 'in_progress';

          return Scaffold(
            backgroundColor: AppColors.plainWhite,
            appBar: AppBar(
              backgroundColor: AppColors.primaryThemeColor,
              iconTheme: IconThemeData(color: AppColors.plainWhite),
              title: Text(
                'Active Job',
                style: AppStyles.keyStringStyle(18, AppColors.plainWhite),
              ),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Job Info Card ──────────────────────────────────────
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${booking?.service?.name ?? 'Cleaning'} Service',
                          style: AppStyles.regularStringStyle(
                              17, AppColors.fullBlack),
                        ),
                        verticalSpacer(12),
                        _infoRow('Client', booking?.customer?.name ?? '-'),
                        _infoRow('Phone',
                            booking?.customer?.phoneNumber ?? '-'),
                        _infoRow('Address',
                            booking?.locationAddress ?? '-'),
                        _infoRow(
                          'Date & Time',
                          booking?.dateTime != null
                              ? DateFormat('MMM d, y • h:mm a')
                                  .format(booking!.dateTime!)
                              : '-',
                        ),
                        _infoRow(
                          'Payment',
                          booking?.country == 'USA'
                              ? '\$${booking?.service?.usdCost ?? 0}'
                              : '₦${NumberFormat('#,###').format(booking?.service?.baseCost ?? 0)}',
                        ),
                        _infoRow('Rooms', '${booking?.rooms ?? '-'}'),
                        _infoRow(
                            'Duration', '${booking?.duration ?? '-'} hrs'),
                        if (booking?.additionalInfo?.isNotEmpty == true)
                          _infoRow('Notes', booking!.additionalInfo!),
                      ],
                    ),
                  ),
                  verticalSpacer(20),

                  // ── Clock In / Start Job ──────────────────────────────
                  if (!isInProgress) ...[
                    Text(
                      'Step 1: Clock In',
                      style: AppStyles.regularStringStyle(
                          15, AppColors.fullBlack),
                    ),
                    verticalSpacer(8),
                    Text(
                      'When you arrive at the client\'s location, click Start Job to clock in.',
                      style:
                          AppStyles.subStringStyle(13, AppColors.darkGray),
                    ),
                    verticalSpacer(12),
                    controller.showLoading
                        ? loadingWidget()
                        : CustomButton(
                            buttonText: 'Start Job (Clock In)',
                            width: screenWidth(context),
                            color: AppColors.primaryThemeColor,
                            textcolor: AppColors.plainWhite,
                            onPressed: controller.startJob,
                          ),
                  ],

                  // ── Before Photos ─────────────────────────────────────
                  if (isInProgress) ...[
                    _photoSection(
                      title: 'Step 2: Before Photos',
                      subtitle:
                          'Take photos of key areas before cleaning (kitchen, bedroom, living room).',
                      photos: controller.beforePhotoUrls,
                      isBefore: true,
                    ),
                    verticalSpacer(20),

                    // ── After Photos ──────────────────────────────────────
                    _photoSection(
                      title: 'Step 3: After Photos',
                      subtitle:
                          'Take photos of the same areas after cleaning.',
                      photos: controller.afterPhotoUrls,
                      isBefore: false,
                    ),
                    verticalSpacer(28),

                    // ── Complete Job ──────────────────────────────────────
                    Text(
                      'Step 4: Complete Job',
                      style: AppStyles.regularStringStyle(
                          15, AppColors.fullBlack),
                    ),
                    verticalSpacer(8),
                    Text(
                      'Ensure the client is satisfied and after photos are uploaded before completing.',
                      style:
                          AppStyles.subStringStyle(13, AppColors.darkGray),
                    ),
                    verticalSpacer(12),
                    controller.showLoading
                        ? loadingWidget()
                        : CustomButton(
                            buttonText: 'Complete Job (Clock Out)',
                            width: screenWidth(context),
                            color: AppColors.normalGreen,
                            borderColor: AppColors.normalGreen,
                            textcolor: AppColors.plainWhite,
                            onPressed: () =>
                                controller.completeJob(context),
                          ),
                  ],
                  verticalSpacer(40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppColors.primaryThemeColor.withOpacity(0.2)),
      ),
      child: child,
    );
  }

  Widget _infoRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$key:',
              style: AppStyles.subStringStyle(13, AppColors.darkGray),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style:
                  AppStyles.regularStringStyle(13, AppColors.fullBlack),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoSection({
    required String title,
    required String subtitle,
    required List<String> photos,
    required bool isBefore,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              AppStyles.regularStringStyle(15, AppColors.fullBlack),
        ),
        verticalSpacer(4),
        Text(
          subtitle,
          style: AppStyles.subStringStyle(13, AppColors.darkGray),
        ),
        verticalSpacer(12),
        if (photos.isNotEmpty)
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    photos[i],
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) =>
                        progress == null
                            ? child
                            : const SizedBox(
                                width: 90,
                                height: 90,
                                child: Center(
                                    child: CircularProgressIndicator()),
                              ),
                  ),
                ),
              ),
            ),
          ),
        verticalSpacer(10),
        GetBuilder<AgentJobsController>(
          builder: (c) => c.uploadingPhotos
              ? loadingWidget()
              : OutlinedButton.icon(
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: Text(
                      photos.isEmpty ? 'Take Photo' : 'Add Another'),
                  onPressed: () =>
                      c.pickAndUploadPhoto(isBefore: isBefore),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryThemeColor,
                    side: BorderSide(
                        color: AppColors.primaryThemeColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
        ),
      ],
    );
  }
}
