// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserProfileCollection on Isar {
  IsarCollection<UserProfile> get userProfiles => this.collection();
}

const UserProfileSchema = CollectionSchema(
  name: r'UserProfile',
  id: 6894051245416944562,
  properties: {
    r'githubUsername': PropertySchema(
      id: 0,
      name: r'githubUsername',
      type: IsarType.string,
    ),
    r'displayName': PropertySchema(
      id: 1,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'avatarUrl': PropertySchema(
      id: 2,
      name: r'avatarUrl',
      type: IsarType.string,
    ),
    r'bio': PropertySchema(id: 3, name: r'bio', type: IsarType.string),
    r'githubUrl': PropertySchema(
      id: 4,
      name: r'githubUrl',
      type: IsarType.string,
    ),
    r'publicRepos': PropertySchema(
      id: 5,
      name: r'publicRepos',
      type: IsarType.long,
    ),
    r'followers': PropertySchema(
      id: 6,
      name: r'followers',
      type: IsarType.long,
    ),
    r'following': PropertySchema(
      id: 7,
      name: r'following',
      type: IsarType.long,
    ),
    r'connectedAt': PropertySchema(
      id: 8,
      name: r'connectedAt',
      type: IsarType.dateTime,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 9,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'isConnected': PropertySchema(
      id: 10,
      name: r'isConnected',
      type: IsarType.bool,
    ),
  },
  estimateSize: _userProfileEstimateSize,
  serialize: _userProfileSerialize,
  deserialize: _userProfileDeserialize,
  deserializeProp: _userProfileDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userProfileGetId,
  getLinks: _userProfileGetLinks,
  attach: _userProfileAttach,
  version: '3.1.0+1',
);

int _userProfileEstimateSize(
  UserProfile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.githubUsername.length * 3;
  bytesCount += 3 + object.displayName.length * 3;
  bytesCount += 3 + object.avatarUrl.length * 3;
  bytesCount += 3 + object.bio.length * 3;
  bytesCount += 3 + object.githubUrl.length * 3;
  return bytesCount;
}

void _userProfileSerialize(
  UserProfile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.githubUsername);
  writer.writeString(offsets[1], object.displayName);
  writer.writeString(offsets[2], object.avatarUrl);
  writer.writeString(offsets[3], object.bio);
  writer.writeString(offsets[4], object.githubUrl);
  writer.writeLong(offsets[5], object.publicRepos);
  writer.writeLong(offsets[6], object.followers);
  writer.writeLong(offsets[7], object.following);
  writer.writeDateTime(offsets[8], object.connectedAt);
  writer.writeDateTime(offsets[9], object.lastSyncedAt);
  writer.writeBool(offsets[10], object.isConnected);
}

UserProfile _userProfileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserProfile();
  object.githubUsername = reader.readString(offsets[0]);
  object.displayName = reader.readString(offsets[1]);
  object.avatarUrl = reader.readString(offsets[2]);
  object.bio = reader.readString(offsets[3]);
  object.githubUrl = reader.readString(offsets[4]);
  object.publicRepos = reader.readLong(offsets[5]);
  object.followers = reader.readLong(offsets[6]);
  object.following = reader.readLong(offsets[7]);
  object.connectedAt = reader.readDateTime(offsets[8]);
  object.lastSyncedAt = reader.readDateTime(offsets[9]);
  object.isConnected = reader.readBool(offsets[10]);
  object.id = id;
  return object;
}

P _userProfileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userProfileGetId(UserProfile object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userProfileGetLinks(UserProfile object) {
  return [];
}

void _userProfileAttach(
  IsarCollection<dynamic> col,
  Id id,
  UserProfile object,
) {
  object.id = id;
}
