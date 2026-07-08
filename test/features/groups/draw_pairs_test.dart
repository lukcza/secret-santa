import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/enums/user_status.dart';
import 'package:secret_santa/features/groups/data/models/group_model.dart';
import 'package:secret_santa/features/groups/data/repositories/group_repositrory_impl.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/domain/usecases/draw_pairs.dart';
import 'package:secret_santa/features/groups/data/datasources/group_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockGroupRemoteDataSource implements GroupRemoteDataSource {
  GroupModel? mockGroup;
  bool updateGroupCalled = false;
  GroupModel? updatedGroup;

  @override
  Future<GroupModel> getGroupById(String groupId) async {
    if (mockGroup != null) {
      return mockGroup!;
    }
    throw Exception("Group not found");
  }

  @override
  Future<void> updateGroup(GroupModel group) async {
    updateGroupCalled = true;
    updatedGroup = group;
  }

  @override
  Future<GroupModel> createGroup(GroupModel group) =>
      throw UnimplementedError();
  @override
  Future<void> generateGroupCode(String groupId) => throw UnimplementedError();
  @override
  Future<List<GroupModel>> getUserGroups(String userId) =>
      throw UnimplementedError();
  @override
  Stream<List<GroupModel>> getUserGroupsStream(String userId) =>
      throw UnimplementedError();
  @override
  Future<void> joinGroup(String groupCode, String userId) =>
      throw UnimplementedError();
  @override
  Future<void> leaveGroup(String groupCode, String userId) =>
      throw UnimplementedError();
}

class FakeFirebaseAuth implements FirebaseAuth {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockGroupRemoteDataSource mockRemoteDataSource;
  late GroupRepositoryImpl repository;
  late DrawPairs drawPairsUseCase;

  setUp(() {
    mockRemoteDataSource = MockGroupRemoteDataSource();
    repository = GroupRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      firebaseAuth: FakeFirebaseAuth(),
    );
    drawPairsUseCase = DrawPairs(repository);
  });

  group('drawPairs', () {
    final tGroupId = "group_123";

    test(
      'should successfully draw pairs and update group when group is active and has >= 3 participants',
      () async {
        // arrange
        final participants = {
          "user_1": UserStatus.confirmed,
          "user_2": UserStatus.confirmed,
          "user_3": UserStatus.confirmed,
        };

        final group = GroupModel(
          id: tGroupId,
          title: "Test Group",
          authorUID: "user_1",
          participants: participants,
          participantsUIDs: const ["user_1", "user_2", "user_3"],
          budgetLimit: 10,
          currency: "USD",
          eventDate: DateTime.now(),
          createdAt: DateTime.now(),
          inviteCode: "123456",
          state: GroupStatus.active,
        );

        mockRemoteDataSource.mockGroup = group;

        // act
        final result = await drawPairsUseCase(tGroupId);

        // assert
        expect(result.isRight(), true);
        final drawnGroup = result.getOrElse((_) => throw Exception());

        print("Generated matches map: ${drawnGroup.matches}");

        expect(drawnGroup.matches.length, 3);
        // Ensure no one draws themselves
        for (final entry in drawnGroup.matches.entries) {
          expect(entry.key, isNot(equals(entry.value)));
        }
        // Ensure all participants are receivers
        expect(drawnGroup.matches.values.toSet().length, 3);
        expect(drawnGroup.matches.values.toSet(), containsAll(["user_1", "user_2", "user_3"]));

        expect(mockRemoteDataSource.updateGroupCalled, true);
        expect(mockRemoteDataSource.updatedGroup?.matches, drawnGroup.matches);
      },
    );

    test('should return Failure when group is not active', () async {
      // arrange
      final group = GroupModel(
        id: tGroupId,
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
        state: GroupStatus.draft, // not active
      );

      mockRemoteDataSource.mockGroup = group;

      // act
      final result = await drawPairsUseCase(tGroupId);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, "Group is not active"),
        (_) => fail("Should not succeed"),
      );
    });

    test(
      'should return Failure when group has less than 3 participants',
      () async {
        // arrange
        final group = GroupModel(
          id: tGroupId,
          title: "Test Group",
          authorUID: "user_1",
          participants: const {
            "user_1": UserStatus.confirmed,
            "user_2": UserStatus.confirmed,
          },
          participantsUIDs: const ["user_1", "user_2"],
          budgetLimit: 10,
          currency: "USD",
          eventDate: DateTime.now(),
          createdAt: DateTime.now(),
          inviteCode: "123456",
          state: GroupStatus.active,
        );

        mockRemoteDataSource.mockGroup = group;

        // act
        final result = await drawPairsUseCase(tGroupId);

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) =>
              expect(failure.message, "Group has less than 3 participants"),
          (_) => fail("Should not succeed"),
        );
      },
    );
  });
}
