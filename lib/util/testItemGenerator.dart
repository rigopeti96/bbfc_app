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
        username: "CreatorUser",
        password: "CreatorUser",
        email: "creator@us.er",
        roles: Permission.ADMIN,
        ratings: ratingList,
        playerStatus: Status.AVAILABLE
    );

    return user;
  }

  User createAppliedUser1(){
    User user = User(
        id: const Uuid().v4(),
        modifyDate: DateTime.now(),
        name: "Applied User 1",
        username: "AppliedUser1",
        password: "AppliedUser1",
        email: "applied1@us.er",
        roles: Permission.PLAYER,
        ratings: ratingList,
        playerStatus: Status.AVAILABLE
    );

    return user;
  }

  User createAppliedUser2(){
    User user = User(
        id: const Uuid().v4(),
        modifyDate: DateTime.now(),
        name: "Applied User 2",
        username: "AppliedUser2",
        password: "AppliedUser2",
        email: "applied2@us.er",
        roles: Permission.PLAYER,
        ratings: ratingList,
        playerStatus: Status.SUSPENDED
    );

    return user;
  }

  User createAppliedUser3(){
    User user = User(
        id: const Uuid().v4(),
        modifyDate: DateTime.now(),
        name: "Applied User 3",
        username: "AppliedUser3",
        password: "AppliedUser3",
        email: "applied3@us.er",
        roles: Permission.LEADER,
        ratings: ratingList,
        playerStatus: Status.AVAILABLE
    );

    return user;
  }
}