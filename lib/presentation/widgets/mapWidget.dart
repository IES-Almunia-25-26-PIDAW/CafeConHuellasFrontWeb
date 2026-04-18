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

    return SizedBox(
      height: 300,
      child: const HtmlElementView(viewType: _mapViewType),
    );
  }
}
