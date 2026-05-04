// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_goal_settings_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFocusGoalSettingsCollection on Isar {
  IsarCollection<FocusGoalSettings> get focusGoalSettings => this.collection();
}

const FocusGoalSettingsSchema = CollectionSchema(
  name: r'FocusGoalSettings',
  id: -3864501955897655363,
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
    )
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
  {
    final value = object.lastAmbientSound;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
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
    FocusGoalSettings object) {
  return [];
}

void _focusGoalSettingsAttach(
    IsarCollection<dynamic> col, Id id, FocusGoalSettings object) {
  object.id = id;
}

extension FocusGoalSettingsQueryWhereSort
    on QueryBuilder<FocusGoalSettings, FocusGoalSettings, QWhere> {
  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FocusGoalSettingsQueryWhere
    on QueryBuilder<FocusGoalSettings, FocusGoalSettings, QWhereClause> {
  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FocusGoalSettingsQueryFilter
    on QueryBuilder<FocusGoalSettings, FocusGoalSettings, QFilterCondition> {
  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      ambientVolumeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ambientVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      ambientVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ambientVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      ambientVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ambientVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      ambientVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ambientVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      autoStartBreaksEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoStartBreaks',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      autoStartFocusEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoStartFocus',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      dailySessionGoalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailySessionGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      dailySessionGoalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailySessionGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      dailySessionGoalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailySessionGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      dailySessionGoalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailySessionGoal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      focusDurationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'focusDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      focusDurationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'focusDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      focusDurationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'focusDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      focusDurationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'focusDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      killTimestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'killTimestamp',
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      killTimestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'killTimestamp',
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      killTimestampEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'killTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      killTimestampGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'killTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      killTimestampLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'killTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      killTimestampBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'killTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      lastAmbientSoundIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastAmbientSound',
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      lastAmbientSoundIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastAmbientSound',
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      lastAmbientSoundEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAmbientSound',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      lastAmbientSoundGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastAmbientSound',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      lastAmbientSoundLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastAmbientSound',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      lastAmbientSoundBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastAmbientSound',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      lastAmbientSoundStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastAmbientSound',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      lastAmbientSoundEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastAmbientSound',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      lastAmbientSoundContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastAmbientSound',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      lastAmbientSoundMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastAmbientSound',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      lastAmbientSoundIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAmbientSound',
        value: '',
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      lastAmbientSoundIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastAmbientSound',
        value: '',
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      longBreakDurationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longBreakDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      longBreakDurationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longBreakDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      longBreakDurationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longBreakDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      longBreakDurationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longBreakDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      longBreakIntervalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longBreakInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      longBreakIntervalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longBreakInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      longBreakIntervalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longBreakInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      longBreakIntervalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longBreakInterval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      musicVolumeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'musicVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      musicVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'musicVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      musicVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'musicVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      musicVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'musicVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      remainingSecondsOnKillEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remainingSecondsOnKill',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      remainingSecondsOnKillGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remainingSecondsOnKill',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      remainingSecondsOnKillLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remainingSecondsOnKill',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      remainingSecondsOnKillBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remainingSecondsOnKill',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      sessionTypeOnKillEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionTypeOnKill',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      sessionTypeOnKillGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionTypeOnKill',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      sessionTypeOnKillLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionTypeOnKill',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      sessionTypeOnKillBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionTypeOnKill',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      sessionTypeOnKillStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sessionTypeOnKill',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      sessionTypeOnKillEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sessionTypeOnKill',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      sessionTypeOnKillContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sessionTypeOnKill',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      sessionTypeOnKillMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sessionTypeOnKill',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      sessionTypeOnKillIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionTypeOnKill',
        value: '',
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      sessionTypeOnKillIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sessionTypeOnKill',
        value: '',
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      shortBreakDurationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shortBreakDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      shortBreakDurationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shortBreakDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      shortBreakDurationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shortBreakDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      shortBreakDurationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shortBreakDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterFilterCondition>
      wasTimerRunningEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wasTimerRunning',
        value: value,
      ));
    });
  }
}

extension FocusGoalSettingsQueryObject
    on QueryBuilder<FocusGoalSettings, FocusGoalSettings, QFilterCondition> {}

extension FocusGoalSettingsQueryLinks
    on QueryBuilder<FocusGoalSettings, FocusGoalSettings, QFilterCondition> {}

extension FocusGoalSettingsQuerySortBy
    on QueryBuilder<FocusGoalSettings, FocusGoalSettings, QSortBy> {
  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByAmbientVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ambientVolume', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByAmbientVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ambientVolume', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByAutoStartBreaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartBreaks', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByAutoStartBreaksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartBreaks', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByAutoStartFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartFocus', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByAutoStartFocusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartFocus', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByDailySessionGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySessionGoal', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByDailySessionGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySessionGoal', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByFocusDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusDuration', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByFocusDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusDuration', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByKillTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'killTimestamp', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByKillTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'killTimestamp', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByLastAmbientSound() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAmbientSound', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByLastAmbientSoundDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAmbientSound', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByLongBreakDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakDuration', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByLongBreakDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakDuration', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByLongBreakInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakInterval', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByLongBreakIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakInterval', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByMusicVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musicVolume', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByMusicVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musicVolume', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByRemainingSecondsOnKill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingSecondsOnKill', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByRemainingSecondsOnKillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingSecondsOnKill', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortBySessionTypeOnKill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionTypeOnKill', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortBySessionTypeOnKillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionTypeOnKill', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByShortBreakDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortBreakDuration', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByShortBreakDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortBreakDuration', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByWasTimerRunning() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasTimerRunning', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      sortByWasTimerRunningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasTimerRunning', Sort.desc);
    });
  }
}

