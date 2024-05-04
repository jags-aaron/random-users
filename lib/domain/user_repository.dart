import 'package:club_hub_tech_test/data/source/remote_source.dart';

import '../data/model/filter.dart';
import '../data/source/local_source.dart';
import 'entity/user.dart';

abstract class UserRepository {
  Future<List<User>> fetchRandomUsers({
    required Filter filter,
  });

  Future<Filter> getFilterFromPrefs();
  Future<void> saveFilterPrefs({required Filter filter});
}

class UserRepositoryImp implements UserRepository {
  UserRepositoryImp({
    required this.remoteSource,
    required this.localSource,
  });

  final RemoteDataSource remoteSource;
  final LocalSource localSource;

  @override
  Future<List<User>> fetchRandomUsers({
    required Filter filter,
  }) async {
    const defaultPicture =
        'https://media.istockphoto.com/id/1495088043/vector/user-profile-icon-avatar-or-person-icon-profile-picture-portrait-symbol-default-portrait.jpg?s=612x612&w=0&k=20&c=dhV2p1JwmloBTOaGAtaA3AW1KSnjsdMt7-U_3EZElZ0=';
    final modelResponse = await remoteSource.fetchRandomUsers(filter: filter);
    final results = modelResponse.results
        ?.map((model) => User(
              gender: '${model.gender}',
              nationality: '${model.nat}',
              name: '${model.name?.first} ${model.name?.last}',
              location: '${model.location?.city}, ${model.location?.state}',
              email: '${model.email}',
              dob: '${model.dob}',
              phone: '${model.phone}',
              id: '${model.id?.value}',
              picture: model.picture?.large ?? defaultPicture
            ))
        .toList();

    return results ?? [];
  }

  @override
  Future<Filter> getFilterFromPrefs() async {
    return localSource.getFilters();
  }

  @override
  Future<void> saveFilterPrefs({required Filter filter}) async {
    return localSource.saveFilters(filter: filter);
  }
}
