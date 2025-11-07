import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/logo_widget.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeYouTubePlayer();
  }

  void _initializeYouTubePlayer() {
    try {
      // YouTube video ID from URL: https://www.youtube.com/watch?v=f2x4cGuTgnM
      _controller = YoutubePlayerController.fromVideoId(
        videoId: 'f2x4cGuTgnM',
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          enableCaption: true,
          loop: false,
          mute: false,
          playsInline: true,
        ),
      );

      // Set loading to false after a short delay to allow player to initialize
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error initializing video player: $e';
      });
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).colorScheme.primary;
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoWidget(width: 28, height: 28),
            const SizedBox(height: 4),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  purple,
                  purple.withValues(alpha: 0.7),
                  const Color(0xFFE0B0FF),
                ],
              ).createShader(bounds),
              child: const Text(
                'Smart Factory Video',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F0F1E),
        foregroundColor: const Color(0xFFE0B0FF),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.5,
              colors: [
                purple.withValues(alpha: 0.15),
                Colors.transparent,
                const Color(0xFF0A0A0F),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: _errorMessage != null
              ? _buildErrorWidget(context)
              : (_isLoading
                  ? _buildLoadingWidget(context, purple)
                  : _buildVideoPlayer(context)),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: YoutubePlayer(
                  controller: _controller,
                  aspectRatio: 16 / 9,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Smart Factory Training Video',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the video to play',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(BuildContext context, Color purple) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(purple),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            'Loading video...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading video',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _initializeYouTubePlayer();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                // Open YouTube in external browser
                final url = Uri.parse('https://www.youtube.com/watch?v=f2x4cGuTgnM');
                try {
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                } catch (e) {
                  // Handle error silently
                }
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open in YouTube'),
            ),
          ],
        ),
      ),
    );
  }
}
