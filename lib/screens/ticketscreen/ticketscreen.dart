import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';

/// pubspec.yaml dependencies you need to add:
///
/// dependencies:
///   path_provider: ^2.1.4
///   share_plus: ^10.0.2
///   gal: ^2.3.0
///
/// Android (android/app/src/main/AndroidManifest.xml) — no extra permission
/// needed for gal on API 29+, but for older devices add:
///   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
///       android:maxSdkVersion="28"/>
///
/// iOS (ios/Runner/Info.plist) — add:
///   <key>NSPhotoLibraryAddUsageDescription</key>
///   <string>Allow saving your ticket to Photos</string>

class TicketScreen extends StatefulWidget {
  final String companyName;
  final String boardingCity;
  final String droppingCity;
  final String boardingPoint;
  final String boardingTime;
  final String droppingPoint;
  final String droppingTime;
  final String date;
  final String bookingId;
  final num totalPrice;
  final List<Map<String, dynamic>> passengers;

  static const Color bgColor = Color(0xFF0E1116);
  static const Color cardColor = Color(0xFF1C2028);
  static const Color innerColor = Color(0xFF161A21);
  static const Color borderColor = Color(0xFF262B35);
  static const Color amber = Color(0xFFE8B84B);
  static const Color muted = Color(0xFF9AA0AA);
  static const Color green = Color(0xFF5FD08A);

