import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tot_pos/core/network/failure.dart';
import 'package:tot_pos/core/network/graph_config.dart';
import 'package:tot_pos/data/repository/base/update_personal_data_repo_base.dart';

class UpDatePersonalDataRepoImpl implements UpdatePersonalDataRepoBase {
  final GraphService graphService;

  UpDatePersonalDataRepoImpl(this.graphService);

  @override
  Future<Either<Failure, bool>> updatePersonaldata({
    required String lastName,
    required String firstName,
  }) async {
    try {
      final res = await graphService.client.query(
        QueryOptions(
          document: gql(r''' 
        mutation UpdatePersonalData(
    $firstName:String!,
    $lastName:String!
) {
    updatePersonalData(
        command: {
            personalData: 
            {
                  firstName: $firstName
                  lastName: $lastName
            }                   
                  }
    ) {
        succeeded
    }
}
          '''),
          variables: {
            "firstName": firstName,
            "lastName": lastName,
          },
        ),
      );
      if (res.hasException) {
        return const Left(ServerFailure(''));
      }
      if (res.data != null) {
        bool isSucceeded = res.data!['updatePersonalData']['succeeded'];
        log('gggggggggggg$isSucceeded');
        return Right(isSucceeded);
      } else {
        return const Left(
            ServerFailure('someThings failed in updatePersonalData'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}