import "package:audio_service/audio_service.dart";
import "package:audioplayers/audioplayers.dart";

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayerHandler() {
    _initCallbacks();
  }

  void _initCallbacks() {
    // Listen to duration change
    _audioPlayer.onDurationChanged.listen((duration) {
      mediaItem.add(mediaItem.value?.copyWith(
        duration: duration,
      ));
    });

    // Listen to play / pause
    _audioPlayer.onPlayerStateChanged.listen((playerState) {
      playbackState.add(playbackState.value.copyWith(
        playing: playerState == PlayerState.playing,
      ));
    });
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItemToPlay) async {
    // Update media item to play
    mediaItem.add(mediaItemToPlay);

    try {
      String url = mediaItemToPlay.extras?["url"];

      // Set source
      await _audioPlayer.setSource(UrlSource(url));

      playbackState.add(playbackState.value.copyWith(
        processingState: AudioProcessingState.ready,
        updatePosition: Duration.zero,
      ));
    } catch (error) {
      // Set error message
      playbackState.add(playbackState.value.copyWith(
        errorMessage: "Could not play audio",
      ));

      print(error);
    }
  }

  @override
  Future<void> play() async {
    await _audioPlayer.resume();
    Duration? pos = await _audioPlayer.getCurrentPosition();

    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [
        MediaControl.rewind,
        MediaControl.pause,
        MediaControl.fastForward
      ],
      updatePosition: pos ?? Duration.zero,
    ));

    print("play...");
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
    Duration? pos = await _audioPlayer.getCurrentPosition();

    playbackState.add(playbackState.value.copyWith(
      playing: false,
      controls: [
        MediaControl.rewind,
        MediaControl.play,
        MediaControl.fastForward
      ],
      updatePosition: pos ?? Duration.zero,
    ));

    mediaItem.add(MediaItem(
        id: "fooxxx",
        title: "Test Title",
        artUri: Uri.parse("https://placekitten.com/256/256")));

    print("Pause...");
  }
}
