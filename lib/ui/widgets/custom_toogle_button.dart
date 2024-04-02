import 'package:flutter/material.dart';
import 'package:paint_gpt/utils/utils.dart';

class CustomToogleButton extends StatelessWidget {
  const CustomToogleButton(
      {super.key, required this.onUndo, required this.onRedo});
  final Function()? onUndo;
  final Function()? onRedo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                splashRadius: 1,
                onPressed: () => onUndo?.call(),
                icon: const Icon(
                  Icons.reply,
                  size: 14,
                  color: iconColor,
                )),
            kSBW10,
            const SizedBox(
              height: 12,
              child: VerticalDivider(
                width: 0.44,
                color: iconColor,
              ),
            ),
            kSBW10,
            IconButton(
                splashRadius: 1,
                onPressed: () => onRedo?.call(),
                icon: Transform.flip(
                  flipX: true,
                  child: const Icon(
                    Icons.reply,
                    size: 14,
                    color: iconColor,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
