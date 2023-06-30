import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:term/pdf_viewer_crm/util/url_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Uint8List> generatePdf(
    final PdfPageFormat format, String documentId) async {
  final doc = pw.Document(title: 'FLutter School');
  final font = await rootBundle.load('fonts/Roboto-BlackItalic.ttf');
  final tff = pw.Font.ttf(font);
  final pageTheme = await _myPageTheme(format);
  // final logoImage = pw.MemoryImage(
  //   (await rootBundle.load('assets/header.png')).buffer.asUint8List(),
  // );
  final snapshot = await FirebaseFirestore.instance
      .collection('reciever')
      .doc('lead_info')
      .collection('b@gmail.com')
      .doc(documentId)
      .get();

  final documentData = snapshot.data();

  // Access the document fields using the appropriate keys
  final name = documentData?['name'];
  final email = documentData?['email'];
  final phone = documentData?['phone'];
  final assignedTo = documentData?['assigned_to'];
  final street = documentData?['address']['street'];
  final area = documentData?['address']['area'];
  final label = documentData?['label'];
  final description = documentData?['description'];

  doc.addPage(pw.MultiPage(
      pageTheme: pageTheme,
      // header: (final context) => pw.Image(
      //     alignment: pw.Alignment.topLeft,
      //     logoImage,
      //     fit: pw.BoxFit.contain,
      //     width: 180),
      build: (final context) => [
            pw.Container(
                padding: const pw.EdgeInsets.only(left: 30, bottom: 20),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.only(top: 20)),
                      pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Text('Name: $name',
                                      style: pw.TextStyle(fontSize: 16)),
                                  pw.Text("Email : $email",
                                      style: pw.TextStyle(fontSize: 16)),
                                  pw.Text("Phone : $phone",
                                      style: pw.TextStyle(fontSize: 16)),
                                  pw.Text("Assigned To : $assignedTo",
                                      style: pw.TextStyle(fontSize: 16)),
                                  pw.SizedBox(height: 5),
                                  UrlText('Our official site',
                                      'https://www.zoho.com/en-in/crm/')
                                ]),
                            pw.SizedBox(width: 70),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text("Street : $street",
                                      style: pw.TextStyle(fontSize: 16)),
                                  pw.Text("Area : $area",
                                      style: pw.TextStyle(fontSize: 16)),
                                ])
                          ]),
                    ])),
            pw.Center(
                child: pw.Text('Description',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        font: tff,
                        fontSize: 30,
                        fontWeight: pw.FontWeight.bold))),
            pw.Paragraph(
                text: description,
                margin: const pw.EdgeInsets.only(top: 10),
                style: pw.TextStyle(
                  lineSpacing: 8,
                  fontSize: 16,
                )),
            pw.SizedBox(height: 20),
            pw.Center(
                child: pw.Text('Label',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        font: tff,
                        fontSize: 30,
                        fontWeight: pw.FontWeight.bold))),
            pw.Paragraph(
                text: label,
                margin: const pw.EdgeInsets.only(top: 10),
                style: pw.TextStyle(
                  lineSpacing: 8,
                  fontSize: 16,
                ))
          ]));
  return doc.save();
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  return pw.PageTheme(
      margin: const pw.EdgeInsets.symmetric(
          horizontal: 1 * PdfPageFormat.cm, vertical: 0.5 * PdfPageFormat.cm),
      textDirection: pw.TextDirection.ltr,
      orientation: pw.PageOrientation.portrait,
      buildBackground: (final context) => pw.FullPage(ignoreMargins: true));
}

Future<void> saveAsFile(final BuildContext context, final LayoutCallback build,
    final PdfPageFormat pageFormat) async {
  final bytes = await build(pageFormat);
  final appDocDir = await getApplicationDocumentsDirectory();
  final file = File('$appDocDir/download.pdf');
  print('save as file ${file.path}...');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

void showPrintedToast(final BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text("Document printed successs")));
}

void showSharedToasted(final BuildContext context) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  scaffoldMessenger.showSnackBar(
      const SnackBar(content: Text("Document shared successfully")));
}

const String bodyText =
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum';
