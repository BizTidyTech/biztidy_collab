import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebDataView extends StatefulWidget {
  final String title;
  final String url;
  const WebDataView({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<WebDataView> createState() => _WebDataViewState();
}

class _WebDataViewState extends State<WebDataView> {
  late final WebViewController _controller;
  double _loadingProgress = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100;
              _isLoading = progress < 100;
            });
          },
          onPageFinished: (_) {
            setState(() {
              _isLoading = false;
              _loadingProgress = 1;
            });
          },
          onNavigationRequest: (_) => NavigationDecision.navigate,
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : AppColors.deepBlue;
    final divider = isDark ? Colors.white12 : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: surface,
        surfaceTintColor: surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: textPrimary),
        ),
        title: Text(
          widget.title,
          style: AppStyles.keyStringStyle(17, textPrimary),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoading)
                LinearProgressIndicator(
                  value: _loadingProgress == 0 ? null : _loadingProgress,
                  minHeight: 2,
                  backgroundColor: Colors.transparent,
                  color: AppColors.primaryThemeColor,
                )
              else
                Divider(height: 1, thickness: 1, color: divider),
            ],
          ),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}

void goToWebViewPage(
  BuildContext context, {
  required String title,
  required String url,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => WebDataView(title: title, url: url),
    ),
  );
}