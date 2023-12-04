import "dart:math";

import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common/utils/string_utils.dart";
import "package:taletime/main.dart";

class ProgressBar extends StatefulWidget {
  const ProgressBar({super.key});

  @override
  State<StatefulWidget> createState() => _ProgressBarState();
}

/// Widget for indicating playback progress and modifying the position.
///
///
class _ProgressBarState extends State<ProgressBar> {
  /// Current position of the story
  double _position = 0;

  /// Duration of the story
  double _duration = 0;

  /// Whether the user is tracking the slider; then ignore position changes
  /// from player
  bool _trackingSlider = false;

  @override
  void initState() {
    super.initState();

    // Listen to duration change
    audioHandler.mediaItem.listen((mediaItem) {
      setState(() {
        _duration = mediaItem?.duration?.inMilliseconds.toDouble() ?? 0;
      });
    });

    // Listen to position change
    audioHandler.playbackState.listen((playbackState) {
      if (!_trackingSlider) {
        setState(() {
          _position = playbackState.position.inMilliseconds.toDouble();
        });
      }
    });

    // Periodically update position
    Stream<void>.periodic(const Duration(milliseconds: 500)).listen((_) {
      if (!_trackingSlider) {
        setState(() {
          _position = audioHandler.playbackState.value.position.inMilliseconds
              .toDouble();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider.adaptive(
          value: _position,
          min: 0,
          max: max(_position, _duration),
          onChanged: (pos) {
            setState(() {
              _position = pos;
            });
          },

          onChangeStart: (pos) {
            setState(() {
              _trackingSlider = true;
            });
          },

          onChangeEnd: (pos) {
            setState(() {
              _trackingSlider = false;
            });
            audioHandler.seek(Duration(milliseconds: pos.toInt()));
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              StringUtils.durationToString(
                  Duration(milliseconds: _position.toInt())),
              style: TextStyle(
                  fontSize: 14,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "/",
                style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              StringUtils.durationToString(
                  Duration(milliseconds: max(_position, _duration).toInt())),
              style: TextStyle(
                  fontSize: 14, color: kPrimaryColor),
            ),
          ],
        ),
      ],
    );
  }
}
