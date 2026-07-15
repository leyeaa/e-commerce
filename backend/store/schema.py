'''OpenAPI scoping for the two endpoints in the approved experiment.'''


EXPERIMENT_PATHS = {
    '/api/cart/update/',
    '/api/orders/create/',
}


def keep_experiment_endpoints(endpoints):
    '''Return only endpoint tuples selected by the approved project scope.'''
    return [
        endpoint
        for endpoint in endpoints
        if endpoint[0] in EXPERIMENT_PATHS
    ]


def keep_json_request_media_type(result, generator, request, public):
    '''Keep the formal comparison aligned with the React JSON client.'''
    for path_item in result.get('paths', {}).values():
        for operation in path_item.values():
            request_body = operation.get('requestBody', {})
            content = request_body.get('content', {})
            if 'application/json' in content:
                request_body['content'] = {
                    'application/json': content['application/json'],
                }
    return result
