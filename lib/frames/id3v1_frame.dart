import 'package:zooper_flutter_id3/frames/contents/frame_content.dart';
import 'package:zooper_flutter_id3/frames/contents/id3v1_frame_content.dart';
import 'package:zooper_flutter_id3/frames/frame_identifier.dart';
import 'package:zooper_flutter_id3/frames/headers/id3v1_frame_header.dart';
import 'package:zooper_flutter_id3/headers/id3_header.dart';

import 'headers/frame_header.dart';
import 'id3_frame.dart';

class Id3v1Frame<T> extends Id3Frame {
  late T value;

  factory Id3v1Frame.decode(Id3Header header, List<int> bytes, int startIndex, FrameIdentifier identifier) {
    // Decode the header
    var frameHeader = Id3v1FrameHeader(
      header,
      identifier,
    );

    // Decode the content
    var frameContent = Id3v1FrameContent.decode(
      header,
      frameHeader,
      bytes,
      startIndex,
    );

    return Id3v1Frame(header, frameHeader, frameContent);
  }

  Id3v1Frame(Id3Header header, FrameHeader frameHeader, FrameContent frameContent)
      : super(header, frameHeader, frameContent);

  @override
  List<int> encode() {
    // TODO: implement
    throw UnimplementedError();
  }
}
