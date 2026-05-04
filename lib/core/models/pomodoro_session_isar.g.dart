// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_session_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

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
    r'endTime': PropertySchema(
      id: 1,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'isAbandoned': PropertySchema(
      id: 2,
      name: r'isAbandoned',
      type: IsarType.bool,
    ),
    r'isCompleted': PropertySchema(
      id: 3,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'linkedTaskId': PropertySchema(
      id: 4,
      name: r'linkedTaskId',
      type: IsarType.string,
    ),
    r'linkedTaskTitle': PropertySchema(
      id: 5,
      name: r'linkedTaskTitle',
      type: IsarType.string,
    ),
    r'plannedDurationSeconds': PropertySchema(
      id: 6,
      name: r'plannedDurationSeconds',
      type: IsarType.long,
    ),
    r'sessionType': PropertySchema(
      id: 7,
      name: r'sessionType',
      type: IsarType.string,
    ),
    r'startTime': PropertySchema(
      id: 8,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'uuid': PropertySchema(
      id: 9,
      name: r'uuid',
      type: IsarType.string,
    )
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
  {
    final value = object.linkedTaskId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.linkedTaskTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
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
  writer.writeDateTime(offsets[1], object.endTime);
  writer.writeBool(offsets[2], object.isAbandoned);
  writer.writeBool(offsets[3], object.isCompleted);
  writer.writeString(offsets[4], object.linkedTaskId);
  writer.writeString(offsets[5], object.linkedTaskTitle);
  writer.writeLong(offsets[6], object.plannedDurationSeconds);
  writer.writeString(offsets[7], object.sessionType);
  writer.writeDateTime(offsets[8], object.startTime);
  writer.writeString(offsets[9], object.uuid);
}

PomodoroSession _pomodoroSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PomodoroSession();
  object.actualDurationSeconds = reader.readLong(offsets[0]);
  object.endTime = reader.readDateTimeOrNull(offsets[1]);
  object.id = id;
  object.isAbandoned = reader.readBool(offsets[2]);
  object.isCompleted = reader.readBool(offsets[3]);
  object.linkedTaskId = reader.readStringOrNull(offsets[4]);
  object.linkedTaskTitle = reader.readStringOrNull(offsets[5]);
  object.plannedDurationSeconds = reader.readLong(offsets[6]);
  object.sessionType = reader.readString(offsets[7]);
  object.startTime = reader.readDateTime(offsets[8]);
  object.uuid = reader.readString(offsets[9]);
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
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
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
    IsarCollection<dynamic> col, Id id, PomodoroSession object) {
  object.id = id;
}

extension PomodoroSessionQueryWhereSort
    on QueryBuilder<PomodoroSession, PomodoroSession, QWhere> {
  QueryBuilder<PomodoroSession, PomodoroSession, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PomodoroSessionQueryWhere
    on QueryBuilder<PomodoroSession, PomodoroSession, QWhereClause> {
  QueryBuilder<PomodoroSession, PomodoroSession, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterWhereClause>
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

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterWhereClause> idBetween(
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

extension PomodoroSessionQueryFilter
    on QueryBuilder<PomodoroSession, PomodoroSession, QFilterCondition> {
  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      actualDurationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      actualDurationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actualDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      actualDurationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actualDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      actualDurationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actualDurationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      endTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      endTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      endTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      endTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
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

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
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

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
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

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      isAbandonedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAbandoned',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'linkedTaskId',
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'linkedTaskId',
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'linkedTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'linkedTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'linkedTaskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'linkedTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'linkedTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'linkedTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'linkedTaskId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedTaskId',
        value: '',
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'linkedTaskId',
        value: '',
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'linkedTaskTitle',
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'linkedTaskTitle',
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskTitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedTaskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'linkedTaskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'linkedTaskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'linkedTaskTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'linkedTaskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'linkedTaskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'linkedTaskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'linkedTaskTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedTaskTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'linkedTaskTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      plannedDurationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plannedDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      plannedDurationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plannedDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      plannedDurationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plannedDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      plannedDurationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plannedDurationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      sessionTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      sessionTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      sessionTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      sessionTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      sessionTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sessionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      sessionTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sessionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      sessionTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sessionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      sessionTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sessionType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      sessionTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionType',
        value: '',
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      sessionTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sessionType',
        value: '',
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      startTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      startTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      startTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      uuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension PomodoroSessionQueryObject
    on QueryBuilder<PomodoroSession, PomodoroSession, QFilterCondition> {}

extension PomodoroSessionQueryLinks
    on QueryBuilder<PomodoroSession, PomodoroSession, QFilterCondition> {}

extension PomodoroSessionQuerySortBy
    on QueryBuilder<PomodoroSession, PomodoroSession, QSortBy> {
  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByActualDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByActualDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByIsAbandoned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAbandoned', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByIsAbandonedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAbandoned', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByLinkedTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTaskId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByLinkedTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTaskId', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByLinkedTaskTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTaskTitle', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByLinkedTaskTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTaskTitle', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByPlannedDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByPlannedDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortBySessionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionType', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortBySessionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionType', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PomodoroSessionQuerySortThenBy
    on QueryBuilder<PomodoroSession, PomodoroSession, QSortThenBy> {
  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByActualDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByActualDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByIsAbandoned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAbandoned', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByIsAbandonedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAbandoned', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByLinkedTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTaskId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByLinkedTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTaskId', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByLinkedTaskTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTaskTitle', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByLinkedTaskTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTaskTitle', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByPlannedDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByPlannedDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenBySessionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionType', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenBySessionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionType', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PomodoroSessionQueryWhereDistinct
    on QueryBuilder<PomodoroSession, PomodoroSession, QDistinct> {
  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct>
      distinctByActualDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualDurationSeconds');
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct>
      distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct>
      distinctByIsAbandoned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAbandoned');
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct>
      distinctByLinkedTaskId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linkedTaskId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct>
      distinctByLinkedTaskTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linkedTaskTitle',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct>
      distinctByPlannedDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedDurationSeconds');
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct>
      distinctBySessionType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct>
      distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension PomodoroSessionQueryProperty
    on QueryBuilder<PomodoroSession, PomodoroSession, QQueryProperty> {
  QueryBuilder<PomodoroSession, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PomodoroSession, int, QQueryOperations>
      actualDurationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualDurationSeconds');
    });
  }

  QueryBuilder<PomodoroSession, DateTime?, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<PomodoroSession, bool, QQueryOperations> isAbandonedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAbandoned');
    });
  }

  QueryBuilder<PomodoroSession, bool, QQueryOperations> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<PomodoroSession, String?, QQueryOperations>
      linkedTaskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linkedTaskId');
    });
  }

  QueryBuilder<PomodoroSession, String?, QQueryOperations>
      linkedTaskTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linkedTaskTitle');
    });
  }

  QueryBuilder<PomodoroSession, int, QQueryOperations>
      plannedDurationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedDurationSeconds');
    });
  }

  QueryBuilder<PomodoroSession, String, QQueryOperations>
      sessionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionType');
    });
  }

  QueryBuilder<PomodoroSession, DateTime, QQueryOperations>
      startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<PomodoroSession, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
