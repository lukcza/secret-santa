import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';

class ImageCropperDialog extends StatefulWidget {
  final Uint8List imageBytes;

  const ImageCropperDialog({
    super.key,
    required this.imageBytes,
  });

  static Future<Uint8List?> show(BuildContext context, Uint8List imageBytes) {
    return showDialog<Uint8List>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ImageCropperDialog(imageBytes: imageBytes),
    );
  }

  @override
  State<ImageCropperDialog> createState() => _ImageCropperDialogState();
}

class _ImageCropperDialogState extends State<ImageCropperDialog> {
  final TransformationController _transformationController =
      TransformationController();
  ui.Image? _decodedImage;
  bool _isProcessing = false;
  final GlobalKey _imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadUiImage();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Future<void> _loadUiImage() async {
    final codec = await ui.instantiateImageCodec(widget.imageBytes);
    final frame = await codec.getNextFrame();
    if (mounted) {
      setState(() {
        _decodedImage = frame.image;
      });
    }
  }

  Future<void> _cropAndSave() async {
    if (_decodedImage == null || _isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final RenderBox? box =
          _imageKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) return;

      final viewportSize = box.size;
      final cropRadius = (viewportSize.width < viewportSize.height
              ? viewportSize.width
              : viewportSize.height) *
          0.4;
      final cropCenter = Offset(viewportSize.width / 2, viewportSize.height / 2);
      final cropRect = Rect.fromCircle(center: cropCenter, radius: cropRadius);

      final matrix = _transformationController.value;
      final invertedMatrix = Matrix4.inverted(matrix);

      final imgW = _decodedImage!.width.toDouble();
      final imgH = _decodedImage!.height.toDouble();

      final fittedRect = _fitImageInViewport(Size(imgW, imgH), viewportSize);

      final localTL = MatrixUtils.transformPoint(invertedMatrix, Offset(cropRect.left, cropRect.top));
      final localBR = MatrixUtils.transformPoint(invertedMatrix, Offset(cropRect.right, cropRect.bottom));

      final srcX = ((localTL.dx - fittedRect.left) / fittedRect.width) * imgW;
      final srcY = ((localTL.dy - fittedRect.top) / fittedRect.height) * imgH;
      final srcW = ((localBR.dx - localTL.dx) / fittedRect.width) * imgW;
      final srcH = ((localBR.dy - localTL.dy) / fittedRect.height) * imgH;

      final srcRect = Rect.fromLTWH(
        srcX.clamp(0, imgW - 1),
        srcY.clamp(0, imgH - 1),
        srcW.clamp(1, imgW - srcX),
        srcH.clamp(1, imgH - srcY),
      );

      const targetSize = 500.0;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      final destRect = const Rect.fromLTWH(0, 0, targetSize, targetSize);
      final path = Path()..addOval(destRect);
      canvas.clipPath(path);

      canvas.drawImageRect(
        _decodedImage!,
        srcRect,
        destRect,
        Paint()..filterQuality = FilterQuality.high,
      );

      final picture = recorder.endRecording();
      final croppedUiImage = await picture.toImage(
        targetSize.toInt(),
        targetSize.toInt(),
      );
      final byteData = await croppedUiImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (mounted && byteData != null) {
        Navigator.of(context).pop(byteData.buffer.asUint8List());
      }
    } catch (e) {
      print("Crop error: $e");
      if (mounted) {
        Navigator.of(context).pop(widget.imageBytes);
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Rect _fitImageInViewport(Size imageSize, Size viewportSize) {
    final double scale = (viewportSize.width / imageSize.width <
            viewportSize.height / imageSize.height)
        ? viewportSize.width / imageSize.width
        : viewportSize.height / imageSize.height;

    final double fittedW = imageSize.width * scale;
    final double fittedH = imageSize.height * scale;

    final double dx = (viewportSize.width - fittedW) / 2;
    final double dy = (viewportSize.height - fittedH) / 2;

    return Rect.fromLTWH(dx, dy, fittedW, fittedH);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          height: 480,
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              // Header bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.loc.cropImageTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Interactive view with circular overlay mask
              Expanded(
                child: _decodedImage == null
                    ? const Center(child: CircularProgressIndicator())
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            key: _imageKey,
                            children: [
                              InteractiveViewer(
                                transformationController:
                                    _transformationController,
                                minScale: 0.8,
                                maxScale: 4.0,
                                boundaryMargin: const EdgeInsets.all(200),
                                child: Center(
                                  child: Image.memory(
                                    widget.imageBytes,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              // Circular Mask overlay
                              IgnorePointer(
                                child: CustomPaint(
                                  size: Size(
                                    constraints.maxWidth,
                                    constraints.maxHeight,
                                  ),
                                  painter: _CropOverlayPainter(),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),

              const Divider(height: 1),

              // Action buttons
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isProcessing
                            ? null
                            : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(context.loc.cropImageCancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _cropAndSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isProcessing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(context.loc.cropImageConfirm),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _CropOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius =
        (size.width < size.height ? size.width : size.height) * 0.4;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect cropRect = Rect.fromCircle(center: center, radius: radius);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.55)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(cropRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, backgroundPaint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
