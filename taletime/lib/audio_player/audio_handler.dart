import "package:audio_service/audio_service.dart";
import "package:just_audio/just_audio.dart";

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayerHandler() {
    // Pass playback state though
    _audioPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItemToPlay) async {
    // Update media item to play
    mediaItem.add(mediaItemToPlay);

    try {
      String url = mediaItemToPlay.extras?["url"];

      // Set source
      Duration? duration = await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));

      mediaItem.add(mediaItem.value?.copyWith(
        duration: duration
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
    _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    _audioPlayer.pause();
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_audioPlayer.processingState]!,
      playing: _audioPlayer.playing,
      updatePosition: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
      speed: _audioPlayer.speed,
      queueIndex: event.currentIndex,
    );
  }
}