  const TicketScreen({
    super.key,
    required this.companyName,
    required this.boardingCity,
    required this.droppingCity,
    required this.boardingPoint,
    required this.boardingTime,
    required this.droppingPoint,
    required this.droppingTime,
    required this.date,
    required this.bookingId,
    required this.totalPrice,
    required this.passengers,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final GlobalKey _ticketKey = GlobalKey();
  bool _isDownloading = false;
  bool _isSharing = false;

  // Captures whatever is wrapped in RepaintBoundary (the ticket card only,
  // not the buttons below it) as PNG bytes.
  Future<Uint8List?> _captureTicket() async {
    try {
      final boundary = _ticketKey.currentContext?.findRenderObject()
      as RenderRepaintBoundary?;
      if (boundary == null) return null;

      // Wait a frame in case a rebuild is in flight.
      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 50));
        return _captureTicket();
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Ticket capture failed: $e');
      return null;
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red[700] : TicketScreen.cardColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _downloadTicket() async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);
    try {
      final bytes = await _captureTicket();
      if (bytes == null) {
        _showSnack('Could not generate ticket image', isError: true);
        return;
      }
      await Gal.putImageBytes(bytes, name: 'ticket_${widget.bookingId}');
      _showSnack('Ticket saved to gallery');
    } catch (e) {
      _showSnack('Failed to save ticket: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  Future<void> _shareTicket() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      final bytes = await _captureTicket();
      if (bytes == null) {
        _showSnack('Could not generate ticket image', isError: true);
        return;
      }
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/ticket_${widget.bookingId}.png');
      await file.writeAsBytes(bytes);

      // iOS (especially iPad) requires sharePositionOrigin — the on-screen
      // rect the share popover should point to. Without it you get:
      // "sharePositionOrigin: argument must be set".
      Rect? sharePositionOrigin;
      final box = context.findRenderObject() as RenderBox?;
      if (box != null) {
        sharePositionOrigin = box.localToGlobal(Offset.zero) & box.size;
      }

      await Share.shareXFiles(
        [XFile(file.path)],
        text:
        '${widget.companyName} ticket • ${widget.boardingCity} → ${widget.droppingCity} • ${widget.date}',
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      _showSnack('Failed to share ticket: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TicketScreen.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFF12271A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    color: TicketScreen.green, size: 30),
              ),
              const SizedBox(height: 14),
              const Text(
                "Booking confirmed",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              const Text(
                "Ticket sent to your email",
                style: TextStyle(color: TicketScreen.muted, fontSize: 12.5),
              ),
              const SizedBox(height: 24),

              // Everything that should appear in the downloaded / shared
              // image goes inside this RepaintBoundary.
              RepaintBoundary(
                key: _ticketKey,
                child: Container(
                  color: TicketScreen.bgColor,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: TicketScreen.cardColor,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          border: Border.all(
                              color: TicketScreen.borderColor, width: 0.6),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.companyName,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: TicketScreen.borderColor,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: const Text("Confirmed",
                                      style: TextStyle(
                                          color: TicketScreen.amber,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.boardingTime,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600)),
                                      Text(widget.boardingCity,
                                          style: const TextStyle(
                                              color: TicketScreen.muted,
                                              fontSize: 11.5)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_rounded,
                                    color: Color(0xFF5A5F6A), size: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(widget.droppingTime,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600)),
                                      Text(widget.droppingCity,
                                          style: const TextStyle(
                                              color: TicketScreen.muted,
                                              fontSize: 11.5)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text("Boarding point",
                                          style: TextStyle(
                                              color: Color(0xFF5A5F6A),
                                              fontSize: 10)),
                                      const SizedBox(height: 2),
                                      Text(widget.boardingPoint,
                                          style: const TextStyle(
                                              color: Color(0xFFD5D8DD),
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text("Dropping point",
                                          style: TextStyle(
                                              color: Color(0xFF5A5F6A),
                                              fontSize: 10)),
                                      const SizedBox(height: 2),
                                      Text(widget.droppingPoint,
                                          style: const TextStyle(
                                              color: Color(0xFFD5D8DD),
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text("Date",
                                          style: TextStyle(
                                              color: Color(0xFF5A5F6A),
                                              fontSize: 10)),
                                      const SizedBox(height: 2),
                                      Text(widget.date,
                                          style: const TextStyle(
                                              color: Color(0xFFD5D8DD),
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text("Seats",
                                          style: TextStyle(
                                              color: Color(0xFF5A5F6A),
                                              fontSize: 10)),
                                      const SizedBox(height: 2),
                                      Text(
                                        widget.passengers
                                            .map((p) => p["seatnumber"])
                                            .join(", "),
                                        style: const TextStyle(
                                            color: TicketScreen.amber,
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: TicketScreen.borderColor, width: 1)),
                        ),
                        child: CustomPaint(
                          painter: _DashedLinePainter(),
                          child: const SizedBox(height: 1, width: double.infinity),
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: TicketScreen.cardColor,
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(16)),
                          border: Border.all(
                              color: TicketScreen.borderColor, width: 0.6),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text("Passengers",
                                        style: TextStyle(
                                            color: Color(0xFF5A5F6A),
                                            fontSize: 10)),
                                    const SizedBox(height: 3),
                                    ...widget.passengers.map(
                                          (p) => Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                            "${p["name"]} • ${p["seatnumber"]}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text("Booking ID",
                                        style: TextStyle(
                                            color: Color(0xFF5A5F6A),
                                            fontSize: 10)),
                                    const SizedBox(height: 3),
                                    Text(widget.bookingId,
                                        style: const TextStyle(
                                            color: Color(0xFFD5D8DD),
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                  color: TicketScreen.innerColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text("Total paid",
                                          style: TextStyle(
                                              color: Color(0xFF5A5F6A),
                                              fontSize: 10)),
                                      Text("₹${widget.totalPrice}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(8)),
                                    child: const Icon(Icons.qr_code_rounded,
                                        color: TicketScreen.bgColor, size: 32),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isDownloading ? null : _downloadTicket,
                      icon: _isDownloading
                          ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Color(0xFFD5D8DD)),
                      )
                          : const Icon(Icons.download_outlined,
                          color: Color(0xFFD5D8DD), size: 16),
                      label: Text(
                          _isDownloading ? "Saving..." : "Download",
                          style: const TextStyle(color: Color(0xFFD5D8DD))),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: TicketScreen.borderColor),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isSharing ? null : _shareTicket,
                      icon: _isSharing
                          ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Color(0xFF2A1E00)),
                      )
                          : const Icon(Icons.share_outlined,
                          color: Color(0xFF2A1E00), size: 16),
                      label: Text(_isSharing ? "Preparing..." : "Share",
                          style: const TextStyle(
                              color: Color(0xFF2A1E00),
                              fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: TicketScreen.amber,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3A3F4A)
      ..strokeWidth = 1;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + 4, 0), paint);
      x += 8;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}