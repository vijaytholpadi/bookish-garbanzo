//
//  VTNetworkResponse.h
//
//  Created by Vijay Tholpadi on 9/29/14.
//  Copyright (c) 2015 TheGeekProjekt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTError.h"

@interface VTNetworkResponse : NSObject
@property (nonatomic, assign) BOOL isSuccessful;
@property (nonatomic, retain) VTError * error;
@property (nonatomic, retain) id data;

@end
