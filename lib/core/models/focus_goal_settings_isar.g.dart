// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_goal_settings_isar.dart';

extension GetFocusGoalSettingsCollection on Isar {
  IsarCollection<FocusGoalSettings> get focusGoalSettings => this.collection();
}

const FocusGoalSettingsSchema = CollectionSchema(
  name: r'FocusGoalSettings',
  id: 4107968212558675521,
  properties: {
    r'ambientVolume': PropertySchema(
      id: 0,
      name: r'ambientVolume',
      type: IsarType.double,
    ),
    r'autoStartBreaks': PropertySchema(
      id: 1,
      name: r'autoStartBreaks',
      type: IsarType.bool,
    ),
    r'autoStartFocus': PropertySchema(
      id: 2,
      name: r'autoStartFocus',
      type: IsarType.bool,
    ),
    r'dailySessionGoal': PropertySchema(
      id: 3,
      name: r'dailySessionGoal',
      type: IsarType.long,
    ),
    r'focusDuration': PropertySchema(
      id: 4,
      name: r'focusDuration',
      type: IsarType.long,
    ),
    r'killTimestamp': PropertySchema(
      id: 5,
      name: r'killTimestamp',
      type: IsarType.dateTime,
    ),
    r'lastAmbientSound': PropertySchema(
      id: 6,
      name: r'lastAmbientSound',
      type: IsarType.string,
    ),
    r'longBreakDuration': PropertySchema(
      id: 7,
      name: r'longBreakDuration',
      type: IsarType.long,
    ),
    r'longBreakInterval': PropertySchema(
      id: 8,
      name: r'longBreakInterval',
      type: IsarType.long,
    ),
    r'musicVolume': PropertySchema(
      id: 9,
      name: r'musicVolume',
      type: IsarType.double,
    ),
    r'remainingSecondsOnKill': PropertySchema(
      id: 10,
      name: r'remainingSecondsOnKill',
      type: IsarType.long,
    ),
    r'sessionTypeOnKill': PropertySchema(
      id: 11,
      name: r'sessionTypeOnKill',
      type: IsarType.string,
    ),
    r'shortBreakDuration': PropertySchema(
      id: 12,
      name: r'shortBreakDuration',
      type: IsarType.long,
    ),
    r'wasTimerRunning': PropertySchema(
      id: 13,
      name: r'wasTimerRunning',
      type: IsarType.bool,
    ),
  },
  estimateSize: _focusGoalSettingsEstimateSize,
  serialize: _focusGoalSettingsSerialize,
  deserialize: _focusGoalSettingsDeserialize,
  deserializeProp: _focusGoalSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _focusGoalSettingsGetId,
  getLinks: _focusGoalSettingsGetLinks,
  attach: _focusGoalSettingsAttach,
  version: '3.1.0+1',
);

int _focusGoalSettingsEstimateSize(
  FocusGoalSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  final sound = object.lastAmbientSound;
  if (sound != null) {
    bytesCount += 3 + sound.length * 3;
  }
  bytesCount += 3 + object.sessionTypeOnKill.length * 3;
  return bytesCount;
}

void _focusGoalSettingsSerialize(
  FocusGoalSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.ambientVolume);
  writer.writeBool(offsets[1], object.autoStartBreaks);
  writer.writeBool(offsets[2], object.autoStartFocus);
  writer.writeLong(offsets[3], object.dailySessionGoal);
  writer.writeLong(offsets[4], object.focusDuration);
  writer.writeDateTime(offsets[5], object.killTimestamp);
  writer.writeString(offsets[6], object.lastAmbientSound);
  writer.writeLong(offsets[7], object.longBreakDuration);
  writer.writeLong(offsets[8], object.longBreakInterval);
  writer.writeDouble(offsets[9], object.musicVolume);
  writer.writeLong(offsets[10], object.remainingSecondsOnKill);
  writer.writeString(offsets[11], object.sessionTypeOnKill);
  writer.writeLong(offsets[12], object.shortBreakDuration);
  writer.writeBool(offsets[13], object.wasTimerRunning);
}

FocusGoalSettings _focusGoalSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FocusGoalSettings();
  object.ambientVolume = reader.readDouble(offsets[0]);
  object.autoStartBreaks = reader.readBool(offsets[1]);
  object.autoStartFocus = reader.readBool(offsets[2]);
  object.dailySessionGoal = reader.readLong(offsets[3]);
  object.focusDuration = reader.readLong(offsets[4]);
  object.id = id;
  object.killTimestamp = reader.readDateTimeOrNull(offsets[5]);
  object.lastAmbientSound = reader.readStringOrNull(offsets[6]);
  object.longBreakDuration = reader.readLong(offsets[7]);
  object.longBreakInterval = reader.readLong(offsets[8]);
  object.musicVolume = reader.readDouble(offsets[9]);
  object.remainingSecondsOnKill = reader.readLong(offsets[10]);
  object.sessionTypeOnKill = reader.readString(offsets[11]);
  object.shortBreakDuration = reader.readLong(offsets[12]);
  object.wasTimerRunning = reader.readBool(offsets[13]);
  return object;
}

P _focusGoalSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _focusGoalSettingsGetId(FocusGoalSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _focusGoalSettingsGetLinks(
  FocusGoalSettings object,
) {
  return [];
}

void _focusGoalSettingsAttach(
  IsarCollection<dynamic> col,
  Id id,
  FocusGoalSettings object,
) {
  object.id = id;
}
