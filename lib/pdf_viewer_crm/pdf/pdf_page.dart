import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:term/pdf_viewer_crm/util/util.dart';

class PdfPage1 extends StatefulWidget {
  final String documentId;

  const PdfPage1({Key? key, required this.documentId}) : super(key: key);

  @override
  State<PdfPage1> createState() => _PdfPage1State();
}

class _PdfPage1State extends State<PdfPage1> {
  PrintingInfo? printingInfo;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        const PdfPreviewAction(icon: Icon(Icons.save), onPressed: saveAsFile)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Print Report"),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: actions,
        onPrinted: showPrintedToast,
        onShared: showSharedToasted,
        build: (format) => generatePdf(format, widget.documentId),
      ),
    );
  }
}
