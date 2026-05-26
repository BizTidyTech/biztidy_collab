import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

/// Opens a full-screen viewer for a single photo or video URL.
/// Call via [JobMediaViewer.open].
class JobMediaViewer extends StatelessWidget {
  const JobMediaViewer({super.key, required this.url, required this.isVideo});
  final String url;
  final bool isVideo;

  static void open(BuildContext context, String url, {bool isVideo = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobMediaViewer(url: url, isVideo: isVideo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: isVideo
            ? _VideoPlayerWidget(url: url)
            : PhotoView(imageProvider: NetworkImage(url)),
      ),
    );
  }
}

// ── Inline video player ──────────────────────────────────────────────────────
class _VideoPlayerWidget extends StatefulWidget {
  const _VideoPlayerWidget({required this.url});
  final String url;

  @override
  State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _ctrl;
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _ctrl = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) setState(() => _initialized = true);
        _ctrl.play();
      }).catchError((_) {
        if (mounted) setState(() => _error = true);
      });
    _ctrl.setLooping(false);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return const Center(
        child: Text('Could not load video',
            style: TextStyle(color: Colors.white70)),
      );
    }
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
    return Center(
      child: AspectRatio(
        aspectRatio: _ctrl.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_ctrl),
            GestureDetector(
              onTap: () => setState(() {
                _ctrl.value.isPlaying ? _ctrl.pause() : _ctrl.play();
              }),
              child: AnimatedOpacity(
                opacity: _ctrl.value.isPlaying ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable media grid widget ────────────────────────────────────────────────
/// Shows a scrollable horizontal row of photo/video thumbnails.
/// Used by both the client booking details and admin quality screens.
class JobMediaGrid extends StatelessWidget {
  const JobMediaGrid({
    super.key,
    required this.photoUrls,
    required this.videoUrls,
    required this.label,
    required this.labelColor,
  });

  final List<String> photoUrls;
  final List<String> videoUrls;
  final String label;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    final allMedia = [
      ...photoUrls.map((u) => (url: u, isVideo: false)),
      ...videoUrls.map((u) => (url: u, isVideo: true)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label pill ────────────────────────────────────────────────────
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: labelColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: labelColor,
            ),
          ),
        ),
        const SizedBox(height: 10),
        allMedia.isEmpty
            ? Container(
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'No media yet',
                    style: AppStyles.subStringStyle(
                        13, AppColors.darkGray),
                  ),
                ),
              )
            : SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allMedia.length,
                  itemBuilder: (_, i) {
                    final item = allMedia[i];
                    return GestureDetector(
                      onTap: () => JobMediaViewer.open(
                        context,
                        item.url,
                        isVideo: item.isVideo,
                      ),
                      child: Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black12,
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: item.isVideo
                                  ? _VideoThumbnail(url: item.url)
                                  : Image.network(
                                      item.url,
                                      fit: BoxFit.cover,
                                      cacheWidth: 200,
                                      loadingBuilder: (_, child, progress) =>
                                          progress == null
                                              ? child
                                              : const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 2)),
                                      errorBuilder: (_, __, ___) => const Icon(
                                          Icons.broken_image_outlined,
                                          color: Colors.grey),
                                    ),
                            ),
                            if (item.isVideo)
                              const Center(
                                child: Icon(Icons.play_circle_fill_rounded,
                                    color: Colors.white, size: 32),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}

// ── Video thumbnail using VideoPlayerController ───────────────────────────────
class _VideoThumbnail extends StatefulWidget {
  const _VideoThumbnail({required this.url});
  final String url;

  @override
  State<_VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<_VideoThumbnail> {
  late VideoPlayerController _ctrl;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _ctrl = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) setState(() => _ready = true);
      });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return Container(
          color: Colors.black26,
          child: const Center(
              child: CircularProgressIndicator(
                  strokeWidth: 1.5, color: Colors.white70)));
    }
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _ctrl.value.size.width,
        height: _ctrl.value.size.height,
        child: VideoPlayer(_ctrl),
      ),
    );
  }
}