extension FocusGoalSettingsQuerySortThenBy
    on QueryBuilder<FocusGoalSettings, FocusGoalSettings, QSortThenBy> {
  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByAmbientVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ambientVolume', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByAmbientVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ambientVolume', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByAutoStartBreaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartBreaks', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByAutoStartBreaksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartBreaks', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByAutoStartFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartFocus', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByAutoStartFocusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartFocus', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByDailySessionGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySessionGoal', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByDailySessionGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySessionGoal', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByFocusDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusDuration', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByFocusDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusDuration', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByKillTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'killTimestamp', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByKillTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'killTimestamp', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByLastAmbientSound() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAmbientSound', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByLastAmbientSoundDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAmbientSound', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByLongBreakDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakDuration', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByLongBreakDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakDuration', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByLongBreakInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakInterval', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByLongBreakIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakInterval', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByMusicVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musicVolume', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByMusicVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musicVolume', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByRemainingSecondsOnKill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingSecondsOnKill', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByRemainingSecondsOnKillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingSecondsOnKill', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenBySessionTypeOnKill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionTypeOnKill', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenBySessionTypeOnKillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionTypeOnKill', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByShortBreakDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortBreakDuration', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByShortBreakDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortBreakDuration', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByWasTimerRunning() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasTimerRunning', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QAfterSortBy>
      thenByWasTimerRunningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasTimerRunning', Sort.desc);
    });
  }
}

extension FocusGoalSettingsQueryWhereDistinct
    on QueryBuilder<FocusGoalSettings, FocusGoalSettings, QDistinct> {
  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QDistinct>
      distinctByAmbientVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ambientVolume');
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QDistinct>
      distinctByAutoStartBreaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoStartBreaks');
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QDistinct>
      distinctByAutoStartFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoStartFocus');
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QDistinct>
      distinctByDailySessionGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailySessionGoal');
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QDistinct>
      distinctByFocusDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focusDuration');
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QDistinct>
      distinctByKillTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'killTimestamp');
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QDistinct>
      distinctByLastAmbientSound({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAmbientSound',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QDistinct>
      distinctByLongBreakDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longBreakDuration');
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QDistinct>
      distinctByLongBreakInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longBreakInterval');
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QDistinct>
      distinctByMusicVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'musicVolume');
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QDistinct>
      distinctByRemainingSecondsOnKill() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remainingSecondsOnKill');
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QDistinct>
      distinctBySessionTypeOnKill({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionTypeOnKill',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QDistinct>
      distinctByShortBreakDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shortBreakDuration');
    });
  }

  QueryBuilder<FocusGoalSettings, FocusGoalSettings, QDistinct>
      distinctByWasTimerRunning() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wasTimerRunning');
    });
  }
}

extension FocusGoalSettingsQueryProperty
    on QueryBuilder<FocusGoalSettings, FocusGoalSettings, QQueryProperty> {
  QueryBuilder<FocusGoalSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FocusGoalSettings, double, QQueryOperations>
      ambientVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ambientVolume');
    });
  }

  QueryBuilder<FocusGoalSettings, bool, QQueryOperations>
      autoStartBreaksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoStartBreaks');
    });
  }

  QueryBuilder<FocusGoalSettings, bool, QQueryOperations>
      autoStartFocusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoStartFocus');
    });
  }

  QueryBuilder<FocusGoalSettings, int, QQueryOperations>
      dailySessionGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailySessionGoal');
    });
  }

  QueryBuilder<FocusGoalSettings, int, QQueryOperations>
      focusDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focusDuration');
    });
  }

  QueryBuilder<FocusGoalSettings, DateTime?, QQueryOperations>
      killTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'killTimestamp');
    });
  }

  QueryBuilder<FocusGoalSettings, String?, QQueryOperations>
      lastAmbientSoundProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAmbientSound');
    });
  }

  QueryBuilder<FocusGoalSettings, int, QQueryOperations>
      longBreakDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longBreakDuration');
    });
  }

  QueryBuilder<FocusGoalSettings, int, QQueryOperations>
      longBreakIntervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longBreakInterval');
    });
  }

  QueryBuilder<FocusGoalSettings, double, QQueryOperations>
      musicVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'musicVolume');
    });
  }

  QueryBuilder<FocusGoalSettings, int, QQueryOperations>
      remainingSecondsOnKillProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remainingSecondsOnKill');
    });
  }

  QueryBuilder<FocusGoalSettings, String, QQueryOperations>
      sessionTypeOnKillProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionTypeOnKill');
    });
  }

  QueryBuilder<FocusGoalSettings, int, QQueryOperations>
      shortBreakDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shortBreakDuration');
    });
  }

  QueryBuilder<FocusGoalSettings, bool, QQueryOperations>
      wasTimerRunningProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wasTimerRunning');
    });
  }
}
