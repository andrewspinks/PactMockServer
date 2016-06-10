//
//  PublicHeaders.h
//  PactMockServer
//
//  Created by Andrew Spinks on 9/06/2016.
//  Copyright © 2016 Pact. All rights reserved.
//

#ifndef PublicHeaders_h
#define PublicHeaders_h

int32_t create_mock_server(const char *pact);
bool mock_server_matched(int32_t port);
const char *mock_server_mismatches(int32_t port);
bool cleanup_mock_server(int32_t port);
int32_t write_pact_file(int32_t port);

#endif /* PublicHeaders_h */
