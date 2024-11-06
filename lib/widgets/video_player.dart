import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key});

  @override
  State<VideoPlayerWidget> createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayerController();
  }

  void _initializeVideoPlayerController() {
    _videoPlayerController =
        VideoPlayerController.asset("assets/films/film.mp4");
    _initializeVideoPlayerFuture =
        _videoPlayerController.initialize().then((_) {
      _startVideo();
    });
  }

  void _startVideo() {
    _videoPlayerController.play();
    _videoPlayerController.setLooping(true);
    setState(() {});
  }

  @override
  void dispose() {
    _disposeVideoPlayerController();
    super.dispose();
  }

  void _disposeVideoPlayerController() {
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        return snapshot.hasError
            ? _buildErrorWidget(snapshot.error)
            : snapshot.connectionState == ConnectionState.done
                ? _buildVideoPlayer()
                : _buildLoadingIndicator();
      },
    );
  }

  Widget _buildErrorWidget(Object? error) {
    return Center(child: Text('Error: $error'));
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildVideoPlayer() {
    return SizedBox.expand(
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoPlayerController.value.size.width,
            height: _videoPlayerController.value.size.height,
            child: VideoPlayer(_videoPlayerController),
          ),
        ),
      ),
    );
  }
}
