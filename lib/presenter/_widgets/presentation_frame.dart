import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PresentationFrame extends StatelessWidget {
  const PresentationFrame({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && MediaQuery.of(context).size.width > 400) {
      const MediaQueryData mq = MediaQueryData(
        size: Size(414, 896),
        padding: EdgeInsets.only(top: 44, bottom: 34),
        devicePixelRatio: 2,
      );
      return Material(
        child: Stack(
          textDirection: TextDirection.ltr,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 60, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ApplicationPreview(mq: mq, child: child),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return child;
  }
}

class _ApplicationPreview extends StatelessWidget {
  const _ApplicationPreview({
    required this.mq,
    required this.child,
  });

  final MediaQueryData mq;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 3,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Builder(builder: (context) {
          final device = MediaQuery(
            data: mq,
            child: Container(
              width: mq.size.width,
              height: mq.size.height,
              alignment: Alignment.center,
              child: child,
            ),
          );
          return Column(
            children: [
              const Text(
                'Application',
                style: TextStyle(fontSize: 50),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black, width: 12)),
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(38.5),
                  child: device,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}