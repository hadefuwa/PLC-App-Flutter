import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/logo_widget.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    // Use a proper HTML page with YouTube iframe embed
    // This approach works better than direct embed URL
    const htmlContent = '''
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #0A0A0F 0%, #1A1A2E 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            overflow: hidden;
        }
        .video-container {
            position: relative;
            width: 100%;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .video-wrapper {
            position: relative;
            width: 100%;
            max-width: 100%;
            padding-bottom: 56.25%; /* 16:9 aspect ratio */
            height: 0;
        }
        iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: none;
        }
        .loading {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: #E0B0FF;
            font-size: 18px;
            text-align: center;
            z-index: 10;
        }
        .loading::after {
            content: '';
            display: block;
            width: 40px;
            height: 40px;
            margin: 20px auto;
            border: 3px solid #9C27B0;
            border-top-color: transparent;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="video-container">
        <div class="loading">Loading video...</div>
        <div class="video-wrapper">
            <iframe
                id="youtube-player"
                src="https://www.youtube-nocookie.com/embed/2hOTrABIDbg?enablejsapi=1&origin=https://www.youtube-nocookie.com&rel=0&modestbranding=1&playsinline=1&controls=1&showinfo=0&fs=1&cc_load_policy=0&iv_load_policy=3&autoplay=0"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                allowfullscreen
                frameborder="0">
            </iframe>
        </div>
    </div>
    <script>
        const iframe = document.getElementById('youtube-player');
        const loading = document.querySelector('.loading');
        
        iframe.addEventListener('load', function() {
            if (loading) {
                loading.style.display = 'none';
            }
        });
        
        // Handle errors
        window.addEventListener('message', function(event) {
            if (event.data === 'error') {
                if (loading) loading.style.display = 'none';
                document.body.innerHTML = '<div style="color: #ff6b6b; text-align: center; padding: 20px;"><h3>Error Loading Video</h3><p>Please check your internet connection or try again later.</p></div>';
            }
        });
    </script>
</body>
</html>
''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _errorMessage = error.description.isNotEmpty 
                  ? error.description 
                  : 'Failed to load video. The video may not allow embedding.';
            });
          },
        ),
      )
      ..loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).colorScheme.primary;
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoWidget(width: 28, height: 28, glowRadius: 6),
            const SizedBox(width: 10),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  purple,
                  purple.withValues(alpha: 0.7),
                  const Color(0xFFE0B0FF),
                ],
              ).createShader(bounds),
              child: const Text(
                'Matrix TSL Video',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F0F1E),
        foregroundColor: const Color(0xFFE0B0FF),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: purple),
            onPressed: () {
              _controller.reload();
            },
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: Icon(Icons.open_in_new, color: purple),
            onPressed: () {
              // Open video in YouTube app or browser
              _controller.loadRequest(
                Uri.parse('https://www.youtube.com/watch?v=2hOTrABIDbg'),
              );
            },
            tooltip: 'Open in YouTube',
          ),
        ],
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
          child: Stack(
            children: [
              // Video Player - Full screen
              WebViewWidget(controller: _controller),
              // Loading indicator overlay
              if (_isLoading && _errorMessage == null)
                Container(
                  color: Colors.black.withValues(alpha: 0.7),
                  child: Center(
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
                  ),
                ),
              // Error message overlay
              if (_errorMessage != null)
                Container(
                  color: Colors.black.withValues(alpha: 0.8),
                  child: Center(
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
                              _controller.reload();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () {
                              _controller.loadRequest(
                                Uri.parse('https://www.youtube.com/watch?v=2hOTrABIDbg'),
                              );
                            },
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Open in YouTube'),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Note: Some videos may not allow embedding.\nYou can watch it directly on YouTube.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
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
