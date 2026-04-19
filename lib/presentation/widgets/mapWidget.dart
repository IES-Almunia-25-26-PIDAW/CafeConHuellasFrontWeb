import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

const String _mapViewType = 'mapa-google';

final bool _mapViewRegistered = _registerMapView();

bool _registerMapView() {
  ui_web.platformViewRegistry.registerViewFactory(_mapViewType, (int viewId) {
    final iframe = html.IFrameElement()
      ..src = "https://www.google.com/maps?q=Jerez+de+la+Frontera&output=embed"
      ..style.border = 'none';

    return iframe;
  });

  return true;
}

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    _mapViewRegistered;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Container(
          height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.brown.shade200, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: const HtmlElementView(viewType: _mapViewType),
        ),
      ),
    );
  }
}
