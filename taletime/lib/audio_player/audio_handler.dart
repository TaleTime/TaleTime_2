import "package:audio_service/audio_service.dart";
import "package:just_audio/just_audio.dart";
import "package:logger/logger.dart";

import "../common utils/tale_time_logger.dart";

const _millisecondsInSecond = 1000;
const _seekBackwardSeconds = 10;
const _seekForwardSeconds = 10;

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final logger = TaleTimeLogger.getLogger();

  AudioPlayerHandler() {
    // Pass playback state though
    _audioPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);

    // Listen to completed events
    _audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        pause();
        seek(Duration.zero);
      }
    });
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItemToPlay) async {
    // Update media item to play
    // mediaItem.add(mediaItemToPlay);

    try {
      String url = mediaItemToPlay.extras?["url"];

      // Set source
      Duration? duration = await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));

      mediaItem.add(mediaItemToPlay.copyWith(
        duration: duration
      ));

      _audioPlayer.play();
    } catch (error) {
      logger.log(Level.warning, "Could not load audio source");
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

  @override
  Future<void> seek(Duration position) async {
    _audioPlayer.seek(position);
  }

  Future<void> _seekSeconds(int seconds) async {
    int currentPosition = _audioPlayer.position.inMilliseconds;
    int newPosition = currentPosition + seconds * _millisecondsInSecond;
    int duration = _audioPlayer.duration?.inMilliseconds.toInt() ?? currentPosition;

    if (newPosition < 0) {
      newPosition = 0;
    } else if (newPosition > duration) {
      newPosition = duration;
    }

    _audioPlayer.seek(Duration(milliseconds: newPosition));
  }

  @override
  Future<void> seekBackward(bool begin) async {
    _seekSeconds(-_seekBackwardSeconds);
  }

  @override
  Future<void> seekForward(bool begin) async {
    _seekSeconds(_seekForwardSeconds);
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.rewind,
        if (_audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.fastForward,
        MediaControl.skipToNext
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [1, 2, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_audioPlayer.processingState] ?? AudioProcessingState.idle,
      playing: _audioPlayer.playing,
      updatePosition: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
      speed: _audioPlayer.speed,
      queueIndex: event.currentIndex,
    );
  }
}
