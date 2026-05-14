import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

const String _mapViewType = 'mapa-google';

// Registered once at startup to avoid duplicate view type errors.
final bool _mapViewRegistered = _registerMapView();

/// Registers the Google Maps iframe as a platform view.
///
/// Called once via [_mapViewRegistered] to ensure
/// it is never registered more than once.
bool _registerMapView() {
  ui_web.platformViewRegistry.registerViewFactory(_mapViewType, (int viewId) {
    final iframe = html.IFrameElement()
      ..src = "https://www.google.com/maps?q=Jerez+de+la+Frontera&output=embed"
      ..style.border = 'none';

    return iframe;
  });

  return true;
}

/// A widget that renders an embedded Google Maps iframe.
///
/// Uses a platform view to display the map inside
/// a rounded, shadowed container.
class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensures the view factory is registered before building.
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