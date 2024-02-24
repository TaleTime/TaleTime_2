import "package:audio_service/audio_service.dart";
import "package:flutter/material.dart";
import "package:taletime/main.dart";
import "package:taletime/player/models/custom_player_state.dart";

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

        return StreamBuilder<dynamic>(
            stream: audioHandler.customState,
            builder: (context, customStateSnapshot) {
              print(customStateSnapshot.data);

              CustomPlayerState? customPlayerState =
                  customStateSnapshot.data is CustomPlayerState
                      ? customStateSnapshot.data as CustomPlayerState
                      : null;

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
                          onPressed: customPlayerState?.hasPrev() ?? false
                              ? audioHandler.skipToPrevious
                              : null,
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
                          onPressed: customPlayerState?.hasNext() ?? false
                              ? audioHandler.skipToNext
                              : null,
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
                          size: 22,
                        ),
                        onPressed: () {
                          if (shuffle) {
                            audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
                            shuffle = false;
                          } else
                            {
                            audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
                            shuffle = true;
                            }
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.share_outlined,
                          size: 22,
                        ),
                        onPressed: () {},
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
            });
      },
    );
  }
}
