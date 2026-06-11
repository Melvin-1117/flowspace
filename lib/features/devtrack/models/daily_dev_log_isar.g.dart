// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_dev_log_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyDevLogCollection on Isar {
  IsarCollection<DailyDevLog> get dailyDevLogs => this.collection();
}

const DailyDevLogSchema = CollectionSchema(
  name: r'DailyDevLog',
  id: -1405528223773434464,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'energyLevel': PropertySchema(
      id: 1,
      name: r'energyLevel',
      type: IsarType.long,
    ),
    r'highlight': PropertySchema(
      id: 2,
      name: r'highlight',
      type: IsarType.string,
    ),
    r'languagesUsed': PropertySchema(
      id: 3,
      name: r'languagesUsed',
      type: IsarType.stringList,
    ),
    r'pomodoroSessions': PropertySchema(
      id: 4,
      name: r'pomodoroSessions',
      type: IsarType.long,
    ),
    r'projectsWorked': PropertySchema(
      id: 5,
      name: r'projectsWorked',
      type: IsarType.stringList,
    ),
    r'tasksCompleted': PropertySchema(
      id: 6,
      name: r'tasksCompleted',
      type: IsarType.long,
    ),
    r'totalCodingMinutes': PropertySchema(
      id: 7,
      name: r'totalCodingMinutes',
      type: IsarType.long,
    ),
    r'uuid': PropertySchema(
      id: 8,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _dailyDevLogEstimateSize,
  serialize: _dailyDevLogSerialize,
  deserialize: _dailyDevLogDeserialize,
  deserializeProp: _dailyDevLogDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _dailyDevLogGetId,
  getLinks: _dailyDevLogGetLinks,
  attach: _dailyDevLogAttach,
  version: '3.1.0+1',
);

int _dailyDevLogEstimateSize(
  DailyDevLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.highlight;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.languagesUsed.length * 3;
  {
    for (var i = 0; i < object.languagesUsed.length; i++) {
      final value = object.languagesUsed[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.projectsWorked.length * 3;
  {
    for (var i = 0; i < object.projectsWorked.length; i++) {
      final value = object.projectsWorked[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _dailyDevLogSerialize(
  DailyDevLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeLong(offsets[1], object.energyLevel);
  writer.writeString(offsets[2], object.highlight);
  writer.writeStringList(offsets[3], object.languagesUsed);
  writer.writeLong(offsets[4], object.pomodoroSessions);
  writer.writeStringList(offsets[5], object.projectsWorked);
  writer.writeLong(offsets[6], object.tasksCompleted);
  writer.writeLong(offsets[7], object.totalCodingMinutes);
  writer.writeString(offsets[8], object.uuid);
}

DailyDevLog _dailyDevLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyDevLog();
  object.date = reader.readDateTime(offsets[0]);
  object.energyLevel = reader.readLong(offsets[1]);
  object.highlight = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.languagesUsed = reader.readStringList(offsets[3]) ?? [];
  object.pomodoroSessions = reader.readLong(offsets[4]);
  object.projectsWorked = reader.readStringList(offsets[5]) ?? [];
  object.tasksCompleted = reader.readLong(offsets[6]);
  object.totalCodingMinutes = reader.readLong(offsets[7]);
  object.uuid = reader.readString(offsets[8]);
  return object;
}

P _dailyDevLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyDevLogGetId(DailyDevLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyDevLogGetLinks(DailyDevLog object) {
  return [];
}

void _dailyDevLogAttach(
    IsarCollection<dynamic> col, Id id, DailyDevLog object) {
  object.id = id;
}

extension DailyDevLogQueryWhereSort
    on QueryBuilder<DailyDevLog, DailyDevLog, QWhere> {
  QueryBuilder<DailyDevLog, DailyDevLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DailyDevLogQueryWhere
    on QueryBuilder<DailyDevLog, DailyDevLog, QWhereClause> {
  QueryBuilder<DailyDevLog, DailyDevLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterWhereClause> idBetween(
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

extension DailyDevLogQueryFilter
    on QueryBuilder<DailyDevLog, DailyDevLog, QFilterCondition> {
  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      energyLevelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'energyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      energyLevelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'energyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      energyLevelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'energyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      energyLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'energyLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      highlightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'highlight',
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      highlightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'highlight',
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      highlightEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highlight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      highlightGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'highlight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      highlightLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'highlight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      highlightBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'highlight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      highlightStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'highlight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      highlightEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'highlight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      highlightContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'highlight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      highlightMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'highlight',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      highlightIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highlight',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      highlightIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'highlight',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'languagesUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'languagesUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'languagesUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'languagesUsed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'languagesUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'languagesUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'languagesUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'languagesUsed',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'languagesUsed',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'languagesUsed',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'languagesUsed',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'languagesUsed',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'languagesUsed',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'languagesUsed',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'languagesUsed',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      languagesUsedLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'languagesUsed',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      pomodoroSessionsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pomodoroSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      pomodoroSessionsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pomodoroSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      pomodoroSessionsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pomodoroSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      pomodoroSessionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pomodoroSessions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectsWorked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'projectsWorked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'projectsWorked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'projectsWorked',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'projectsWorked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'projectsWorked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'projectsWorked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'projectsWorked',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectsWorked',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'projectsWorked',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'projectsWorked',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'projectsWorked',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'projectsWorked',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'projectsWorked',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'projectsWorked',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      projectsWorkedLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'projectsWorked',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      tasksCompletedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tasksCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      tasksCompletedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tasksCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      tasksCompletedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tasksCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      tasksCompletedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tasksCompleted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      totalCodingMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCodingMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      totalCodingMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCodingMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      totalCodingMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCodingMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      totalCodingMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCodingMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> uuidEqualTo(
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

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> uuidStartsWith(
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

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> uuidEndsWith(
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

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> uuidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> uuidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension DailyDevLogQueryObject
    on QueryBuilder<DailyDevLog, DailyDevLog, QFilterCondition> {}

extension DailyDevLogQueryLinks
    on QueryBuilder<DailyDevLog, DailyDevLog, QFilterCondition> {}

extension DailyDevLogQuerySortBy
    on QueryBuilder<DailyDevLog, DailyDevLog, QSortBy> {
  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> sortByEnergyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.asc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> sortByEnergyLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.desc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> sortByHighlight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlight', Sort.asc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> sortByHighlightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlight', Sort.desc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy>
      sortByPomodoroSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pomodoroSessions', Sort.asc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy>
      sortByPomodoroSessionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pomodoroSessions', Sort.desc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> sortByTasksCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksCompleted', Sort.asc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy>
      sortByTasksCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksCompleted', Sort.desc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy>
      sortByTotalCodingMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCodingMinutes', Sort.asc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy>
      sortByTotalCodingMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCodingMinutes', Sort.desc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension DailyDevLogQuerySortThenBy
    on QueryBuilder<DailyDevLog, DailyDevLog, QSortThenBy> {
  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> thenByEnergyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.asc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> thenByEnergyLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.desc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> thenByHighlight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlight', Sort.asc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> thenByHighlightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlight', Sort.desc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy>
      thenByPomodoroSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pomodoroSessions', Sort.asc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy>
      thenByPomodoroSessionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pomodoroSessions', Sort.desc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> thenByTasksCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksCompleted', Sort.asc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy>
      thenByTasksCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksCompleted', Sort.desc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy>
      thenByTotalCodingMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCodingMinutes', Sort.asc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy>
      thenByTotalCodingMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCodingMinutes', Sort.desc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension DailyDevLogQueryWhereDistinct
    on QueryBuilder<DailyDevLog, DailyDevLog, QDistinct> {
  QueryBuilder<DailyDevLog, DailyDevLog, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QDistinct> distinctByEnergyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'energyLevel');
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QDistinct> distinctByHighlight(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'highlight', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QDistinct> distinctByLanguagesUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'languagesUsed');
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QDistinct>
      distinctByPomodoroSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pomodoroSessions');
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QDistinct> distinctByProjectsWorked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectsWorked');
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QDistinct> distinctByTasksCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tasksCompleted');
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QDistinct>
      distinctByTotalCodingMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCodingMinutes');
    });
  }

  QueryBuilder<DailyDevLog, DailyDevLog, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension DailyDevLogQueryProperty
    on QueryBuilder<DailyDevLog, DailyDevLog, QQueryProperty> {
  QueryBuilder<DailyDevLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyDevLog, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyDevLog, int, QQueryOperations> energyLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'energyLevel');
    });
  }

  QueryBuilder<DailyDevLog, String?, QQueryOperations> highlightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'highlight');
    });
  }

  QueryBuilder<DailyDevLog, List<String>, QQueryOperations>
      languagesUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'languagesUsed');
    });
  }

  QueryBuilder<DailyDevLog, int, QQueryOperations> pomodoroSessionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pomodoroSessions');
    });
  }

  QueryBuilder<DailyDevLog, List<String>, QQueryOperations>
      projectsWorkedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectsWorked');
    });
  }

  QueryBuilder<DailyDevLog, int, QQueryOperations> tasksCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tasksCompleted');
    });
  }

  QueryBuilder<DailyDevLog, int, QQueryOperations>
      totalCodingMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCodingMinutes');
    });
  }

  QueryBuilder<DailyDevLog, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
