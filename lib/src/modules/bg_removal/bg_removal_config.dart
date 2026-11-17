class BgRemovalConfig {
  final BgRemovalMode mode;
  final double onnxThreshold;
  final bool smoothMask;

  const BgRemovalConfig({
    this.mode = BgRemovalMode.tiered,
    this.onnxThreshold = 0.5,
    this.smoothMask = true,
  });
}

enum BgRemovalMode { onDevice, backendApi, tiered }
