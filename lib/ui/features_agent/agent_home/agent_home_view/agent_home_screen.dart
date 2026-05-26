// ignore_for_file: prefer_const_constructors
import 'package:biztidy_mobile_app/ui/features_agent/agent_home/agent_home_controller/agent_home_controller.dart';
import 'package:biztidy_mobile_app/ui/features_agent/agent_jobs/agent_jobs_model/agent_job_model.dart';
import 'package:biztidy_mobile_app/ui/features_agent/agent_jobs/agent_jobs_view/agent_active_job_view.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AgentHomeScreen extends StatefulWidget {
  const AgentHomeScreen({super.key});

  @override
  State<AgentHomeScreen> createState() => _AgentHomeScreenState();
}

class _AgentHomeScreenState extends State<AgentHomeScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(AgentHomeController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryThemeColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.plainWhite,
      ),
      child: GetBuilder<AgentHomeController>(
        builder: (_) {
          return Scaffold(
            backgroundColor: AppColors.plainWhite,
            appBar: AppBar(
              backgroundColor: AppColors.primaryThemeColor,
              automaticallyImplyLeading: false,
              elevation: 0,
              title: Text(
                'BizTidy Agent',
                style: AppStyles.keyStringStyle(20, AppColors.plainWhite),
              ),
              actions: [
                IconButton(
                  icon:
                      Icon(Icons.logout, color: AppColors.plainWhite, size: 22),
                  onPressed: () => controller.signOut(context),
                ),
              ],
            ),
            body: controller.showLoading
                ? loadingWidget()
                : Column(
                    children: [
                      _headerCard(),
                      _tabBar(),
                      Expanded(child: _tabContent()),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.primaryThemeColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.plainWhite,
                child: Icon(Icons.person,
                    color: AppColors.primaryThemeColor, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.agentData?.name ?? 'Agent',
                      style: AppStyles.keyStringStyle(18, AppColors.plainWhite),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star,
                            color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${(controller.agentData?.rating ?? 5.0).toStringAsFixed(1)} rating',
                          style: AppStyles.subStringStyle(
                              13, AppColors.plainWhite),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Online/Offline toggle
              GestureDetector(
                onTap: controller.toggleOnlineStatus,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: controller.isOnline
                        ? AppColors.normalGreen
                        : AppColors.darkGray,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.plainWhite,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        controller.isOnline ? 'Online' : 'Offline',
                        style: AppStyles.subStringStyle(
                            13, AppColors.plainWhite),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          verticalSpacer(20),
          // Stats row
          Row(
            children: [
              _statChip(
                Icons.check_circle_outline,
                '${controller.agentData?.totalJobsCompleted ?? 0}',
                'Jobs Done',
              ),
              const SizedBox(width: 12),
              _statChip(
                Icons.account_balance_wallet_outlined,
                '₦${NumberFormat('#,###').format(controller.agentData?.totalEarnings ?? 0)}',
                'Total Earned',
              ),
              const SizedBox(width: 12),
              _statChip(
                Icons.work_outline,
                '${controller.pendingJobs.length}',
                'Pending',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.plainWhite.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.plainWhite, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style:
                  AppStyles.keyStringStyle(14, AppColors.plainWhite),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style:
                  AppStyles.subStringStyle(11, AppColors.plainWhite),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      color: AppColors.plainWhite,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primaryThemeColor,
        unselectedLabelColor: AppColors.darkGray,
        indicatorColor: AppColors.primaryThemeColor,
        labelStyle: AppStyles.regularStringStyle(13, AppColors.primaryThemeColor),
        tabs: [
          Tab(text: 'New Jobs (${controller.pendingJobs.length})'),
          Tab(text: 'Active (${controller.activeJobs.length})'),
          Tab(text: 'Completed'),
        ],
      ),
    );
  }

  Widget _tabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _jobsList(controller.pendingJobs, isPending: true),
        _jobsList(controller.activeJobs, isActive: true),
        _jobsList(controller.completedJobs),
      ],
    );
  }

  Widget _jobsList(List<AgentJobModel> jobs,
      {bool isPending = false, bool isActive = false}) {
    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined,
                size: 56, color: AppColors.darkGray),
            verticalSpacer(12),
            Text(
              isPending
                  ? 'No new jobs right now'
                  : isActive
                      ? 'No active jobs'
                      : 'No completed jobs yet',
              style: AppStyles.subStringStyle(15, AppColors.darkGray),
            ),
            if (isPending && !controller.isOnline) ...[
              verticalSpacer(8),
              Text(
                'Go online to receive jobs',
                style: AppStyles.subStringStyle(13, AppColors.darkGray),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return _jobCard(job,
            isPending: isPending, isActive: isActive);
      },
    );
  }

  Widget _jobCard(AgentJobModel job,
      {bool isPending = false, bool isActive = false}) {
    final booking = job.booking;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${booking?.service?.name ?? 'Cleaning'} Service',
                    style: AppStyles.regularStringStyle(
                        15, AppColors.fullBlack),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _statusBadge(job.status ?? 'pending'),
              ],
            ),
            verticalSpacer(8),
            _jobInfoRow(Icons.person_outline,
                booking?.customer?.name ?? 'Client'),
            verticalSpacer(4),
            _jobInfoRow(Icons.location_on_outlined,
                booking?.locationAddress ?? 'Address not set'),
            verticalSpacer(4),
            _jobInfoRow(
              Icons.calendar_today_outlined,
              booking?.dateTime != null
                  ? DateFormat('MMM d, y • h:mm a')
                      .format(booking!.dateTime!)
                  : 'Date not set',
            ),
            verticalSpacer(4),
            _jobInfoRow(
              Icons.payments_outlined,
              booking?.country == 'USA'
                  ? '\$${booking?.service?.usdCost ?? 0}'
                  : '₦${NumberFormat('#,###').format(booking?.service?.baseCost ?? 0)}',
            ),
            if (isPending) ...[
              verticalSpacer(14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          controller.declineJob(job),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.coolRed,
                        side: BorderSide(color: AppColors.coolRed),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.acceptJob(job),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryThemeColor,
                        foregroundColor: AppColors.plainWhite,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ],
            if (isActive) ...[
              verticalSpacer(14),
              SizedBox(
                width: screenWidth(context),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Open Active Job'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AgentActiveJobView(job: job),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryThemeColor,
                    foregroundColor: AppColors.plainWhite,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _jobInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.darkGray),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: AppStyles.subStringStyle(13, AppColors.darkGray),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    String label;
    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = 'New';
        break;
      case 'accepted':
        color = Colors.blue;
        label = 'Accepted';
        break;
      case 'in_progress':
        color = AppColors.primaryThemeColor;
        label = 'In Progress';
        break;
      case 'completed':
        color = AppColors.normalGreen;
        label = 'Completed';
        break;
      default:
        color = AppColors.darkGray;
        label = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: AppStyles.subStringStyle(11, color),
      ),
    );
  }
}
