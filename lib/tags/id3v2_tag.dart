import 'package:zooper_flutter_id3/exceptions/unsupported_version_exception.dart';
import 'package:zooper_flutter_id3/frames/id3_frame.dart';
import 'package:zooper_flutter_id3/frames/id3v2_frame.dart';
import 'package:zooper_flutter_id3/headers/id3_header.dart';
import 'package:zooper_flutter_id3/headers/id3v2_header.dart';
import 'package:zooper_flutter_id3/tags/id3_tag.dart';

abstract class Id3v2Tag extends Id3Tag {
  late int _fullSize;

  /// Decodes the Id3v2Tag
  factory Id3v2Tag.decode(
    List<int> bytes,
    int startIndex,
  ) {
    var header = Id3v2Header(bytes, 0);

    if (header.majorVersion == 4) {
      return Id3v24Tag(header, bytes, startIndex, header.size);
    } else if (header.majorVersion == 3) {
      return Id3v23Tag(header, bytes, startIndex, header.size);
    }

    // TODO implement other versions

    throw UnsupportedVersionException(header.version);
  }

  Id3v2Tag(Id3Header header, List<int> bytes, int startIndex, int size) : super(header) {
    decode(bytes, 10, size);
  }

  /// Returns the full size of the v2 tag
  ///
  /// Because other softwares are setting the wrong tag size or padding
  /// this is needed in order to extract ALL audio data
  int get fullSize => _fullSize;

  void decode(List<int> bytes, int startIndex, int size) {
    bool hasNextFrame = true;

    var start = startIndex;

    while (hasNextFrame) {
      var frame = _decodeFrame(header, bytes, start);

      if (frame == null) {
        hasNextFrame = false;
        break;
      }

      print('Frame: ${frame.id3v2FrameHeader}');

      frames.add(frame);

      start += frame.frameSize;
      hasNextFrame = start < size;
    }

    // Extract the padding
    var indexOfPaddingEnd = _getIndexOfPaddingEnd(bytes, start);
    _fullSize = indexOfPaddingEnd;
  }

  Id3v2Frame? _decodeFrame(Id3Header header, List<int> bytes, int start) {
    try {
      return Id3v2Frame.decode(header, bytes, start);
    } catch (exception) {
      return null;
    }
  }

  int _getIndexOfPaddingEnd(List<int> bytes, int start) {
    return bytes.indexWhere((element) => element != 0, start);
  }
}

class Id3v24Tag extends Id3v2Tag {
  Id3v24Tag(
    Id3Header header,
    List<int> bytes,
    int startIndex,
    int size,
  ) : super(header, bytes, startIndex, size);

  @override
  bool isFrameSupported(Id3Frame frame) {
    // TODO: implement isFrameSupported
    throw UnimplementedError();
  }

  @override
  List<int> toByteList() {
    // TODO: implement toByteList
    throw UnimplementedError();
  }
}

class Id3v23Tag extends Id3v2Tag {
  Id3v23Tag(
    Id3Header header,
    List<int> bytes,
    int startIndex,
    int size,
  ) : super(header, bytes, startIndex, size);

  @override
  bool isFrameSupported(Id3Frame frame) {
    // TODO: implement isFrameSupported
    throw UnimplementedError();
  }

  @override
  List<int> toByteList() {
    // TODO: implement toByteList
    throw UnimplementedError();
  }
}
