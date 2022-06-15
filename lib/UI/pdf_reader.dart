import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:school_1/values/strings.dart';

class PDFReader extends StatefulWidget {

  static final route = 'pdfReader';
  String url;
  PDFReader({this.url});

  @override
  _PDFReaderState createState() => _PDFReaderState();
}

class _PDFReaderState extends State<PDFReader> {
  PDFDocument _document;
  bool _loading;

  @override
  void initState() {
    super.initState();
    _initPDF();
  }

   _initPDF() async {
    setState(() {
      _loading = true;
    });
    final doc = await PDFDocument.fromURL(widget.url);
    setState(() {
      _document = doc ;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title : Text(ArStrings.get('pdf_reader')) ,
        ),
        body:_loading? Center(child: CircularProgressIndicator(),):
        PDFViewer(
          document: _document,
        ),
      )
    );
  }
}