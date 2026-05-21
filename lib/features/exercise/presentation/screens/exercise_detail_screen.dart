// lib/features/exercise/presentation/screens/exercise_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../domain/models/exercise_model.dart';

/// Detailed exercise view.
///
/// videoUrl logic:
///   'yt:VIDEO_ID'  → embedded YouTube player
///   'assets/...'  → local MP4 via VideoPlayer
///   ''            → GIF only (or placeholder)
class ExerciseDetailScreen extends StatefulWidget {
  const ExerciseDetailScreen({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  final ExerciseModel exercise;

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  // Local video
  VideoPlayerController? _videoController;
  bool _isPlaying = false;
  bool _showControls = true;

  // YouTube
  YoutubePlayerController? _ytController;

  // GIF
  bool _gifLoaded = false;
  bool _gifError = false;

  // ── helpers ────────────────────────────────────────────────────────────────

  bool get _isYouTube => widget.exercise.videoUrl.startsWith('yt:');
  bool get _isLocalVideo =>
      widget.exercise.videoUrl.startsWith('assets/') &&
      widget.exercise.videoUrl.endsWith('.mp4');
  bool get _hasGif =>
      widget.exercise.gifUrl != null &&
      widget.exercise.gifUrl!.isNotEmpty &&
      widget.exercise.gifUrl!.startsWith('assets/');

  String get _youtubeId => widget.exercise.videoUrl.replaceFirst('yt:', '');

  // ── lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    if (_isYouTube) {
      _initYouTube();
    } else if (_isLocalVideo) {
      _initLocalVideo();
    }
  }

