import 'package:flutter/material.dart';

class CanvasEditorTheme extends ThemeExtension<CanvasEditorTheme> {
  final Color primaryColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color onSurfaceColor;
  final Color borderColor;
  final Color activeColor;
  final Color disabledColor;
  final TextStyle? toolbarTextStyle;
  final TextStyle? panelTextStyle;
  final double toolbarHeight;
  final double panelItemHeight;
  final BorderRadius toolbarBorderRadius;
  final BorderRadius panelBorderRadius;

  const CanvasEditorTheme({
    this.primaryColor = const Color(0xFF6200EE),
    this.secondaryColor = const Color(0xFF03DAC6),
    this.surfaceColor = const Color(0xFFFFFFFF),
    this.onSurfaceColor = const Color(0xFF000000),
    this.borderColor = const Color(0xFFE0E0E0),
    this.activeColor = const Color(0xFF6200EE),
    this.disabledColor = const Color(0xFFBDBDBD),
    this.toolbarTextStyle,
    this.panelTextStyle,
    this.toolbarHeight = 56.0,
    this.panelItemHeight = 48.0,
    this.toolbarBorderRadius = const BorderRadius.all(Radius.circular(8)),
    this.panelBorderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  CanvasEditorTheme copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? surfaceColor,
    Color? onSurfaceColor,
    Color? borderColor,
    Color? activeColor,
    Color? disabledColor,
    TextStyle? toolbarTextStyle,
    TextStyle? panelTextStyle,
    double? toolbarHeight,
    double? panelItemHeight,
    BorderRadius? toolbarBorderRadius,
    BorderRadius? panelBorderRadius,
  }) =>
      CanvasEditorTheme(
        primaryColor: primaryColor ?? this.primaryColor,
        secondaryColor: secondaryColor ?? this.secondaryColor,
        surfaceColor: surfaceColor ?? this.surfaceColor,
        onSurfaceColor: onSurfaceColor ?? this.onSurfaceColor,
        borderColor: borderColor ?? this.borderColor,
        activeColor: activeColor ?? this.activeColor,
        disabledColor: disabledColor ?? this.disabledColor,
        toolbarTextStyle: toolbarTextStyle ?? this.toolbarTextStyle,
        panelTextStyle: panelTextStyle ?? this.panelTextStyle,
        toolbarHeight: toolbarHeight ?? this.toolbarHeight,
        panelItemHeight: panelItemHeight ?? this.panelItemHeight,
        toolbarBorderRadius: toolbarBorderRadius ?? this.toolbarBorderRadius,
        panelBorderRadius: panelBorderRadius ?? this.panelBorderRadius,
      );

  @override
  CanvasEditorTheme lerp(ThemeExtension<CanvasEditorTheme>? other, double t) {
    if (other is! CanvasEditorTheme) return this;
    return CanvasEditorTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      onSurfaceColor: Color.lerp(onSurfaceColor, other.onSurfaceColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      activeColor: Color.lerp(activeColor, other.activeColor, t)!,
      disabledColor: Color.lerp(disabledColor, other.disabledColor, t)!,
      toolbarTextStyle: TextStyle.lerp(toolbarTextStyle, other.toolbarTextStyle, t),
      panelTextStyle: TextStyle.lerp(panelTextStyle, other.panelTextStyle, t),
      toolbarHeight: toolbarHeight + (other.toolbarHeight - toolbarHeight) * t,
      panelItemHeight: panelItemHeight + (other.panelItemHeight - panelItemHeight) * t,
      toolbarBorderRadius: BorderRadius.lerp(toolbarBorderRadius, other.toolbarBorderRadius, t)!,
      panelBorderRadius: BorderRadius.lerp(panelBorderRadius, other.panelBorderRadius, t)!,
    );
  }
}
