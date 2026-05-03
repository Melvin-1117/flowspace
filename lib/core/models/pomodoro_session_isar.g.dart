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
    r'completedSubtasks': PropertySchema(
      id: 0,
      name: r'completedSubtasks',
      type: IsarType.long,
    ),
    r'isCompleted': PropertySchema(
      id: 1,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'isRunning': PropertySchema(
      id: 2,
      name: r'isRunning',
      type: IsarType.bool,
    ),
    r'linkedTaskId': PropertySchema(
      id: 3,
      name: r'linkedTaskId',
      type: IsarType.string,
    ),
    r'linkedTaskTitle': PropertySchema(
      id: 4,
      name: r'linkedTaskTitle',
      type: IsarType.string,
    ),
    r'remainingSeconds': PropertySchema(
      id: 5,
      name: r'remainingSeconds',
      type: IsarType.long,
    ),
    r'startTime': PropertySchema(
      id: 6,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'totalDurationSeconds': PropertySchema(
      id: 7,
      name: r'totalDurationSeconds',
      type: IsarType.long,
    ),
    r'totalSubtasks': PropertySchema(
      id: 8,
      name: r'totalSubtasks',
      type: IsarType.long,
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
  bytesCount += 3 + object.linkedTaskId.length * 3;
  bytesCount += 3 + object.linkedTaskTitle.length * 3;
  return bytesCount;
}

void _pomodoroSessionSerialize(
  PomodoroSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.completedSubtasks);
  writer.writeBool(offsets[1], object.isCompleted);
  writer.writeBool(offsets[2], object.isRunning);
  writer.writeString(offsets[3], object.linkedTaskId);
  writer.writeString(offsets[4], object.linkedTaskTitle);
  writer.writeLong(offsets[5], object.remainingSeconds);
  writer.writeDateTime(offsets[6], object.startTime);
  writer.writeLong(offsets[7], object.totalDurationSeconds);
  writer.writeLong(offsets[8], object.totalSubtasks);
}

PomodoroSession _pomodoroSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PomodoroSession();
  object.completedSubtasks = reader.readLong(offsets[0]);
  object.id = id;
  object.isCompleted = reader.readBool(offsets[1]);
  object.isRunning = reader.readBool(offsets[2]);
  object.linkedTaskId = reader.readString(offsets[3]);
  object.linkedTaskTitle = reader.readString(offsets[4]);
  object.remainingSeconds = reader.readLong(offsets[5]);
  object.startTime = reader.readDateTime(offsets[6]);
  object.totalDurationSeconds = reader.readLong(offsets[7]);
  object.totalSubtasks = reader.readLong(offsets[8]);
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
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
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
      completedSubtasksEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedSubtasks',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      completedSubtasksGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedSubtasks',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      completedSubtasksLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedSubtasks',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      completedSubtasksBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedSubtasks',
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
      isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      isRunningEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRunning',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      linkedTaskIdEqualTo(
    String value, {
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
    String value, {
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
    String value, {
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
    String lower,
    String upper, {
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
      linkedTaskTitleEqualTo(
    String value, {
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
    String value, {
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
    String value, {
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
    String lower,
    String upper, {
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
      remainingSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remainingSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      remainingSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remainingSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      remainingSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remainingSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      remainingSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remainingSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
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
      totalDurationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      totalDurationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      totalDurationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      totalDurationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDurationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      totalSubtasksEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSubtasks',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      totalSubtasksGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalSubtasks',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      totalSubtasksLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalSubtasks',
        value: value,
      ));
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterFilterCondition>
      totalSubtasksBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalSubtasks',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
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
      sortByCompletedSubtasks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedSubtasks', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByCompletedSubtasksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedSubtasks', Sort.desc);
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
      sortByIsRunning() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRunning', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByIsRunningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRunning', Sort.desc);
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
      sortByRemainingSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByRemainingSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingSeconds', Sort.desc);
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

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByTotalDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByTotalDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByTotalSubtasks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSubtasks', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      sortByTotalSubtasksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSubtasks', Sort.desc);
    });
  }
}

extension PomodoroSessionQuerySortThenBy
    on QueryBuilder<PomodoroSession, PomodoroSession, QSortThenBy> {
  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByCompletedSubtasks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedSubtasks', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByCompletedSubtasksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedSubtasks', Sort.desc);
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
      thenByIsRunning() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRunning', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByIsRunningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRunning', Sort.desc);
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
      thenByRemainingSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByRemainingSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingSeconds', Sort.desc);
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

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByTotalDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByTotalDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByTotalSubtasks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSubtasks', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QAfterSortBy>
      thenByTotalSubtasksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSubtasks', Sort.desc);
    });
  }
}

extension PomodoroSessionQueryWhereDistinct
    on QueryBuilder<PomodoroSession, PomodoroSession, QDistinct> {
  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct>
      distinctByCompletedSubtasks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedSubtasks');
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct>
      distinctByIsRunning() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRunning');
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
      distinctByRemainingSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remainingSeconds');
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct>
      distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct>
      distinctByTotalDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDurationSeconds');
    });
  }

  QueryBuilder<PomodoroSession, PomodoroSession, QDistinct>
      distinctByTotalSubtasks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSubtasks');
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
      completedSubtasksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedSubtasks');
    });
  }

  QueryBuilder<PomodoroSession, bool, QQueryOperations> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<PomodoroSession, bool, QQueryOperations> isRunningProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRunning');
    });
  }

  QueryBuilder<PomodoroSession, String, QQueryOperations>
      linkedTaskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linkedTaskId');
    });
  }

  QueryBuilder<PomodoroSession, String, QQueryOperations>
      linkedTaskTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linkedTaskTitle');
    });
  }

  QueryBuilder<PomodoroSession, int, QQueryOperations>
      remainingSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remainingSeconds');
    });
  }

  QueryBuilder<PomodoroSession, DateTime, QQueryOperations>
      startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<PomodoroSession, int, QQueryOperations>
      totalDurationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDurationSeconds');
    });
  }

  QueryBuilder<PomodoroSession, int, QQueryOperations> totalSubtasksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSubtasks');
    });
  }
}
