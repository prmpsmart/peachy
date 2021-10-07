import 'package:flutter/material.dart';

Container iconNButton(String text, IconData icon) {
  return Container(
    height: 30,
    child: ElevatedButton(
      onPressed: () {
        // Navigator.of(context).pop();
      },
      child: Row(
        children: [
          Icon(icon, size: 18),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
