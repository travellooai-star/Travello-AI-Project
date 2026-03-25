import 'dart:math' as math;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  TRAVELLO AI — PREMIUM E-TICKET (Apple / Wego level)
//  · Single trip  → 1 ticket card
//  · Round trip   → 2 ticket cards (Outbound + Return)
//  · QR code + barcode + structured sections
//  · Fintech-grade trust design + PDF-ready
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// ─── Design Tokens ───────────────────────────────────────────
class _T {
  static const navy = Color(0xFF0A1628);
  static const blue = Color(0xFF2563EB);
  static const blueLight = Color(0xFFEFF6FF);
  static const emerald = Color(0xFF10B981);
  static const amber = Color(0xFFF59E0B);
  static const rose = Color(0xFFE53935);
  static const surface = Color(0xFFFFFFFF);
  static const ice = Color(0xFFF8FAFF);
  static const scaffoldBg = Color(0xFFF0F4FF);
  static const border = Color(0xFFE8EDF5);
  static const textPri = Color(0xFF0A1628);
  static const textSec = Color(0xFF64748B);
  static const textMuted = Color(0xFF94A3B8);

  static const headerGrad = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A1628), Color(0xFF1E3A70)],
  );

  static TextStyle label({Color? color}) => TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
      color: color ?? textMuted);

  static TextStyle value({double size = 14, Color? color, FontWeight? w}) =>
      TextStyle(
          fontSize: size,
          fontWeight: w ?? FontWeight.w600,
          color: color ?? textPri);

  static TextStyle cityCode({double size = 32}) => TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.5,
      color: textPri);
}

class ProfessionalETicket extends StatefulWidget {
  const ProfessionalETicket({super.key});
  @override
  State<ProfessionalETicket> createState() => _ProfessionalETicketState();
}

class _ProfessionalETicketState extends State<ProfessionalETicket> {
  Map<String, dynamic> _booking = {};
  bool _isRoundTrip = false;
  bool _generatingPdf = false;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  void _boot() {
    final raw = Get.arguments;
    if (raw is Map<String, dynamic>) {
      setState(() {
        _booking = raw;
        _isRoundTrip = raw['isRoundTrip'] == true;
      });
    }
  }

