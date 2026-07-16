// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_lock_session_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFocusLockSessionCollection on Isar {
  IsarCollection<FocusLockSession> get focusLockSessions => this.collection();
}

const FocusLockSessionSchema = CollectionSchema(
  name: r'FocusLockSession',
  id: 5099487109403617464,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'durationMinutes': PropertySchema(
      id: 1,
      name: r'durationMinutes',
      type: IsarType.long,
    ),
    r'focusScore': PropertySchema(
      id: 2,
      name: r'focusScore',
      type: IsarType.long,
    ),
    r'isCompleted': PropertySchema(
      id: 3,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'isVoid': PropertySchema(
      id: 4,
      name: r'isVoid',
      type: IsarType.bool,
    ),
    r'startedAt': PropertySchema(
      id: 5,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'strikes': PropertySchema(
      id: 6,
      name: r'strikes',
      type: IsarType.long,
    ),
    r'uuid': PropertySchema(
      id: 7,
      name: r'uuid',
      type: IsarType.string,
    ),
  },
  estimateSize: _focusLockSessionEstimateSize,
  serialize: _focusLockSessionSerialize,
  deserialize: _focusLockSessionDeserialize,
  deserializeProp: _focusLockSessionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _focusLockSessionGetId,
  getLinks: _focusLockSessionGetLinks,
  attach: _focusLockSessionAttach,
  version: '3.1.0+1',
);

int _focusLockSessionEstimateSize(
  FocusLockSession object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _focusLockSessionSerialize(
  FocusLockSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeLong(offsets[1], object.durationMinutes);
  writer.writeLong(offsets[2], object.focusScore);
  writer.writeBool(offsets[3], object.isCompleted);
  writer.writeBool(offsets[4], object.isVoid);
  writer.writeDateTime(offsets[5], object.startedAt);
  writer.writeLong(offsets[6], object.strikes);
  writer.writeString(offsets[7], object.uuid);
}

FocusLockSession _focusLockSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FocusLockSession();
  object.completedAt = reader.readDateTimeOrNull(offsets[0]);
  object.durationMinutes = reader.readLong(offsets[1]);
  object.focusScore = reader.readLong(offsets[2]);
  object.id = id;
  object.isCompleted = reader.readBool(offsets[3]);
  object.isVoid = reader.readBool(offsets[4]);
  object.startedAt = reader.readDateTime(offsets[5]);
  object.strikes = reader.readLong(offsets[6]);
  object.uuid = reader.readString(offsets[7]);
  return object;
}

P _focusLockSessionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _focusLockSessionGetId(FocusLockSession object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _focusLockSessionGetLinks(
  FocusLockSession object,
) {
  return [];
}

void _focusLockSessionAttach(
  IsarCollection<dynamic> col,
  Id id,
  FocusLockSession object,
) {
  object.id = id;
}

extension FocusLockSessionQueryWhereSort
    on QueryBuilder<FocusLockSession, FocusLockSession, QWhere> {
  QueryBuilder<FocusLockSession, FocusLockSession, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FocusLockSessionQueryWhere
    on QueryBuilder<FocusLockSession, FocusLockSession, QWhereClause> {
  QueryBuilder<FocusLockSession, FocusLockSession, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: id, upper: id),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterWhereClause>
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

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterWhereClause>
      idBetween(Id lowerId, Id upperId,
          {bool includeLower = true, bool includeUpper = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension FocusLockSessionQueryFilter
    on QueryBuilder<FocusLockSession, FocusLockSession, QFilterCondition> {
  // ── completedAt ──────────────────────────────────────────────────────
  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'completedAt'),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'completedAt'),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completedAt', value: value),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      completedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'completedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      completedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'completedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      completedAtBetween(DateTime? lower, DateTime? upper,
          {bool includeLower = true, bool includeUpper = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'completedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  // ── durationMinutes ──────────────────────────────────────────────────
  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      durationMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'durationMinutes', value: value),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      durationMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'durationMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      durationMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'durationMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      durationMinutesBetween(int lower, int upper,
          {bool includeLower = true, bool includeUpper = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'durationMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  // ── focusScore ───────────────────────────────────────────────────────
  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      focusScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'focusScore', value: value),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      focusScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'focusScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      focusScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'focusScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      focusScoreBetween(int lower, int upper,
          {bool includeLower = true, bool includeUpper = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'focusScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  // ── id ───────────────────────────────────────────────────────────────
  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      idBetween(Id lower, Id upper,
          {bool includeLower = true, bool includeUpper = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  // ── isCompleted ──────────────────────────────────────────────────────
  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isCompleted', value: value),
      );
    });
  }

  // ── isVoid ───────────────────────────────────────────────────────────
  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      isVoidEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isVoid', value: value),
      );
    });
  }

  // ── startedAt ────────────────────────────────────────────────────────
  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      startedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startedAt', value: value),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      startedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      startedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      startedAtBetween(DateTime lower, DateTime upper,
          {bool includeLower = true, bool includeUpper = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  // ── strikes ──────────────────────────────────────────────────────────
  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      strikesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'strikes', value: value),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      strikesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'strikes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      strikesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'strikes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      strikesBetween(int lower, int upper,
          {bool includeLower = true, bool includeUpper = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'strikes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  // ── uuid ─────────────────────────────────────────────────────────────
  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      uuidEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      uuidGreaterThan(String value,
          {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      uuidLessThan(String value,
          {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      uuidBetween(String lower, String upper,
          {bool includeLower = true,
          bool includeUpper = true,
          bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'uuid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      uuidStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      uuidEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      uuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'uuid',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uuid', value: ''),
      );
    });
  }
}

extension FocusLockSessionQueryObject
    on QueryBuilder<FocusLockSession, FocusLockSession, QFilterCondition> {}

extension FocusLockSessionQueryLinks
    on QueryBuilder<FocusLockSession, FocusLockSession, QFilterCondition> {}

extension FocusLockSessionQuerySortBy
    on QueryBuilder<FocusLockSession, FocusLockSession, QSortBy> {
  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.desc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByFocusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.desc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByIsVoid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVoid', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByIsVoidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVoid', Sort.desc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByStrikes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strikes', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByStrikesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strikes', Sort.desc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension FocusLockSessionQuerySortThenBy
    on QueryBuilder<FocusLockSession, FocusLockSession, QSortThenBy> {
  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.desc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByFocusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.desc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByIsVoid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVoid', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByIsVoidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVoid', Sort.desc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByStrikes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strikes', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByStrikesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strikes', Sort.desc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QAfterSortBy>
      thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension FocusLockSessionQueryWhereDistinct
    on QueryBuilder<FocusLockSession, FocusLockSession, QDistinct> {
  QueryBuilder<FocusLockSession, FocusLockSession, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QDistinct>
      distinctByDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMinutes');
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QDistinct>
      distinctByFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focusScore');
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QDistinct>
      distinctByIsVoid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isVoid');
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QDistinct>
      distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QDistinct>
      distinctByStrikes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'strikes');
    });
  }

  QueryBuilder<FocusLockSession, FocusLockSession, QDistinct>
      distinctByUuid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension FocusLockSessionQueryProperty
    on QueryBuilder<FocusLockSession, FocusLockSession, QQueryProperty> {
  QueryBuilder<FocusLockSession, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FocusLockSession, DateTime?, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<FocusLockSession, int, QQueryOperations>
      durationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMinutes');
    });
  }

  QueryBuilder<FocusLockSession, int, QQueryOperations> focusScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focusScore');
    });
  }

  QueryBuilder<FocusLockSession, bool, QQueryOperations>
      isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<FocusLockSession, bool, QQueryOperations> isVoidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isVoid');
    });
  }

  QueryBuilder<FocusLockSession, DateTime, QQueryOperations>
      startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<FocusLockSession, int, QQueryOperations> strikesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'strikes');
    });
  }

  QueryBuilder<FocusLockSession, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
