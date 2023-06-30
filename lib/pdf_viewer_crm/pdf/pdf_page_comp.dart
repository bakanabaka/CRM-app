import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:term/pdf_viewer_crm/util/util.dart';
import 'package:term/pdf_viewer_crm/util/util_comp.dart';

class PdfPage2 extends StatefulWidget {
  final String documentId;

  const PdfPage2({Key? key, required this.documentId}) : super(key: key);

  @override
  State<PdfPage2> createState() => _PdfPage2State();
}

class _PdfPage2State extends State<PdfPage2> {
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
        const PdfPreviewAction(icon: Icon(Icons.save), onPressed: saveAsFile1)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Print Report"),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: actions,
        onPrinted: showPrintedToast1,
        onShared: showSharedToasted1,
        build: (format) => generatePdf1(format, widget.documentId),
      ),
    );
  }
}
