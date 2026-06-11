// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_entry_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSkillEntryCollection on Isar {
  IsarCollection<SkillEntry> get skillEntrys => this.collection();
}

const SkillEntrySchema = CollectionSchema(
  name: r'SkillEntry',
  id: -2902427898464247840,
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.string,
    ),
    r'firstLearnedAt': PropertySchema(
      id: 1,
      name: r'firstLearnedAt',
      type: IsarType.dateTime,
    ),
    r'hoursInvested': PropertySchema(
      id: 2,
      name: r'hoursInvested',
      type: IsarType.long,
    ),
    r'lastPracticedAt': PropertySchema(
      id: 3,
      name: r'lastPracticedAt',
      type: IsarType.dateTime,
    ),
    r'linkedProjectIds': PropertySchema(
      id: 4,
      name: r'linkedProjectIds',
      type: IsarType.stringList,
    ),
    r'notes': PropertySchema(
      id: 5,
      name: r'notes',
      type: IsarType.string,
    ),
    r'proficiencyLevel': PropertySchema(
      id: 6,
      name: r'proficiencyLevel',
      type: IsarType.long,
    ),
    r'skillName': PropertySchema(
      id: 7,
      name: r'skillName',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(
      id: 8,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _skillEntryEstimateSize,
  serialize: _skillEntrySerialize,
  deserialize: _skillEntryDeserialize,
  deserializeProp: _skillEntryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _skillEntryGetId,
  getLinks: _skillEntryGetLinks,
  attach: _skillEntryAttach,
  version: '3.1.0+1',
);

int _skillEntryEstimateSize(
  SkillEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.linkedProjectIds.length * 3;
  {
    for (var i = 0; i < object.linkedProjectIds.length; i++) {
      final value = object.linkedProjectIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.notes.length * 3;
  bytesCount += 3 + object.skillName.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _skillEntrySerialize(
  SkillEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.category);
  writer.writeDateTime(offsets[1], object.firstLearnedAt);
  writer.writeLong(offsets[2], object.hoursInvested);
  writer.writeDateTime(offsets[3], object.lastPracticedAt);
  writer.writeStringList(offsets[4], object.linkedProjectIds);
  writer.writeString(offsets[5], object.notes);
  writer.writeLong(offsets[6], object.proficiencyLevel);
  writer.writeString(offsets[7], object.skillName);
  writer.writeString(offsets[8], object.uuid);
}

SkillEntry _skillEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SkillEntry();
  object.category = reader.readString(offsets[0]);
  object.firstLearnedAt = reader.readDateTime(offsets[1]);
  object.hoursInvested = reader.readLong(offsets[2]);
  object.id = id;
  object.lastPracticedAt = reader.readDateTime(offsets[3]);
  object.linkedProjectIds = reader.readStringList(offsets[4]) ?? [];
  object.notes = reader.readString(offsets[5]);
  object.proficiencyLevel = reader.readLong(offsets[6]);
  object.skillName = reader.readString(offsets[7]);
  object.uuid = reader.readString(offsets[8]);
  return object;
}

P _skillEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _skillEntryGetId(SkillEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _skillEntryGetLinks(SkillEntry object) {
  return [];
}

void _skillEntryAttach(IsarCollection<dynamic> col, Id id, SkillEntry object) {
  object.id = id;
}

extension SkillEntryQueryWhereSort
    on QueryBuilder<SkillEntry, SkillEntry, QWhere> {
  QueryBuilder<SkillEntry, SkillEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SkillEntryQueryWhere
    on QueryBuilder<SkillEntry, SkillEntry, QWhereClause> {
  QueryBuilder<SkillEntry, SkillEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SkillEntry, SkillEntry, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterWhereClause> idBetween(
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

extension SkillEntryQueryFilter
    on QueryBuilder<SkillEntry, SkillEntry, QFilterCondition> {
  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> categoryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> categoryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      firstLearnedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstLearnedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      firstLearnedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstLearnedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      firstLearnedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstLearnedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      firstLearnedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstLearnedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      hoursInvestedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hoursInvested',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      hoursInvestedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hoursInvested',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      hoursInvestedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hoursInvested',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      hoursInvestedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hoursInvested',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      lastPracticedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastPracticedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      lastPracticedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastPracticedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      lastPracticedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastPracticedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      lastPracticedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastPracticedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedProjectIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'linkedProjectIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'linkedProjectIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'linkedProjectIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'linkedProjectIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'linkedProjectIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'linkedProjectIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'linkedProjectIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedProjectIds',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'linkedProjectIds',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'linkedProjectIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'linkedProjectIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'linkedProjectIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'linkedProjectIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'linkedProjectIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      linkedProjectIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'linkedProjectIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> notesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> notesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> notesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> notesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      proficiencyLevelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proficiencyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      proficiencyLevelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proficiencyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      proficiencyLevelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proficiencyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      proficiencyLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proficiencyLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> skillNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skillName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      skillNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'skillName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> skillNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'skillName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> skillNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'skillName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      skillNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'skillName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> skillNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'skillName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> skillNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'skillName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> skillNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'skillName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      skillNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skillName',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition>
      skillNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'skillName',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> uuidEqualTo(
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

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> uuidStartsWith(
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

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> uuidEndsWith(
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

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> uuidContains(
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

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> uuidMatches(
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

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterFilterCondition> uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension SkillEntryQueryObject
    on QueryBuilder<SkillEntry, SkillEntry, QFilterCondition> {}

extension SkillEntryQueryLinks
    on QueryBuilder<SkillEntry, SkillEntry, QFilterCondition> {}

extension SkillEntryQuerySortBy
    on QueryBuilder<SkillEntry, SkillEntry, QSortBy> {
  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> sortByFirstLearnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstLearnedAt', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy>
      sortByFirstLearnedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstLearnedAt', Sort.desc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> sortByHoursInvested() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursInvested', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> sortByHoursInvestedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursInvested', Sort.desc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> sortByLastPracticedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticedAt', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy>
      sortByLastPracticedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticedAt', Sort.desc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> sortByProficiencyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proficiencyLevel', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy>
      sortByProficiencyLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proficiencyLevel', Sort.desc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> sortBySkillName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillName', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> sortBySkillNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillName', Sort.desc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension SkillEntryQuerySortThenBy
    on QueryBuilder<SkillEntry, SkillEntry, QSortThenBy> {
  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> thenByFirstLearnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstLearnedAt', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy>
      thenByFirstLearnedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstLearnedAt', Sort.desc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> thenByHoursInvested() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursInvested', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> thenByHoursInvestedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursInvested', Sort.desc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> thenByLastPracticedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticedAt', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy>
      thenByLastPracticedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticedAt', Sort.desc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> thenByProficiencyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proficiencyLevel', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy>
      thenByProficiencyLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proficiencyLevel', Sort.desc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> thenBySkillName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillName', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> thenBySkillNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillName', Sort.desc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension SkillEntryQueryWhereDistinct
    on QueryBuilder<SkillEntry, SkillEntry, QDistinct> {
  QueryBuilder<SkillEntry, SkillEntry, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QDistinct> distinctByFirstLearnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstLearnedAt');
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QDistinct> distinctByHoursInvested() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hoursInvested');
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QDistinct> distinctByLastPracticedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastPracticedAt');
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QDistinct> distinctByLinkedProjectIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linkedProjectIds');
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QDistinct> distinctByProficiencyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proficiencyLevel');
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QDistinct> distinctBySkillName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'skillName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SkillEntry, SkillEntry, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension SkillEntryQueryProperty
    on QueryBuilder<SkillEntry, SkillEntry, QQueryProperty> {
  QueryBuilder<SkillEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SkillEntry, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<SkillEntry, DateTime, QQueryOperations>
      firstLearnedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstLearnedAt');
    });
  }

  QueryBuilder<SkillEntry, int, QQueryOperations> hoursInvestedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hoursInvested');
    });
  }

  QueryBuilder<SkillEntry, DateTime, QQueryOperations>
      lastPracticedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPracticedAt');
    });
  }

  QueryBuilder<SkillEntry, List<String>, QQueryOperations>
      linkedProjectIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linkedProjectIds');
    });
  }

  QueryBuilder<SkillEntry, String, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<SkillEntry, int, QQueryOperations> proficiencyLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proficiencyLevel');
    });
  }

  QueryBuilder<SkillEntry, String, QQueryOperations> skillNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skillName');
    });
  }

  QueryBuilder<SkillEntry, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
