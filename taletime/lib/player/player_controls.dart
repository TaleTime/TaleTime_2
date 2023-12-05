import "package:audio_service/audio_service.dart";
import "package:flutter/material.dart";
import "package:taletime/main.dart";

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audioHandler.playbackState,
      builder: (context, playbackStateSnapshot) {
        // Get player state or reasonable defaults
        PlaybackState playbackState = playbackStateSnapshot.data ??
            PlaybackState(
              playing: false,
              processingState: AudioProcessingState.idle,
            );

        // Whether the story is fully loaded and the player is enabled
        bool playerEnabled =
            playbackState.processingState == AudioProcessingState.ready ||
                playbackState.processingState == AudioProcessingState.completed;

        return Column(
          children: [
            SizedBox(
              width: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.skip_previous,
                      size: 30,
                    ),
                    onPressed: audioHandler.skipToPrevious,
                  ),
                  IconButton(
                    icon: Icon(
                      playbackState.playing == false
                          ? Icons.play_circle_fill
                          : Icons.pause_circle_filled,
                      size: 50,
                    ),
                    onPressed: !playerEnabled
                        ? null
                        : playbackState.playing
                            ? audioHandler.pause
                            : audioHandler.play,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.skip_next,
                      size: 30,
                    ),
                    onPressed: audioHandler.skipToNext,
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  padding: const EdgeInsets.only(top: 7),
                  icon: const Icon(
                    Icons.replay_10,
                    size: 22,
                  ),
                  onPressed: playerEnabled
                      ? () => audioHandler.seekBackward(false)
                      : null,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.shuffle,
                    // TODO icon selection
                    size: 22,
                  ),
                  onPressed: () {}, // TODO change playback mode
                ),
                IconButton(
                  icon: const Icon(
                    Icons.share_outlined,
                    size: 22,
                  ),
                  onPressed: () {}, // TODO shareStory,
                ),
                IconButton(
                  padding: const EdgeInsets.only(top: 7),
                  icon: const Icon(
                    Icons.forward_10,
                    size: 22,
                  ),
                  onPressed: playerEnabled
                      ? () => audioHandler.seekForward(false)
                      : null,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
