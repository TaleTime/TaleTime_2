import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import "package:taletime/main.dart";

class StoryMetadata extends StatelessWidget {
  const StoryMetadata({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audioHandler.mediaItem,
      builder: (context, mediaItem) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      mediaItem.data?.title ??
                          AppLocalizations.of(context)!.noTitle,
                      softWrap: true,
                      style: const TextStyle(
                          color: Colors.teal,
                          fontSize: 21.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      mediaItem.data?.artist ??
                          AppLocalizations.of(context)!.noName,
                      softWrap: true,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
