import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class UrlText extends pw.StatelessWidget {
  final String text;
  final String url;
  UrlText(this.text, this.url);

  @override
  pw.Widget build(final pw.Context context) => pw.UrlLink(
      destination: url,
      child: pw.Text(text,
          style: const pw.TextStyle(
              decoration: pw.TextDecoration.underline,
              color: PdfColors.blue,
              fontSize: 16)));
}
