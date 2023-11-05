import 'package:flutter/material.dart';

void createConfirmationDialog(
    BuildContext context,
    String dialogTitle,
    String dialogContent,
    String mainActionTitle,
    String alternativeActionTitle,
    Function() onMainAction,
    Function() onAlternativeAction) {
  // set up the buttons
  Widget cancelButton = OutlinedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) {
          return Colors.blueGrey.shade800;
        },
      ),
    ),
    child: Text(alternativeActionTitle,
        style: const TextStyle(
          color: Colors.white,
        )),
    onPressed: () {
      onAlternativeAction();
    },
  );
  Widget continueButton = OutlinedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) {
          return Colors.red.shade300;
        },
      ),
    ),
    child: Text(mainActionTitle,
        style: const TextStyle(
          color: Colors.white,
        )),
    onPressed: () {
      onMainAction();
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.blueGrey.shade700,
    shadowColor: Colors.blueGrey.shade500,
    title: Text(dialogTitle,
        style: const TextStyle(
          color: Colors.white,
        )),
    content: Text(dialogContent,
        style: const TextStyle(
          color: Colors.white,
        )),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
