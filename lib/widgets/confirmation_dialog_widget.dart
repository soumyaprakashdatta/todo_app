import 'package:flutter/material.dart';

void createConfirmationDialog(
    BuildContext context,
    String dialogTitle,
    String dialogContent,
    String continueActionTitle,
    String cancelActionTitle,
    Function() onContinue,
    Function() onCancel) {
  // set up the buttons
  Widget cancelButton = OutlinedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) {
          return Colors.blueGrey.shade800;
        },
      ),
    ),
    child: Text(cancelActionTitle,
        style: const TextStyle(
          color: Colors.white,
        )),
    onPressed: () {
      onCancel();
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
    child: Text(continueActionTitle,
        style: const TextStyle(
          color: Colors.white,
        )),
    onPressed: () {
      onContinue();
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
