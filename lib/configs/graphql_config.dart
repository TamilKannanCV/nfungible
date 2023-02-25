import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlConfig {
  final httpLink =
      HttpLink(dotenv.get('NIFTORY_STAGING_QUERY_URL'), defaultHeaders: {
    "X-Niftory-API-Key": dotenv.get('NIFTORY_API_KEY'),
    "X-Niftory-Client-Secret": dotenv.get('NIFTORY_CLIENT_SECRET_ID'),
  });

  GraphQLClient clientToQuery() => GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      );
}
