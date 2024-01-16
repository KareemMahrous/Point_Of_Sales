import '../../../core/types/types.dart';
import '../../../core/usecase/usecase.dart';
import '../../../data/customers/responses/customers_response/tot_customers.dart';
import '../repo/customers_repo.dart';

class FetchCustomersUsecase
    implements
        BaseUsecase<NoParams, FutureEitherFailureOrType<List<Member>>> {
  final CustomersRepo _customerRepo;

  FetchCustomersUsecase({required CustomersRepo customersRepo})
      : _customerRepo = customersRepo;

  @override
  FutureEitherFailureOrType<List<Member>> call(NoParams noParams) {
    return _customerRepo.fetchCustomers();
  }
}
