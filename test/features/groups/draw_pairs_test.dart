import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/enums/user_status.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/groups/data/repositories/group_repository.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/features/groups/domain/usecases/create_group.dart';
import 'package:secret_santa/features/groups/domain/usecases/generate_group_code.dart';
import 'package:secret_santa/features/groups/domain/usecases/get_groups_participants.dart';
import 'package:secret_santa/features/groups/domain/usecases/join_group.dart';
import 'package:secret_santa/features/groups/domain/usecases/leave_group.dart';
import 'package:secret_santa/features/groups/domain/usecases/update_group.dart';

class FakeJoinGroup implements JoinGroup {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCreateGroup implements CreateGroup {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeLeaveGroup implements LeaveGroup {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeUpdateGroup implements UpdateGroup {
  bool callCalled = false;
  GroupEntity? passedGroup;
  Either<Failure, void> result = const Right(null);

  @override
  GroupRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> call(GroupEntity group) async {
    callCalled = true;
    passedGroup = group;
    return result;
  }
}

class FakeGenerateGroupCode implements GenerateGroupCode {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeGetGroupsParticipants implements GetGroupsParticipants {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeJoinGroup fakeJoinGroup;
  late FakeCreateGroup fakeCreateGroup;
  late FakeLeaveGroup fakeLeaveGroup;
  late FakeUpdateGroup fakeUpdateGroup;
  late FakeGenerateGroupCode fakeGenerateGroupCode;
  late FakeGetGroupsParticipants fakeGetGroupsParticipants;
  late GroupBloc groupBloc;

  setUp(() {
    fakeJoinGroup = FakeJoinGroup();
    fakeCreateGroup = FakeCreateGroup();
    fakeLeaveGroup = FakeLeaveGroup();
    fakeUpdateGroup = FakeUpdateGroup();
    fakeGenerateGroupCode = FakeGenerateGroupCode();
    fakeGetGroupsParticipants = FakeGetGroupsParticipants();

    groupBloc = GroupBloc(
      joinGroup: fakeJoinGroup,
      createGroup: fakeCreateGroup,
      leaveGroup: fakeLeaveGroup,
      updateGroup: fakeUpdateGroup,
      generateGroupCode: fakeGenerateGroupCode,
      getGroupsParticipants: fakeGetGroupsParticipants,
    );
  });

  tearDown(() {
    groupBloc.close();
  });

  group('DrawPairsLocalEvent', () {
    test('should draw pairs locally and update matches state when participants >= 3', () async {
      // arrange
      final participants = ["user_1", "user_2", "user_3"];

      // act
      groupBloc.add(DrawPairsLocalEvent(participantUids: participants));

      // assert/wait for state change
      await expectLater(
        groupBloc.stream,
        emits(isA<GroupState>().having((state) => state.matches.length, 'matches count', 3)),
      );

      final matches = groupBloc.state.matches;
      // Ensure no one draws themselves
      for (final entry in matches.entries) {
        expect(entry.key, isNot(equals(entry.value)));
      }
      // Ensure all participants are receivers
      expect(matches.values.toSet().length, 3);
      expect(matches.values.toSet(), containsAll(participants));
    });

    test('should emit error state when participants < 3', () async {
      // arrange
      final participants = ["user_1", "user_2"];

      // act
      groupBloc.add(DrawPairsLocalEvent(participantUids: participants));

      // assert
      await expectLater(
        groupBloc.stream,
        emits(isA<GroupState>().having(
          (state) => state.status, 'status', GroupStatus.error
        ).having(
          (state) => state.errorMessage, 'errorMessage', 'Za mało uczestników (minimum 3)'
        )),
      );
    });
  });

  group('ConfirmDrawEvent', () {
    test('should call UpdateGroup and update group state on success', () async {
      // arrange
      final group = GroupEntity(
        id: "group_123",
        title: "Test Group",
        authorUID: "user_1",
        participants: const {
          "user_1": UserStatus.confirmed,
          "user_2": UserStatus.confirmed,
          "user_3": UserStatus.confirmed,
        },
        participantsUIDs: const ["user_1", "user_2", "user_3"],
        budgetLimit: 10,
        currency: "USD",
        eventDate: DateTime.now(),
        createdAt: DateTime.now(),
        inviteCode: "123456",
        state: GroupStatus.active,
      );
      final matches = {
        "user_1": "user_2",
        "user_2": "user_3",
        "user_3": "user_1",
      };

      // act
      groupBloc.add(ConfirmDrawEvent(group: group, matches: matches));

      // assert
      await expectLater(
        groupBloc.stream,
        emits(isA<GroupState>().having(
          (state) => state.status, 'status', GroupStatus.drawn
        ).having(
          (state) => state.matches, 'matches', matches
        ).having(
          (state) => state.group?.matches, 'group matches', matches
        )),
      );

      expect(fakeUpdateGroup.callCalled, true);
      expect(fakeUpdateGroup.passedGroup?.matches, matches);
    });

    test('should emit error state when UpdateGroup fails', () async {
      // arrange
      final group = GroupEntity(
        id: "group_123",
        title: "Test Group",
        authorUID: "user_1",
        participants: const {
          "user_1": UserStatus.confirmed,
          "user_2": UserStatus.confirmed,
          "user_3": UserStatus.confirmed,
        },
        participantsUIDs: const ["user_1", "user_2", "user_3"],
        budgetLimit: 10,
        currency: "USD",
        eventDate: DateTime.now(),
        createdAt: DateTime.now(),
        inviteCode: "123456",
        state: GroupStatus.active,
      );
      final matches = {
        "user_1": "user_2",
        "user_2": "user_3",
        "user_3": "user_1",
      };
      fakeUpdateGroup.result = const Left(ServerFailure("DB Error"));

      // act
      groupBloc.add(ConfirmDrawEvent(group: group, matches: matches));

      // assert
      await expectLater(
        groupBloc.stream,
        emits(isA<GroupState>().having(
          (state) => state.status, 'status', GroupStatus.error
        ).having(
          (state) => state.errorMessage, 'errorMessage', 'DB Error'
        )),
      );
    });
  });
}
