import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tot_pos/core/network/failure.dart';
import 'package:tot_pos/core/network/graph_config.dart';
import 'package:tot_pos/data/models/response/graph/user_data_response_model.dart';
import 'package:tot_pos/data/repository/base/anonymous_customer_repo_base.dart';
import 'package:tot_pos/depency_injection.dart';

import '../../../core/constants/local_keys.dart';

class AnonymousCustomerRepoImpl implements AnonymousCustomerRepoBase {
  final GraphService graphService;
  AnonymousCustomerRepoImpl({
    required this.graphService,
  });
  @override
  Future<Either<Failure, UserDataModel>> getUser() async {
    try {
      final response = await graphService.client.query(
        QueryOptions(
          document: gql(r'''query Me {
    me {
        memberId
        accessFailedCount
        createdBy
        createdDate
        email
        emailConfirmed
        id
        isAdministrator
        lockoutEnabled
        lockoutEnd
        memberId
        modifiedBy
        modifiedDate
        normalizedEmail
        normalizedusername
        passwordExpired
        phoneNumber
        phoneNumberConfirmed
        photoUrl
        permissions
        securityStamp
        storeId
        twoFactorEnabled
        username
        userType
        forcePasswordChange
        lockedState
    }
}
'''),
          // fetchPolicy: FetchPolicy.cacheFirst,
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      log("::: me response: $response :::");
      if (response.data != null) {
        UserDataModel userData = UserDataModel.fromJson(response.data!);

        await preferences.setString(
            LocalKeys.memberId, userData.me.memberId ?? "");
        final memberId = preferences.getString(LocalKeys.memberId);

        log("::: login - memberId: $memberId :::");

        return Right(userData);
      } else {
        return const Left(ServerFailure("Something went wrong"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}