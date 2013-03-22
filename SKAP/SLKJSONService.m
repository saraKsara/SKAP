//
//  SLKJSONService.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-22.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKJSONService.h"

@implementation SLKJSONService
+(void)getAllPizzas
{
    NSString *listAllPizzas =@"pizzas";
    ANSHTTPAPIClient *client = [ANSHTTPAPIClient sharedClient];
    NSString* path =listAllPizzas;
    NSURLRequest* request = [client requestWithMethod:@"GET" path:path parameters:nil];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
        if ([[[ANSPizzaStorage sharedStorage] getPizzas] count] == 0) {
            
            for (NSDictionary *dict in JSON)
            {
                NSMutableSet *toppingSet = [[NSMutableSet alloc] init];
                
                for(NSDictionary *topping in [dict objectForKey:@"toppings"] )
                {
                    Topping *aTopping = [[ANSToppingstorage sharedStorage]createToppingWithDetails:[[topping objectForKey:@"id"] stringValue]
                                                                                              name:[topping objectForKey:@"name"]];
                    
                    [toppingSet addObject:aTopping];
                }
                
                Pizza *p = [[ANSPizzaStorage sharedStorage] createPizzaWithDetails:[dict objectForKey:@"name"]
                                                                                id:[[dict objectForKey:@"id"] stringValue]
                                                                             price:[[dict objectForKey:@"price"] intValue]
                                                                              base:nil
                                                                           topping:nil
                                                                             order:nil];
                
                [p addToppings:toppingSet];
            }
            
        }
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Fail");
    }];
    [operation start];
}

+(void)postOrder:(NSDictionary*)order onSuccess:(void (^)(NSDictionary *))success onFailure:(void (^)(NSDictionary *, NSHTTPURLResponse*))failure
{
    
    ANSHTTPAPIClient *client = [ANSHTTPAPIClient sharedClient];
    
    NSString* path =@"pizzaorders?param=val";
    
    NSURLRequest* request = [client requestWithMethod:@"POST" path:path parameters:order];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            success(JSON);
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            failure(JSON, response);
                                                                                            NSLog(@"FAILURE, JSON RESP %@", response);
                                                                                        }];
    [operation start];
    
}
@end
