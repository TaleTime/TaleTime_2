import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";

class AlertDialogButton {
  const AlertDialogButton({required this.text, required this.onPressed});

  final String text;
  final void Function() onPressed;
}

class TaleTimeAlertDialog extends StatelessWidget {
  const TaleTimeAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.buttons,
  });

  final String title;
  final String content;
  final List<AlertDialogButton> buttons;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: kPrimaryColor),
      ),
      content: Text(
        content,
      ),
      actions: [
        ...buttons.map(
          (e) => TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
            onPressed: e.onPressed,
            child: Text(
              e.text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
