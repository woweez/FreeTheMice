//
//  InAppUtils.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 01/10/2013.
//
//

#import "InAppUtils.h"

@implementation InAppUtils
 NSMutableArray *_products;


+ (InAppUtils *)sharedInstance {
    static dispatch_once_t once;
    static InAppUtils * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.woweez.ftm.pieceofcheese",
                                      @"com.woweez.ftm.cheesecake",
                                      @"com.woweez.ftm.cheesecontainer",
                                      @"com.woweez.freethemice.pieceofcheese",
                                      @"com.woweez.freethemice.cheesecontainertest",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}


@end
