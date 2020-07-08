import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: c[400],
      child: Center(
        child: SpinKitChasingDots(
          color: c,
          size: 50.0,
        ),
      ),
    );
  }
}
