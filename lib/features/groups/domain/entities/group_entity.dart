import 'package:equatable/equatable.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/enums/user_status.dart';

class GroupEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String authorUID;
  final Map<String, UserStatus> participants;
  final List<String> participantsUIDs;
  final Map<String, List<String>> excludedPairs;
  final Map<String, String> matches;
  final int budgetLimit;
  final String currency;
  final DateTime eventDate;
  final DateTime createdAt;
  final String inviteCode;
  final GroupStatus state;

  const GroupEntity({
    required this.id,
    required this.title,
    this.description,
    required this.authorUID,
    required this.participants,
    required this.participantsUIDs,
    required this.budgetLimit,
    required this.currency,
    required this.eventDate,
    required this.createdAt,
    required this.inviteCode,
    required this.state,
    this.excludedPairs = const {},
    this.matches = const {},
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    authorUID,
    participants,
    participantsUIDs,
    budgetLimit,
    currency,
    eventDate,
    createdAt,
    inviteCode,
    state,
    excludedPairs,
    matches,
  ];

  GroupEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? authorUID,
    Map<String, UserStatus>? participants,
    List<String>? participantsUIDs,
    int? budgetLimit,
    String? currency,
    DateTime? eventDate,
    DateTime? createdAt,
    String? inviteCode,
    GroupStatus? state,
    Map<String, List<String>>? excludedPairs,
    Map<String, String>? matches,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      authorUID: authorUID ?? this.authorUID,
      participants: participants ?? this.participants,
      participantsUIDs: participantsUIDs ?? this.participantsUIDs,
      budgetLimit: budgetLimit ?? this.budgetLimit,
      currency: currency ?? this.currency,
      eventDate: eventDate ?? this.eventDate,
      createdAt: createdAt ?? this.createdAt,
      inviteCode: inviteCode ?? this.inviteCode,
      state: state ?? this.state,
      excludedPairs: excludedPairs ?? this.excludedPairs,
      matches: matches ?? this.matches,
    );
  }
}
