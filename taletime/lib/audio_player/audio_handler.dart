import "package:audio_service/audio_service.dart";
import "package:audioplayers/audioplayers.dart";

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {

  final AudioPlayer _audioPlayer = AudioPlayer();


  @override
  Future<void> playMediaItem(MediaItem mediaItemToPlay) async {
    // mediaItemToPlay.

    mediaItem.add(mediaItemToPlay);
  }

  @override
  Future<void> play() async {
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [MediaControl.rewind, MediaControl.pause, MediaControl.fastForward],
    ));

    mediaItem.add(MediaItem(
      id: "fooxxx",
      title: "Test Title",
      artUri: Uri.parse("https://placekitten.com/256/256")
    ));

    print("Start playing...");
  }

  @override
  Future<void> pause() async {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      controls: [MediaControl.rewind, MediaControl.play, MediaControl.fastForward],

    ));

    mediaItem.add(MediaItem(
        id: "fooxxx",
        title: "Test Title",
        artUri: Uri.parse("https://placekitten.com/256/256")
    ));

    print("Pause...");
  }


}
