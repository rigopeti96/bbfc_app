import 'package:bbfc_application/entity/rating.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/enum/permisson.dart';
import 'package:bbfc_application/enum/status.dart';
import 'package:uuid/uuid.dart';

class TestItemGenerator {
  Set<Rating> ratingList = {};
  User createCreatorUser(){
    User user = User(
        id: const Uuid().v4(),
        modifyDate: DateTime.now(),
        name: "Creator User",
        phoneNumber: "+36203917383",
        birthDay: DateTime(1990, 06, 20),
        birthPlace: "Budapest",
        username: "CreatorUser",
        password: "a",
        email: "creator@us.er",
        roles: Permission.ADMIN,
        goals: 2,
        assists: 1,
        injuredUntil: null,
        suspendedUntil: null,
        matchPlayed: 20,
        ratings: {},
        playerStatus: Status.AVAILABLE
    );

    return user;
  }

  User createAppliedUser1(){
    User user = User(
        id: const Uuid().v4(),
        modifyDate: DateTime.now(),
        name: "Applied User 1",
        phoneNumber: "+36203917383",
        birthDay: DateTime(1990, 06, 20),
        birthPlace: "Taktaharkány",
        username: "AppliedUser1",
        password: "a",
        email: "applied1@us.er",
        roles: Permission.ADMIN,
        goals: 0,
        assists: 5,
        injuredUntil: DateTime(2024, 11, 20),
        suspendedUntil: null,
        matchPlayed: 104,
        ratings: {},
        playerStatus: Status.INJURED
    );

    return user;
  }

  User createAppliedUser2(){
    User user = User(
        id: const Uuid().v4(),
        modifyDate: DateTime.now(),
        name: "Applied User 2",
        phoneNumber: "+36203917383",
        birthDay: DateTime(1990, 06, 20),
        birthPlace: "Heringespuszta",
        username: "AppliedUser2",
        password: "a",
        email: "applied2@us.er",
        roles: Permission.ADMIN,
        goals: 2,
        assists: 3,
        injuredUntil: null,
        suspendedUntil: DateTime(2024, 10, 31),
        matchPlayed: 174,
        ratings: {},
        playerStatus: Status.SUSPENDED
    );

    return user;
  }

  User createAppliedUser3(){
    User user = User(
        id: const Uuid().v4(),
        modifyDate: DateTime.now(),
        name: "Applied User 3",
        phoneNumber: "+36203917383",
        birthDay: DateTime(1990, 06, 20),
        birthPlace: "Bivalybasznád",
        username: "AppliedUser3",
        password: "a",
        email: "applied3@us.er",
        roles: Permission.ADMIN,
        goals: 6,
        assists: 1,
        injuredUntil: null,
        suspendedUntil: null,
        matchPlayed: 83,
        ratings: {},
        playerStatus: Status.AVAILABLE
    );

    return user;
  }
}