import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentNotification extends StatelessWidget {
  final String payload;
  const AppointmentNotification({Key? key, required this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          body: Text(payload),
        );
    throw UnimplementedError();
  }

}