import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:skan/data/scan_file.dart';
import 'package:skan/pages/image_view.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/text_recognision_block.dart';

class ItemView extends StatefulWidget {
  final ScanFile scanFile;

  const ItemView({Key? key, required this.scanFile}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ItemViewState();
}

class ItemViewState extends State<ItemView> {
  Future<String> _saveImageToPdf() async {
    if (kDebugMode) {
      print("Image");
    }
    final pdf = pw.Document();

    for (int i = 0; i < widget.scanFile.files.length; i++) {
      final image = pw.MemoryImage(
        File(widget.scanFile.files[i]).readAsBytesSync(),
      );
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(image));
        },
      ));
    }

    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/${widget.scanFile.name}_scan.pdf');
    await file.writeAsBytes(await pdf.save());
    if (kDebugMode) {
      print(file.path);
    }
    return file.path;
  }

  Future<String> _saveTextToPdf() async {
    if (kDebugMode) {
      print("Text");
    }
    final pdf = pw.Document();
    for (int i = 0; i < widget.scanFile.trb.length; i++) {
      String lines = "";
      for (TextRecognisionBlock trb in widget.scanFile.trb[i]) {
        for (String line in trb.lines) {
          lines += line + '\n';
        }
      }
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Text(lines); // Center
          }));
    }
    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/${widget.scanFile.name}_scan.pdf');
    await file.writeAsBytes(await pdf.save());
    if (kDebugMode) {
      print(file.path);
    }
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    double widthSize = (MediaQuery.of(context).size.width - 48) / 3;
    double heightSize = (widthSize / 9) * 14;

    return Container(
      decoration:
          BoxDecoration(color: AdaptiveTheme.of(context).theme.backgroundColor),
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top, left: 8, right: 8),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxHeight: 75),
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: AdaptiveTheme.of(context).theme.primaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.scanFile.name,
                  style: AdaptiveTheme.of(context).theme.textTheme.headline1,
                )
              ],
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int i = 0; i < widget.scanFile.files.length; i++)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageView(
                                  scanFile: widget.scanFile,
                                  index: i,
                                )));
                  },
                  child: Container(
                      height: heightSize,
                      width: widthSize,
                      child: ClipRRect(
                        child: FutureBuilder(
                          future: widget.scanFile.getScanLocation(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image.file(
                                File(
                                    "${snapshot.data}/${widget.scanFile.files[i]}"),
                                fit: BoxFit.fill,
                              );
                            }
                            return const Text("Czekam");
                          },
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: AdaptiveTheme.of(context).theme.backgroundColor,
                      )),
                ),
            ],
          ),
          GestureDetector(
              onTap: () async {
                String path = await _saveImageToPdf();
                if (kDebugMode) {
                  print(path);
                }
                final snackBar = SnackBar(
                  content: Text('Plik zapisany: $path'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                OpenFile.open(path);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(top: 14),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  color: AdaptiveTheme.of(context).theme.primaryColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 15,
                      children: [
                        FaIcon(FontAwesomeIcons.fileImage,
                            size: 24,
                            color: AdaptiveTheme.of(context)
                                .theme
                                .iconTheme
                                .color),
                        Text(
                          "Zapisz zdjęcia do pliku",
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .headline1,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ))
                  ],
                ),
              )),
          GestureDetector(
              onTap: () async {
                String path = await _saveTextToPdf();
                if (kDebugMode) {
                  print(path);
                }
                final snackBar = SnackBar(
                  content: Text('Plik zapisany: $path'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                OpenFile.open(path);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(top: 14),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  color: AdaptiveTheme.of(context).theme.primaryColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 15,
                      children: [
                        FaIcon(FontAwesomeIcons.fileLines,
                            size: 24,
                            color: AdaptiveTheme.of(context)
                                .theme
                                .iconTheme
                                .color),
                        Text(
                          "Zapisz tekst do pliku",
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .headline1,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
