
import 'package:flutter/material.dart';

class LoadingStackWidget extends StatelessWidget {
  const LoadingStackWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(
          color: Colors.black.withOpacity(0.5),
          dismissible: false, // Block user interaction
        ),
        const Center(
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}