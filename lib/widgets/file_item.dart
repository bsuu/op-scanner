

import 'package:flutter/cupertino.dart';
import 'package:skan/states/file_item_state.dart';

enum STATUS {
  RUNNING,
  DONE,
  SADGE
}

class FileItem extends StatefulWidget {


  FileItem({
    Key? key,
    required this.file_name,
    required this.file_type,
    required this.transcription,
    required this.upload,
    this.file_lang,


  }) : super(key: key);

  final String file_name;
  final String file_type;

  STATUS upload;
  STATUS transcription;

  var file_lang;

  @override
  State<StatefulWidget> createState() => FileItemState();
}