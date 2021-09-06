import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        child: FlareActor(
          "assets/flare/loading_animation.flr",
          fit:BoxFit.contain,
          animation:"loading",
        ),
      ),
    );
  }
}

