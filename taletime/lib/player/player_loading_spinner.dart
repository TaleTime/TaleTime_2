import "package:audio_service/audio_service.dart";
import "package:flutter/material.dart";
import "package:taletime/main.dart";

class PlayerLoadingSpinner extends StatelessWidget {
  const PlayerLoadingSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audioHandler.playbackState,
      builder: (context, playbackState) {

        // Keep state in local variable
        AudioProcessingState? processingState =
            playbackState.data?.processingState;

        // Render based on processingState
        if (processingState == AudioProcessingState.loading) {
          return const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 8,
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (processingState == AudioProcessingState.idle || processingState == null) {
          return const Icon(
            Icons.warning,
            color: Colors.red,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