  // ─── PDF download ───────────────────────────────
  Future<void> _downloadPdf() async {
    setState(() => _generatingPdf = true);
    try {
      final doc = pw.Document();
      final paxList = _allPassengers;
      for (int i = 0; i < paxList.length; i++) {
        final pax = paxList[i];
        _addPdfPage(doc,
            isReturn: false,
            passengerIndex: i,
            passengerName: pax['name'] as String? ?? '',
            passportOrId: pax['passportOrId'] as String? ?? '',
            documentType: pax['documentType'] as String? ?? 'Passport',
            nationality: pax['nationality'] as String? ?? '');
      }
      if (_isRoundTrip) {
        for (int i = 0; i < paxList.length; i++) {
          final pax = paxList[i];
          _addPdfPage(doc,
              isReturn: true,
              passengerIndex: i,
              passengerName: pax['name'] as String? ?? '',
              passportOrId: pax['passportOrId'] as String? ?? '',
              documentType: pax['documentType'] as String? ?? 'Passport',
              nationality: pax['nationality'] as String? ?? '');
        }
      }
      await Printing.layoutPdf(onLayout: (_) async => doc.save());
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('PDF generation failed'),
            backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _generatingPdf = false);
    }
  }

  void _addPdfPage(
    pw.Document doc, {
    required bool isReturn,
    required int passengerIndex,
    required String passengerName,
    required String passportOrId,
    String documentType = 'Passport',
    String nationality = '',
  }) {
    // -- PDF colours --------------------------------------------------
    const pdfNavy = PdfColor(0.059, 0.176, 0.361); // #0F2D5C
    const pdfBlue = PdfColor(0.145, 0.388, 0.922); // #2563EB
    const pdfEmerald = PdfColor(0.063, 0.725, 0.506); // #10B981
    const pdfRose = PdfColor(0.957, 0.247, 0.369); // #F43F5E
    const pdfIce = PdfColor(0.941, 0.965, 1.0); // #F0F6FF
    const pdfBorder = PdfColor(0.886, 0.922, 0.965); // #E2EBF6
    const pdfTextSec = PdfColor(0.392, 0.455, 0.545); // #64748B
    const pdfBlueIce = PdfColor(0.937, 0.965, 1.0); // #EFF6FF

    // -- Data --------------------------------------------------------
    final dep = _dep(isReturn);
    final arr = _arr(isReturn);
    final date = _date(isReturn);
    final fromFull = _from(isReturn);
    final toFull = _to(isReturn);
    final airline = _airline(isReturn);
    final fltNum = _fltNum(isReturn);
    final cabin = _cabin(isReturn);
    final dur = _duration(isReturn);
    final fromCode = _code(fromFull);
    final toCode = _code(toFull);
    final fromCity = _city(fromFull);
    final toCity = _city(toFull);
    final payMethod = _booking['paymentMethod'] as String? ?? 'N/A';
    final seatNumber = _getSeatForPassenger(passengerIndex, isReturn);
    final barcodeD = '$_pnr-${isReturn ? 'R' : 'O'}-$fltNum';
    final qrData = 'TRAVELLO|PNR:$_pnr|PAX:$passengerName|FLT:$fltNum';
    final dirLabel = isReturn ? 'RETURN FLIGHT' : 'OUTBOUND FLIGHT';

    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      build: (_) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // -- Top bar ---------------------------------------------
          pw.Row(children: [
            pw.Container(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: pw.BoxDecoration(
                color: isReturn ? pdfEmerald : pdfNavy,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
              ),
              child: pw.Text(dirLabel,
                  style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 1)),
            ),
            pw.SizedBox(width: 10),
            pw.Text('PNR: $_pnr',
                style: const pw.TextStyle(fontSize: 10, color: pdfTextSec)),
            pw.Spacer(),
            pw.Text('Travello AI  -  E-Ticket',
                style: pw.TextStyle(
                    fontSize: 10,
                    color: pdfNavy,
                    fontWeight: pw.FontWeight.bold)),
          ]),
          pw.SizedBox(height: 10),

          // -- Main card -------------------------------------------
          pw.Container(
            decoration: pw.BoxDecoration(
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(14)),
              border: pw.Border.all(color: pdfBorder),
              color: PdfColors.white,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // -- Header (navy) ------------------------------
                pw.Container(
                  padding: const pw.EdgeInsets.fromLTRB(20, 16, 20, 16),
                  decoration: const pw.BoxDecoration(
                    color: pdfNavy,
                    borderRadius: pw.BorderRadius.only(
                        topLeft: pw.Radius.circular(14),
                        topRight: pw.Radius.circular(14)),
                  ),
                  child: pw.Row(children: [
                    pw.Container(
                      width: 42,
                      height: 42,
                      decoration: const pw.BoxDecoration(
                        color: PdfColor(1, 1, 1, 0.12),
                        borderRadius:
                            pw.BorderRadius.all(pw.Radius.circular(10)),
                      ),
                      child: pw.Center(
                        child: pw.Text('FL',
                            style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold)),
                      ),
                    ),
                    pw.SizedBox(width: 14),
                    pw.Expanded(
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(airline,
                                style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 5),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: const pw.BoxDecoration(
                                color: PdfColor(1, 1, 1, 0.15),
                                borderRadius:
                                    pw.BorderRadius.all(pw.Radius.circular(4)),
                              ),
                              child: pw.Text(fltNum,
                                  style: pw.TextStyle(
                                      color: PdfColors.white,
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold,
                                      letterSpacing: 0.8)),
                            ),
                          ]),
                    ),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: pw.BoxDecoration(
                              color: const PdfColor(0.063, 0.725, 0.506, 0.22),
                              borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(12)),
                              border: pw.Border.all(
                                  color: const PdfColor(
                                      0.063, 0.725, 0.506, 0.55)),
                            ),
                            child: pw.Text('CONFIRMED',
                                style: pw.TextStyle(
                                    color: pdfEmerald,
                                    fontSize: 8,
                                    fontWeight: pw.FontWeight.bold,
                                    letterSpacing: 0.8)),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: const pw.BoxDecoration(
                              color: PdfColor(1, 1, 1, 0.12),
                              borderRadius:
                                  pw.BorderRadius.all(pw.Radius.circular(6)),
                            ),
                            child: pw.Text(cabin,
                                style: const pw.TextStyle(
                                    color: PdfColors.white, fontSize: 9)),
                          ),
                        ]),
                  ]),
                ),

                // -- Route --------------------------------------
                pw.Container(
                  color: PdfColors.white,
                  padding: const pw.EdgeInsets.fromLTRB(24, 20, 24, 14),
                  child: pw.Column(children: [
                    pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          // FROM
                          pw.Expanded(
                            child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(fromCity,
                                      style: const pw.TextStyle(
                                          fontSize: 8, color: pdfTextSec)),
                                  pw.SizedBox(height: 3),
                                  pw.Text(fromCode,
                                      style: pw.TextStyle(
                                          fontSize: 28,
                                          fontWeight: pw.FontWeight.bold,
                                          color: pdfNavy,
                                          letterSpacing: 2)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(dep,
                                      style: pw.TextStyle(
                                          fontSize: 14,
                                          fontWeight: pw.FontWeight.bold,
                                          color: pdfNavy)),
                                  pw.SizedBox(height: 2),
                                  pw.Text(date,
                                      style: const pw.TextStyle(
                                          fontSize: 8, color: pdfTextSec)),
                                ]),
                          ),
                          // Connector
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 8),
                            child: pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Text(dur,
                                      style: const pw.TextStyle(
                                          fontSize: 8, color: pdfTextSec)),
                                  pw.SizedBox(height: 5),
                                  pw.Row(children: [
                                    pw.Container(
                                        width: 6,
                                        height: 6,
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                                color: pdfBlue, width: 1.5),
                                            shape: pw.BoxShape.circle)),
                                    pw.Container(
                                        width: 18,
                                        height: 1.5,
                                        color: const PdfColor(
                                            0.145, 0.388, 0.922, 0.3)),
                                    pw.Container(
                                      padding: const pw.EdgeInsets.all(4),
                                      decoration: const pw.BoxDecoration(
                                          color: pdfBlueIce,
                                          shape: pw.BoxShape.circle),
                                      child: pw.Text('>',
                                          style: pw.TextStyle(
                                              color: pdfBlue,
                                              fontSize: 9,
                                              fontWeight: pw.FontWeight.bold)),
                                    ),
                                    pw.Container(
                                        width: 18,
                                        height: 1.5,
                                        color: const PdfColor(
                                            0.145, 0.388, 0.922, 0.3)),
                                    pw.Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const pw.BoxDecoration(
                                            color: pdfBlue,
                                            shape: pw.BoxShape.circle)),
                                  ]),
                                  pw.SizedBox(height: 5),
                                  pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: const pw.BoxDecoration(
                                      color: pdfBlueIce,
                                      borderRadius: pw.BorderRadius.all(
                                          pw.Radius.circular(4)),
                                    ),
                                    child: pw.Text('NON-STOP',
                                        style: pw.TextStyle(
                                            color: pdfBlue,
                                            fontSize: 7,
                                            fontWeight: pw.FontWeight.bold,
                                            letterSpacing: 0.5)),
                                  ),
                                ]),
                          ),
                          // TO
                          pw.Expanded(
                            child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Text(toCity,
                                      textAlign: pw.TextAlign.right,
                                      style: const pw.TextStyle(
                                          fontSize: 8, color: pdfTextSec)),
                                  pw.SizedBox(height: 3),
                                  pw.Text(toCode,
                                      textAlign: pw.TextAlign.right,
                                      style: pw.TextStyle(
                                          fontSize: 28,
                                          fontWeight: pw.FontWeight.bold,
                                          color: pdfNavy,
                                          letterSpacing: 2)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(arr,
                                      textAlign: pw.TextAlign.right,
                                      style: pw.TextStyle(
                                          fontSize: 14,
                                          fontWeight: pw.FontWeight.bold,
                                          color: pdfNavy)),
                                  pw.SizedBox(height: 2),
                                  pw.Text(date,
                                      textAlign: pw.TextAlign.right,
                                      style: const pw.TextStyle(
                                          fontSize: 8, color: pdfTextSec)),
                                ]),
                          ),
                        ]),
                    pw.SizedBox(height: 14),
                    // Detail chips row
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 4, vertical: 10),
                      decoration: pw.BoxDecoration(
                        color: pdfIce,
                        borderRadius:
                            const pw.BorderRadius.all(pw.Radius.circular(8)),
                        border: pw.Border.all(color: pdfBorder),
                      ),
                      child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                          children: [
                            _pdfChip('SEAT', seatNumber, pdfTextSec),
                            _pdfVDiv(pdfBorder),
                            _pdfChip('GATE', 'H22', pdfRose),
                            _pdfVDiv(pdfBorder),
                            _pdfChip('TERMINAL', '3', pdfTextSec),
                            _pdfVDiv(pdfBorder),
                            _pdfChip('BOARDS AT', dep, pdfBlue),
                          ]),
                    ),
                  ]),
                ),

                // -- Tear-line ----------------------------------
                pw.Row(children: [
                  pw.Container(
                      width: 14,
                      height: 14,
                      decoration: const pw.BoxDecoration(
                          color: PdfColor(0.945, 0.961, 0.973),
                          shape: pw.BoxShape.circle)),
                  pw.Expanded(
                    child: pw.Divider(
                      color: pdfBorder,
                      thickness: 1,
                    ),
                  ),
                  pw.Container(
                      width: 14,
                      height: 14,
                      decoration: const pw.BoxDecoration(
                          color: PdfColor(0.945, 0.961, 0.973),
                          shape: pw.BoxShape.circle)),
                ]),

                // -- Passenger section --------------------------
                pw.Container(
                  color: PdfColors.white,
                  padding: const pw.EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: pw.Column(children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        color: pdfBlueIce,
                        borderRadius:
                            const pw.BorderRadius.all(pw.Radius.circular(10)),
                        border: pw.Border.all(color: pdfBorder),
                      ),
                      child: pw.Row(children: [
                        pw.Container(
                          width: 36,
                          height: 36,
                          decoration: const pw.BoxDecoration(
                            color: PdfColor(0.145, 0.388, 0.922, 0.12),
                            shape: pw.BoxShape.circle,
                          ),
                          child: pw.Center(
                            child: pw.Text('PAX',
                                style: pw.TextStyle(
                                    color: pdfBlue,
                                    fontSize: 8,
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                        ),
                        pw.SizedBox(width: 12),
                        pw.Expanded(
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('PASSENGER',
                                    style: pw.TextStyle(
                                        fontSize: 7,
                                        color: pdfTextSec,
                                        fontWeight: pw.FontWeight.bold,
                                        letterSpacing: 0.5)),
                                pw.SizedBox(height: 3),
                                pw.Text(passengerName,
                                    style: pw.TextStyle(
                                        fontSize: 13,
                                        fontWeight: pw.FontWeight.bold,
                                        color: pdfNavy)),
                              ]),
                        ),
                        if (passportOrId.isNotEmpty)
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text(
                                    nationality == 'Pakistan' &&
                                            documentType == 'CNIC'
                                        ? 'CNIC'
                                        : 'PASSPORT',
                                    style: const pw.TextStyle(
                                        fontSize: 7, color: pdfTextSec)),
                                pw.SizedBox(height: 3),
                                pw.Text(passportOrId,
                                    style: pw.TextStyle(
                                        fontSize: 11,
                                        fontWeight: pw.FontWeight.bold,
                                        color: pdfNavy)),
                              ]),
                      ]),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(children: [
                      pw.Expanded(
                          child: _pdfTile('THIS TICKET', '1 Passenger',
                              pdfTextSec, pdfIce, pdfBorder, pdfNavy)),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                          child: _pdfTile('PAID VIA', payMethod, pdfTextSec,
                              pdfIce, pdfBorder, pdfNavy)),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                          child: _pdfTile('DATE', _shortDate(date), pdfTextSec,
                              pdfIce, pdfBorder, pdfNavy)),
                    ]),
                    pw.SizedBox(height: 12),
                  ]),
                ),

                // -- Scan section -------------------------------
                pw.Container(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.only(
                        bottomLeft: pw.Radius.circular(14),
                        bottomRight: pw.Radius.circular(14)),
                  ),
                  padding: const pw.EdgeInsets.fromLTRB(22, 0, 22, 18),
                  child: pw.Column(children: [
                    pw.Row(children: [
                      pw.Expanded(
                          child: pw.Divider(color: pdfBorder, thickness: 1)),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('SCAN AT GATE',
                            style: pw.TextStyle(
                                fontSize: 7,
                                color: pdfTextSec,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 0.5)),
                      ),
                      pw.Expanded(
                          child: pw.Divider(color: pdfBorder, thickness: 1)),
                    ]),
                    pw.SizedBox(height: 10),
                    pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Column(children: [
                              pw.BarcodeWidget(
                                barcode: pw.Barcode.code128(),
                                data: barcodeD,
                                width: double.infinity,
                                height: 50,
                                drawText: false,
                                color: pdfNavy,
                              ),
                              pw.SizedBox(height: 5),
                              pw.Text(_pnr,
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.bold,
                                      letterSpacing: 3,
                                      color: pdfTextSec)),
                              pw.SizedBox(height: 2),
                              pw.Text('Scan at boarding gate',
                                  textAlign: pw.TextAlign.center,
                                  style: const pw.TextStyle(
                                      fontSize: 7, color: pdfTextSec)),
                            ]),
                          ),
                          pw.Container(
                              margin:
                                  const pw.EdgeInsets.symmetric(horizontal: 14),
                              width: 1,
                              height: 66,
                              color: pdfBorder),
                          pw.Column(children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.all(4),
                              decoration: pw.BoxDecoration(
                                color: PdfColors.white,
                                borderRadius: const pw.BorderRadius.all(
                                    pw.Radius.circular(8)),
                                border:
                                    pw.Border.all(color: pdfBorder, width: 1.5),
                              ),
                              child: pw.BarcodeWidget(
                                barcode: pw.Barcode.qrCode(),
                                data: qrData,
                                width: 62,
                                height: 62,
                                color: pdfNavy,
                                drawText: false,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text('QUICK SCAN',
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                    fontSize: 7,
                                    color: pdfTextSec,
                                    fontWeight: pw.FontWeight.bold,
                                    letterSpacing: 0.5)),
                          ]),
                        ]),
                    pw.SizedBox(height: 12),
                    pw.Center(
                      child:
                          pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
                        pw.Container(
                          width: 16,
                          height: 16,
                          decoration: const pw.BoxDecoration(
                            color: pdfNavy,
                            borderRadius:
                                pw.BorderRadius.all(pw.Radius.circular(4)),
                          ),
                          child: pw.Center(
                              child: pw.Text('T',
                                  style: pw.TextStyle(
                                      color: PdfColors.white,
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold))),
                        ),
                        pw.SizedBox(width: 6),
                        pw.Text('Travello AI  -  Verified & Secure Ticket',
                            style: const pw.TextStyle(
                                fontSize: 8, color: pdfTextSec)),
                      ]),
                    ),
                  ]),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 14),

          // -- Travel tips card -----------------------------
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
              border: pw.Border.all(color: pdfBorder),
              color: PdfColors.white,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Travel Guidelines',
                    style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        color: pdfNavy)),
                pw.SizedBox(height: 8),
                ...[
                  'Arrive at least 2 hours before departure',
                  'Carry valid CNIC / Passport and this e-ticket',
                  'Check-in closes 45 minutes before departure',
                  'Baggage allowance: 20 kg checked + 7 kg cabin',
                  'Web check-in opens 24 hours before departure',
                ].map((tip) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 5),
                      child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('�  ',
                                style: pw.TextStyle(
                                    color: pdfBlue,
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Expanded(
                                child: pw.Text(tip,
                                    style: const pw.TextStyle(
                                        fontSize: 9, color: pdfTextSec))),
                          ]),
                    )),
                pw.SizedBox(height: 4),
                pw.Divider(color: pdfBorder, thickness: 1),
                pw.Center(
                  child: pw.Text('support@travello.pk  -  +92 300 1234567',
                      style:
                          const pw.TextStyle(fontSize: 8, color: pdfTextSec)),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  // ─── Data helpers ───────────────────────────────
  String get _pnr => _booking['pnr'] ?? 'TRV000000';
  String get _name => _booking['passengerName'] ?? 'Passenger';
  String get _today => DateFormat('dd MMM yyyy').format(DateTime.now());

  // Returns all passengers; falls back to single entry built from passengerName
  List<Map<String, dynamic>> get _allPassengers {
    final raw = _booking['allPassengers'];
    if (raw is List && raw.isNotEmpty) {
      return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return [
      {'name': _name, 'passportOrId': '', 'salutation': ''}
    ];
  }

  dynamic _fd(String k) =>
      (_booking['flightDetails'] as Map<String, dynamic>?)?[k];
  dynamic _rd(String k) {
    final rfd = _booking['returnFlightDetails'] as Map<String, dynamic>?;
    if (rfd != null) return rfd[k];
    final fd = _booking['flightDetails'] as Map<String, dynamic>?;
    if (fd == null) return null;
    if (k == 'from') return fd['to'];
    if (k == 'to') return fd['from'];
    if (k == 'departure') return fd['arrival'];
    if (k == 'arrival') return fd['departure'];
    return fd[k];
  }

  String _airline(bool r) => (r ? _rd : _fd)('airline') as String? ?? 'Airline';
  String _fltNum(bool r) => (r ? _rd : _fd)('flightNumber') as String? ?? 'N/A';
  String _cabin(bool r) => (r ? _rd : _fd)('class') as String? ?? 'Economy';
  String _from(bool r) => (r ? _rd : _fd)('from') as String? ?? 'Karachi (KHI)';
  String _to(bool r) => (r ? _rd : _fd)('to') as String? ?? 'Lahore (LHE)';
  String _dep(bool r) => (r ? _rd : _fd)('departure') as String? ?? '08:00 AM';
  String _arr(bool r) => (r ? _rd : _fd)('arrival') as String? ?? '10:00 AM';
  String _duration(bool r) => (r ? _rd : _fd)('duration') as String? ?? '--';
  String _date(bool r) {
    if (r) {
      final rfd = _booking['returnFlightDetails'] as Map<String, dynamic>?;
      if (rfd?['date'] != null) return rfd!['date'] as String;
      final rd = _booking['returnDate'];
      if (rd is DateTime) return DateFormat('dd MMM yyyy').format(rd);
      return _today;
    }
    return _fd('date') as String? ?? _today;
  }

  String _code(String s) {
    final m = RegExp(r'\(([^)]+)\)').firstMatch(s);
    return m?.group(1) ?? s.substring(0, math.min(3, s.length)).toUpperCase();
  }

  String _city(String s) => s.split('(').first.trim();
  String _shortDate(String raw) {
    try {
      return DateFormat('EEE, MMM d')
          .format(DateFormat('dd MMM yyyy').parse(raw));
    } catch (_) {
      return raw;
    }
  }

  // Get seat number for a specific passenger and trip
  String _getSeatForPassenger(int passengerIndex, bool isReturn) {
    if (isReturn) {
      final returnSeats =
          (_booking['returnSeatSelections'] as List<dynamic>?) ?? [];
      if (passengerIndex < returnSeats.length) {
        final seat = returnSeats[passengerIndex] as Map<String, dynamic>?;
        return seat?['seatName'] as String? ?? 'N/A';
      }
    } else {
      final outboundSeats = _isRoundTrip
          ? ((_booking['outboundSeatSelections'] as List<dynamic>?) ?? [])
          : ((_booking['seatSelections'] as List<dynamic>?) ?? []);
      if (passengerIndex < outboundSeats.length) {
        final seat = outboundSeats[passengerIndex] as Map<String, dynamic>?;
        return seat?['seatName'] as String? ?? 'N/A';
      }
    }
    return 'N/A';
  }

  // ─── SCAFFOLD ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _T.scaffoldBg,
      appBar: _appBar(),
      body: _booking.isEmpty ? _emptyView() : _body(),
    );
  }

  PreferredSizeWidget _appBar() => AppBar(
        backgroundColor: _T.navy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 18),
          onPressed: () => Get.back(),
        ),
        title: Column(children: [
          const Text('E-Ticket',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          Text('Travello AI',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w400)),
        ]),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: 'Download PDF',
              icon: _generatingPdf
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.sim_card_download_rounded,
                      color: Colors.white),
              onPressed: _generatingPdf ? null : _downloadPdf,
            ),
          ),
        ],
      );

  Widget _emptyView() => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: _T.navy.withValues(alpha: 0.08), blurRadius: 24)
              ],
            ),
            child: Icon(Icons.airplane_ticket_outlined,
                size: 52, color: _T.blue.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 24),
          Text('No Booking Found', style: _T.value(size: 18, color: _T.navy)),
          const SizedBox(height: 6),
          Text('Complete a booking to view your e-ticket',
              style: _T.label(color: _T.textSec)),
        ]),
      );

  Widget _body() {
    final paxList = _allPassengers;
    final total = paxList.length * (_isRoundTrip ? 2 : 1);

    final List<Widget> cards = [];

    // -- Outbound tickets (one per passenger) ------------------------------
    for (int i = 0; i < paxList.length; i++) {
      final pax = paxList[i];
      final name = pax['name'] as String? ?? 'Passenger ${i + 1}';
      final doc = pax['passportOrId'] as String? ?? '';
      final seat = _getSeatForPassenger(i, false);
      if (_isRoundTrip || paxList.length > 1) {
        cards.add(_dirChip(
          label: 'OUTBOUND',
          passengerName: name,
          ticketNum: i + 1,
          totalTickets: total,
          accent: _T.navy,
          icon: Icons.flight_takeoff,
        ));
      }
      cards.add(_ticketCard(
          isReturn: false,
          passengerName: name,
          passportOrId: doc,
          seatNumber: seat));
      cards.add(const SizedBox(height: 28));
    }

    // -- Return tickets (one per passenger) --------------------------------
    if (_isRoundTrip) {
      for (int i = 0; i < paxList.length; i++) {
        final pax = paxList[i];
        final name = pax['name'] as String? ?? 'Passenger ${i + 1}';
        final doc = pax['passportOrId'] as String? ?? '';
        final seat = _getSeatForPassenger(i, true);
        cards.add(_dirChip(
          label: 'RETURN',
          passengerName: name,
          ticketNum: paxList.length + i + 1,
          totalTickets: total,
          accent: _T.emerald,
          icon: Icons.flight_land,
        ));
        cards.add(_ticketCard(
            isReturn: true,
            passengerName: name,
            passportOrId: doc,
            seatNumber: seat));
        cards.add(const SizedBox(height: 28));
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 52),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _statusBanner(),
          const SizedBox(height: 22),
          ...cards,
          _infoCard(),
          const SizedBox(height: 14),
          _footerLine(),
        ],
      ),
    );
  }

  // - Direction chip with passenger name + ticket counter -
  Widget _dirChip({
    required String label,
    required String passengerName,
    required int ticketNum,
    required int totalTickets,
    required Color accent,
    required IconData icon,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, size: 12, color: Colors.white),
              const SizedBox(width: 6),
              Text('$label  �  $passengerName',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
            ]),
          ),
          const SizedBox(width: 10),
          Text(
            'Ticket $ticketNum of $totalTickets',
            style: _T.label(color: _T.textSec),
          ),
        ]),
      );

  // ─── Status Banner ──────────────────────────────
  Widget _statusBanner() => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF047857), Color(0xFF10B981)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: _T.emerald.withValues(alpha: 0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 7)),
              ],
            ),
            child: Row(children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text('Booking Confirmed',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
                    Text('PNR: $_pnr  ·  Tap to copy',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 11)),
                  ])),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: _pnr));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Row(children: [
                      Icon(Icons.copy_rounded, color: Colors.white, size: 15),
                      SizedBox(width: 8),
                      Text('PNR copied to clipboard'),
                    ]),
                    backgroundColor: _T.navy,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    duration: const Duration(seconds: 1),
                  ));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.35)),
                  ),
                  child: const Text('COPY',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          letterSpacing: 0.5)),
                ),
              ),
            ]),
          ),
        ),
      );

  // ─── Ticket Card ────────────────────────────────
  Widget _ticketCard({
    required bool isReturn,
    required String passengerName,
    required String passportOrId,
    required String seatNumber,
  }) {
    final dep = _dep(isReturn);
    final arr = _arr(isReturn);
    final date = _date(isReturn);
    final fromFull = _from(isReturn);
    final toFull = _to(isReturn);
    final airline = _airline(isReturn);
    final fltNum = _fltNum(isReturn);
    final cabin = _cabin(isReturn);
    final dur = _duration(isReturn);
    final fromCode = _code(fromFull);
    final toCode = _code(toFull);
    final fromCity = _city(fromFull);
    final toCity = _city(toFull);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Container(
          decoration: BoxDecoration(
            color: _T.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                  color: _T.navy.withValues(alpha: 0.12),
                  blurRadius: 36,
                  offset: const Offset(0, 12)),
              BoxShadow(
                  color: _T.navy.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Column(children: [
            _cardHeader(airline, fltNum, cabin),
            _routeSection(fromCode, fromCity, toCode, toCity, dep, arr, date,
                dur, seatNumber),
            const CustomPaint(
                size: Size(double.infinity, 36), painter: _TearLine()),
            _passengerSection(dep, date, passengerName, passportOrId),
            _scanSection(fltNum, isReturn, passengerName),
          ]),
        ),
      ),
    );
  }

  // ─ Header ─
  Widget _cardHeader(String airline, String fltNum, String cabin) => Container(
        decoration: const BoxDecoration(
          gradient: _T.headerGrad,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28), topRight: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
        child: Row(children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: const Icon(Icons.flight, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(airline,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: 0.2)),
                const SizedBox(height: 5),
                Row(children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(fltNum,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8)),
                  ),
                ]),
              ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _T.emerald.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _T.emerald.withValues(alpha: 0.45)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                        color: _T.emerald, shape: BoxShape.circle)),
                const SizedBox(width: 5),
                const Text('CONFIRMED',
                    style: TextStyle(
                        color: _T.emerald,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
              ]),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(cabin,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
            ),
          ]),
        ]),
      );

  // ─ Route ─
  Widget _routeSection(
      String fromCode,
      String fromCity,
      String toCode,
      String toCity,
      String dep,
      String arr,
      String date,
      String dur,
      String seatNumber) {
    return Container(
      color: _T.surface,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 10),
      child: Column(children: [
        // City codes
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // FROM
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(fromCity,
                    overflow: TextOverflow.ellipsis, style: _T.label()),
                const SizedBox(height: 5),
                Text(fromCode, style: _T.cityCode()),
                const SizedBox(height: 6),
                Text(dep,
                    style:
                        _T.value(size: 14, color: _T.navy, w: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(date, style: _T.label()),
              ])),

          // Connector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(children: [
              Text(dur, style: _T.label()),
              const SizedBox(height: 8),
              _flightLine(),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: _T.blueLight,
                    borderRadius: BorderRadius.circular(4)),
                child: const Text('NON-STOP',
                    style: TextStyle(
                        color: _T.blue,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6)),
              ),
            ]),
          ),

          // TO
          Expanded(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(toCity,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: _T.label()),
            const SizedBox(height: 5),
            Text(toCode, style: _T.cityCode(), textAlign: TextAlign.right),
            const SizedBox(height: 6),
            Text(arr,
                style: _T.value(size: 14, color: _T.navy, w: FontWeight.w700),
                textAlign: TextAlign.right),
            const SizedBox(height: 2),
            Text(date, style: _T.label()),
          ])),
        ]),

        const SizedBox(height: 22),

        // Details chips row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
          decoration: BoxDecoration(
            color: _T.ice,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _T.border),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _chip(Icons.airline_seat_recline_extra_rounded, 'SEAT', seatNumber,
                null),
            _vDiv(),
            _chip(Icons.door_front_door_rounded, 'GATE', 'H22', _T.rose),
            _vDiv(),
            _chip(Icons.account_balance_rounded, 'TERMINAL', '3', null),
            _vDiv(),
            _chip(Icons.schedule_rounded, 'BOARDS AT', dep, _T.blue),
          ]),
        ),

        const SizedBox(height: 16),
      ]),
    );
  }

  Widget _flightLine() => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
                border: Border.all(color: _T.blue, width: 1.5),
                shape: BoxShape.circle)),
        Container(
            width: 18, height: 1.5, color: _T.blue.withValues(alpha: 0.3)),
        Container(
          padding: const EdgeInsets.all(5),
          decoration:
              const BoxDecoration(color: _T.blueLight, shape: BoxShape.circle),
          child: const Icon(Icons.flight, color: _T.blue, size: 14),
        ),
        Container(
            width: 18, height: 1.5, color: _T.blue.withValues(alpha: 0.3)),
        Container(
            width: 8,
            height: 8,
            decoration:
                const BoxDecoration(color: _T.blue, shape: BoxShape.circle)),
      ]);

  Widget _chip(IconData icon, String label, String val, Color? accent) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent ?? _T.textSec),
          const SizedBox(height: 4),
          Text(label, style: _T.label()),
          const SizedBox(height: 3),
          Text(val,
              style: _T.value(
                  size: 13, color: accent ?? _T.textPri, w: FontWeight.w800)),
        ],
      );

  Widget _vDiv() => Container(width: 1, height: 38, color: _T.border);

  // ─ Passenger + Meta ─
  Widget _passengerSection(
    String dep,
    String date,
    String passengerName,
    String passportOrId,
  ) {
    final payMethod = _booking['paymentMethod'] as String? ?? 'N/A';

    return Container(
      color: _T.surface,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFFEFF6FF), Color(0xFFFAFCFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _T.border),
          ),
          child: Row(children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: _T.blue.withValues(alpha: 0.1),
                  shape: BoxShape.circle),
              child: const Icon(Icons.person_rounded, color: _T.blue, size: 21),
            ),
            const SizedBox(width: 14),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('PASSENGER', style: _T.label()),
                  const SizedBox(height: 4),
                  Text(passengerName,
                      style: _T.value(size: 15, w: FontWeight.w700),
                      overflow: TextOverflow.ellipsis),
                ])),
            if (passportOrId.isNotEmpty)
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('PASSPORT / ID', style: _T.label()),
                const SizedBox(height: 4),
                Text(passportOrId, style: _T.value(size: 13)),
              ]),
          ]),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: _tile(Icons.person_rounded, 'THIS TICKET', '1 Passenger')),
          const SizedBox(width: 10),
          Expanded(child: _tile(Icons.payment_rounded, 'PAID VIA', payMethod)),
          const SizedBox(width: 10),
          Expanded(child: _tile(Icons.event_rounded, 'DATE', _shortDate(date))),
        ]),
        const SizedBox(height: 16),
      ]),
    );
  }

  Widget _tile(IconData icon, String label, String val) => Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: _T.ice,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _T.border),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, size: 11, color: _T.textSec),
            const SizedBox(width: 4),
            Flexible(
                child: Text(label,
                    style: _T.label(), overflow: TextOverflow.ellipsis)),
          ]),
          const SizedBox(height: 5),
          Text(val,
              style: _T.value(size: 12, w: FontWeight.w700),
              overflow: TextOverflow.ellipsis),
        ]),
      );

  // ─ Barcode + QR scan section ─
  Widget _scanSection(String fltNum, bool isReturn, String passengerName) {
    final barcodeData = '$_pnr-${isReturn ? 'R' : 'O'}-$fltNum';
    final qrData = 'TRAVELLO|PNR:$_pnr|PAX:$passengerName|FLT:$fltNum';

    return Container(
      decoration: const BoxDecoration(
        color: _T.surface,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(22, 6, 22, 26),
      child: Column(children: [
        // Divider label
        Row(children: [
          const Expanded(child: Divider(color: _T.border, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(children: [
              const Icon(Icons.qr_code_scanner_rounded,
                  size: 12, color: _T.textMuted),
              const SizedBox(width: 5),
              Text('SCAN AT GATE', style: _T.label()),
            ]),
          ),
          const Expanded(child: Divider(color: _T.border, thickness: 1)),
        ]),

        const SizedBox(height: 16),

        // Barcode | divider | QR
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            flex: 3,
            child: Column(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: barcodeData,
                  width: double.infinity,
                  height: 60,
                  drawText: false,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 7),
              Text(_pnr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3.5,
                      color: _T.textSec)),
              const SizedBox(height: 3),
              Text('Scan at boarding gate', style: _T.label()),
            ]),
          ),

          Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: 1,
              height: 80,
              color: _T.border),

          // QR code
          Column(children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _T.border, width: 1.5),
                boxShadow: [
                  BoxShadow(
                      color: _T.navy.withValues(alpha: 0.06), blurRadius: 8)
                ],
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 72,
                eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square, color: _T.navy),
                dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square, color: _T.navy),
              ),
            ),
            const SizedBox(height: 5),
            Text('QUICK SCAN', style: _T.label()),
          ]),
        ]),

        const SizedBox(height: 18),

        // Brand watermark
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                gradient:
                    const LinearGradient(colors: [_T.navy, Color(0xFF2563EB)]),
                borderRadius: BorderRadius.circular(5)),
            child: const Center(
              child: Text('T',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900)),
            ),
          ),
          const SizedBox(width: 8),
          Text('Travello AI  ·  Verified & Secure Ticket',
              style: _T.label(color: _T.textMuted)),
        ]),
      ]),
    );
  }

  // ─── Important Info Card ─────────────────────────
  Widget _infoCard() {
    final tips = [
      (Icons.schedule_rounded, 'Arrive at least 2 hours before departure'),
      (Icons.badge_rounded, 'Carry valid CNIC / Passport and this e-ticket'),
      (
        Icons.door_front_door_rounded,
        'Check-in closes 45 minutes before departure'
      ),
      (Icons.luggage_rounded, 'Baggage allowance: 20 kg checked + 7 kg cabin'),
      (
        Icons.wifi_protected_setup_rounded,
        'Web check-in opens 24 hours before departure'
      ),
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _T.surface,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                  color: _T.navy.withValues(alpha: 0.07),
                  blurRadius: 24,
                  offset: const Offset(0, 6)),
            ],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: _T.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.info_outline_rounded,
                    color: _T.amber, size: 17),
              ),
              const SizedBox(width: 12),
              Text('Travel Guidelines',
                  style:
                      _T.value(size: 14, color: _T.navy, w: FontWeight.w700)),
            ]),
            const SizedBox(height: 16),
            ...tips.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: _T.blue.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(t.$1, size: 12, color: _T.blue),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(t.$2,
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    color: _T.textSec,
                                    height: 1.45))),
                      ]),
                )),
            const Divider(color: _T.border, height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.support_agent_rounded,
                  size: 13, color: _T.textMuted),
              const SizedBox(width: 6),
              Text('support@travello.pk  ·  +92 300 1234567',
                  style: _T.label()),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _footerLine() => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Text(
            'This is an official e-ticket issued by Travello AI.\nPresent this at check-in counter.',
            textAlign: TextAlign.center,
            style: _T.label(color: _T.textMuted),
          ),
        ),
      );

  // --- PDF helper widgets ----------------------------------------------
  pw.Widget _pdfChip(String label, String val, PdfColor accent) =>
      pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
        pw.Text(label,
            style: const pw.TextStyle(
                fontSize: 7, color: PdfColor(0.392, 0.455, 0.545))),
        pw.SizedBox(height: 2),
        pw.Text(val,
            style: pw.TextStyle(
                fontSize: 10, fontWeight: pw.FontWeight.bold, color: accent)),
      ]);

  pw.Widget _pdfVDiv(PdfColor color) =>
      pw.Container(width: 1, height: 28, color: color);

  pw.Widget _pdfTile(
    String label,
    String val,
    PdfColor textSec,
    PdfColor ice,
    PdfColor border,
    PdfColor navy,
  ) =>
      pw.Container(
        padding: const pw.EdgeInsets.all(9),
        decoration: pw.BoxDecoration(
          color: ice,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          border: pw.Border.all(color: border),
        ),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(label,
                  style: pw.TextStyle(
                      fontSize: 7,
                      color: textSec,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 0.3)),
              pw.SizedBox(height: 3),
              pw.Text(val,
                  style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: navy),
                  overflow: pw.TextOverflow.clip),
            ]),
      );
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  Perforated tear-line with punch-hole notches
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _TearLine extends CustomPainter {
  const _TearLine();

  @override
  void paint(Canvas canvas, Size size) {
    const bg = _T.scaffoldBg;
    final cy = size.height / 2;
    const r = 16.0;

    // White background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.white);

    // Punch holes bleed into scaffold bg
    canvas.drawCircle(Offset(0, cy), r, Paint()..color = bg);
    canvas.drawCircle(Offset(size.width, cy), r, Paint()..color = bg);

    // Hairline border at cut edges
    final edge = Paint()
      ..color = const Color(0xFFE8EDF5)
      ..strokeWidth = 0.8;
    canvas.drawLine(const Offset(r, 0), Offset(size.width - r, 0), edge);
    canvas.drawLine(
        Offset(r, size.height), Offset(size.width - r, size.height), edge);

    // Tight dashes (printer-perforation style)
    final dash = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    double x = r + 8;
    const dw = 5.0, gap = 4.0;
    while (x < size.width - r - 8) {
      canvas.drawLine(Offset(x, cy), Offset(x + dw, cy), dash);
      x += dw + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
