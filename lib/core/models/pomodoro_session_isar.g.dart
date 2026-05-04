// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_session_isar.dart';

extension GetPomodoroSessionCollection on Isar {
  IsarCollection<PomodoroSession> get pomodoroSessions => this.collection();
}

const PomodoroSessionSchema = CollectionSchema(
  name: r'PomodoroSession',
  id: -896676171469707021,
  properties: {
    r'actualDurationSeconds': PropertySchema(
      id: 0,
      name: r'actualDurationSeconds',
      type: IsarType.long,
    ),
    r'ambientSound': PropertySchema(
      id: 1,
      name: r'ambientSound',
      type: IsarType.string,
    ),
    r'endTime': PropertySchema(
      id: 2,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'isAbandoned': PropertySchema(
      id: 3,
      name: r'isAbandoned',
      type: IsarType.bool,
    ),
    r'isCompleted': PropertySchema(
      id: 4,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'linkedTaskId': PropertySchema(
      id: 5,
      name: r'linkedTaskId',
      type: IsarType.string,
    ),
    r'linkedTaskTitle': PropertySchema(
      id: 6,
      name: r'linkedTaskTitle',
      type: IsarType.string,
    ),
    r'musicTrack': PropertySchema(
      id: 7,
      name: r'musicTrack',
      type: IsarType.string,
    ),
    r'plannedDurationSeconds': PropertySchema(
      id: 8,
      name: r'plannedDurationSeconds',
      type: IsarType.long,
    ),
    r'sessionType': PropertySchema(
      id: 9,
      name: r'sessionType',
      type: IsarType.string,
    ),
    r'startTime': PropertySchema(
      id: 10,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'uuid': PropertySchema(
      id: 11,
      name: r'uuid',
      type: IsarType.string,
    ),
  },
  estimateSize: _pomodoroSessionEstimateSize,
  serialize: _pomodoroSessionSerialize,
  deserialize: _pomodoroSessionDeserialize,
  deserializeProp: _pomodoroSessionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _pomodoroSessionGetId,
  getLinks: _pomodoroSessionGetLinks,
  attach: _pomodoroSessionAttach,
  version: '3.1.0+1',
);

int _pomodoroSessionEstimateSize(
  PomodoroSession object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  final ambientSound = object.ambientSound;
  if (ambientSound != null) {
    bytesCount += 3 + ambientSound.length * 3;
  }
  final linkedTaskId = object.linkedTaskId;
  if (linkedTaskId != null) {
    bytesCount += 3 + linkedTaskId.length * 3;
  }
  final linkedTaskTitle = object.linkedTaskTitle;
  if (linkedTaskTitle != null) {
    bytesCount += 3 + linkedTaskTitle.length * 3;
  }
  final musicTrack = object.musicTrack;
  if (musicTrack != null) {
    bytesCount += 3 + musicTrack.length * 3;
  }
  bytesCount += 3 + object.sessionType.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _pomodoroSessionSerialize(
  PomodoroSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.actualDurationSeconds);
  writer.writeString(offsets[1], object.ambientSound);
  writer.writeDateTime(offsets[2], object.endTime);
  writer.writeBool(offsets[3], object.isAbandoned);
  writer.writeBool(offsets[4], object.isCompleted);
  writer.writeString(offsets[5], object.linkedTaskId);
  writer.writeString(offsets[6], object.linkedTaskTitle);
  writer.writeString(offsets[7], object.musicTrack);
  writer.writeLong(offsets[8], object.plannedDurationSeconds);
  writer.writeString(offsets[9], object.sessionType);
  writer.writeDateTime(offsets[10], object.startTime);
  writer.writeString(offsets[11], object.uuid);
}

PomodoroSession _pomodoroSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PomodoroSession();
  object.actualDurationSeconds = reader.readLong(offsets[0]);
  object.ambientSound = reader.readStringOrNull(offsets[1]);
  object.endTime = reader.readDateTimeOrNull(offsets[2]);
  object.id = id;
  object.isAbandoned = reader.readBool(offsets[3]);
  object.isCompleted = reader.readBool(offsets[4]);
  object.linkedTaskId = reader.readStringOrNull(offsets[5]);
  object.linkedTaskTitle = reader.readStringOrNull(offsets[6]);
  object.musicTrack = reader.readStringOrNull(offsets[7]);
  object.plannedDurationSeconds = reader.readLong(offsets[8]);
  object.sessionType = reader.readString(offsets[9]);
  object.startTime = reader.readDateTime(offsets[10]);
  object.uuid = reader.readString(offsets[11]);
  return object;
}

P _pomodoroSessionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pomodoroSessionGetId(PomodoroSession object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pomodoroSessionGetLinks(PomodoroSession object) {
  return [];
}

void _pomodoroSessionAttach(
  IsarCollection<dynamic> col,
  Id id,
  PomodoroSession object,
) {
  object.id = id;
}