  void _initYouTube() {
    _ytController = YoutubePlayerController(
      initialVideoId: _youtubeId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
        loop: false,
      ),
    );
  }

  void _initLocalVideo() {
    try {
      _videoController =
          VideoPlayerController.asset(widget.exercise.videoUrl)
            ..addListener(() {
              if (mounted) {
                setState(() {
                  _isPlaying =
                      _videoController?.value.isPlaying ?? false;
                });
              }
            })
            ..initialize().then((_) {
              if (mounted) setState(() {});
            });
    } catch (e) {
      debugPrint('Video init error: $e');
    }
  }

  void _toggleLocalPlayPause() {
    if (_videoController == null) return;
    _isPlaying
        ? _videoController!.pause()
        : _videoController!.play();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _ytController?.dispose();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return YoutubePlayerBuilder(
          // YoutubePlayerBuilder is required to handle fullscreen properly.
          // If there's no YouTube video it still works fine as a wrapper.
          player: YoutubePlayer(
            controller: _ytController ??
                YoutubePlayerController(
                  initialVideoId: '',
                  flags: const YoutubePlayerFlags(autoPlay: false),
                ),
            showVideoProgressIndicator: true,
            progressIndicatorColor: AppColors.primary,
          ),
          builder: (context, player) {
            return Scaffold(
              backgroundColor: AppColors.textPrimary,
              appBar: AppBar(
                backgroundColor: AppColors.textPrimary,
                iconTheme:
                    const IconThemeData(color: AppColors.surface),
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.language,
                        color: AppColors.surface),
                    onPressed: () => showLanguageSelector(context),
                    tooltip:
                        'Select Language / اختر اللغة / Sélectionner la langue',
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ========== MEDIA AREA ==========
                    _buildMediaArea(player),

                    // ========== CONTENT =============
                    Container(
                      color: AppColors.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              widget.exercise.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),

                            // Info chips
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _InfoChip(
                                  icon: Icons.schedule,
                                  label:
                                      '${widget.exercise.duration} min',
                                  color: AppColors.primary,
                                ),
                                _InfoChip(
                                  icon: Icons.repeat,
                                  label:
                                      '${widget.exercise.repetitions}x',
                                  color: AppColors.primary,
                                ),
                                _InfoChip(
                                  icon: Icons.calendar_today,
                                  label: widget.exercise.frequency,
                                  color: AppColors.primary,
                                ),
                                _InfoChip(
                                  icon: _isYouTube
                                      ? Icons.smart_display
                                      : Icons.gif,
                                  label: _isYouTube
                                      ? 'YouTube'
                                      : (_hasGif ? 'GIF' : 'Vidéo'),
                                  color: _isYouTube
                                      ? Colors.red
                                      : AppColors.primary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Instructions
                            _SectionHeader('Instructions'),
                            const SizedBox(height: 12),
                            Text(
                              widget.exercise.description,
                              style:
                                  Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 24),

                            // Benefits
                            _SectionHeader('Bénéfices'),
                            const SizedBox(height: 12),
                            ...widget.exercise.benefits.map((b) =>
                                _BulletCheck(text: b)),
                            const SizedBox(height: 24),

                            // Precautions
                            _SectionHeader(
                                '⚠️ Précautions Importantes'),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.warning.withOpacity(0.1),
                                border: Border.all(
                                    color: AppColors.warning
                                        .withOpacity(0.3),
                                    width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: widget.exercise.precautions
                                    .map((p) => _BulletDot(
                                        text: p,
                                        color: AppColors.warning))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Progress tracker
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColors.primary
                                        .withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      color: AppColors.primary,
                                      size: 24),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Marquer comme complété',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                  color:
                                                      AppColors.primary),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Suivez votre progrès',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  color: AppColors
                                                      .textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Checkbox(
                                    value: false,
                                    onChanged: (_) {},
                                    activeColor: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Download button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        'Guide téléchargé avec succès!'),
                                    backgroundColor: AppColors.success,
                                  ));
                                },
                                icon: const Icon(Icons.download),
                                label: const Text(
                                    'Télécharger le Guide PDF'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                  backgroundColor: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── media area ─────────────────────────────────────────────────────────────

  Widget _buildMediaArea(Widget youtubePlayer) {
    // 1) YouTube
    if (_isYouTube && _ytController != null) {
      return youtubePlayer;
    }

    // 2) GIF (shown before local video for quick preview)
    if (_hasGif && !_gifError) {
      return SizedBox(
        height: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              widget.exercise.gifUrl!,
              height: 300,
              width: double.infinity,
              fit: BoxFit.contain,
              frameBuilder:
                  (context, child, frame, wasSynchronouslyLoaded) {
                if (frame != null && !_gifLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _gifLoaded = true);
                  });
                }
                return child;
              },
              errorBuilder: (_, __, ___) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _gifError = true);
                });
                return _buildPlaceholder();
              },
            ),
            // Loading spinner
            if (!_gifLoaded)
              Container(
                color: AppColors.textPrimary.withOpacity(0.6),
                child: const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primary),
                ),
              ),
            // GIF badge
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('GIF',
                    style: TextStyle(
                      color: AppColors.surface,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    )),
              ),
            ),
            // Duration badge
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${widget.exercise.duration} min',
                  style: const TextStyle(
                      color: AppColors.surface,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 3) Local MP4
    if (_isLocalVideo &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      return GestureDetector(
        onTap: () =>
            setState(() => _showControls = !_showControls),
        child: Container(
          color: AppColors.textPrimary,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
              if (_showControls)
                GestureDetector(
                  onTap: _toggleLocalPlayPause,
                  child: Icon(
                    _isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    size: 80,
                    color: AppColors.surface,
                  ),
                ),
              if (_showControls)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _formatDuration(
                          widget.exercise.videoDuration),
                      style: const TextStyle(
                          color: AppColors.surface,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // 4) Placeholder
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 300,
      color: AppColors.textPrimary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gif_box_outlined,
                size: 80,
                color: AppColors.surface.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'Démonstration',
              style: TextStyle(
                  color: AppColors.surface.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez le fichier dans assets/exercises/',
              style: TextStyle(
                  color: AppColors.surface.withOpacity(0.5),
                  fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// ── small reusable widgets ───────────────────────────────────────────────────

class _BulletCheck extends StatelessWidget {
  const _BulletCheck({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
                color: AppColors.levelGood, shape: BoxShape.circle),
            child: const Icon(Icons.check,
                size: 14, color: AppColors.surface),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _BulletDot extends StatelessWidget {
  const _BulletDot({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•',
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(
      {required this.icon,
      required this.label,
      required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold, color: AppColors.primary),
    );
  }
}