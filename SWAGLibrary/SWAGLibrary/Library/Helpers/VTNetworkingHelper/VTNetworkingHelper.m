//
//  VTNetworkingHelper.m
//
//  Created by Vijay Tholpadi on 9/29/14.
//  Copyright (c) 2015 TheGeekProjekt. All rights reserved.
//

#import "VTNetworkingHelper.h"
#import "AFNetworking.h"

@implementation VTNetworkingHelper

-(id)init{
    if (self = [super init]) {
    }
    return self;
}


+ (VTNetworkingHelper *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (void)performRequestWithPath:(NSString *)path withAuth:(BOOL)needsAuth withRequestJSONSerialized:(BOOL)reqJSONSerialized withCompletionHandler:(VTNetworkRequestCompletionHandler) handler {
    [self performRequestWithPath:path withAuth:needsAuth forMethod:@"GET" withRequestJSONSerialized:reqJSONSerialized withParams:nil withCompletionHandler:handler];
}


- (void)performRequestWithPath:(NSString *)path withAuth:(BOOL)needsAuth forMethod:(NSString *)method withRequestJSONSerialized:(BOOL)reqJSONSerialized withParams:(id)params withCompletionHandler:(VTNetworkRequestCompletionHandler) handler {
    
    //Reachability detection
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                break;
            }
            case AFNetworkReachabilityStatusNotReachable: {
                break;
            }
            default: {
                break;
            }
        }
    }];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if(reqJSONSerialized == NO){
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    }
    
    if (needsAuth){
        [manager.requestSerializer clearAuthorizationHeader];
    }
    
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //Depending on the method type we proceed to the corresponding execution
    if([method isEqualToString:@"POST"]) {
        [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if(handler) {
                handler([self prepareResponseObject:TRUE withData:responseObject andError:nil]);
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (NSLocationInRange(operation.response.statusCode, NSMakeRange(400, 99))) {
                if(handler) {
                    VTError *errorDetails = [self prepareErrorObjectWithOperation:operation andError:error];
                    handler([self prepareResponseObject:FALSE withData:nil andError:errorDetails]);
                }
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
        
    } else if ([method isEqualToString:@"GET"]) {
        [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (handler) {
                handler([self prepareResponseObject:TRUE withData:responseObject andError:nil]);
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (NSLocationInRange(operation.response.statusCode, NSMakeRange(400, 99))) {
                if(handler) {
                    VTError *errorDetails = [self prepareErrorObjectWithOperation:operation andError:error];
                    handler([self prepareResponseObject:FALSE withData:nil andError:errorDetails]);
                }
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
        
    } else if ([method isEqualToString:@"PUT"]) {
        [manager PUT:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (handler) {
                handler([self prepareResponseObject:TRUE withData:responseObject andError:nil]);
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (NSLocationInRange(operation.response.statusCode, NSMakeRange(400, 99))) {
                if(handler) {
                    VTError *errorDetails = [self prepareErrorObjectWithOperation:operation andError:error];
                    handler([self prepareResponseObject:FALSE withData:nil andError:errorDetails]);
                }
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
        
    } else if ([method isEqualToString:@"DELETE"]) {
        [manager DELETE:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (handler) {
                handler([self prepareResponseObject:TRUE withData:responseObject andError:nil]);
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (NSLocationInRange(operation.response.statusCode, NSMakeRange(400, 99))) {
                if(handler) {
                    VTError *errorDetails = [self prepareErrorObjectWithOperation:operation andError:error];
                    handler([self prepareResponseObject:FALSE withData:nil andError:errorDetails]);
                }
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }
}


#pragma mark - Helper functions
- (VTNetworkResponse *)prepareResponseObject:(BOOL) success
                                    withData:(id)response
                                    andError: (VTError *)error{
    VTNetworkResponse *responseDetails = [[VTNetworkResponse alloc] init];
    responseDetails.isSuccessful = success;
    responseDetails.data = response;
    responseDetails.error = error;
    return responseDetails;
}


- (VTError*)prepareErrorObjectWithOperation:(AFHTTPRequestOperation*)operation andError:(NSError*)error {
    VTError *errorDetails = [[VTError alloc] init];
    errorDetails.errorDictionary = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
    errorDetails.error = error;
    return errorDetails;
}


- (void)dealloc {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}


@end

