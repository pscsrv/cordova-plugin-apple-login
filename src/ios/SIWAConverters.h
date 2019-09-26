@interface SIWAConverters: NSObject

+ (NSArray<ASAuthorizationScope> *)convertScopes: (NSArray<NSNumber *> *)scopes;
+ (ASAuthorizationOpenIDOperation)convertOperation: (NSNumber *)operation;

+ (NSDictionary *)convertCredential: (ASAuthorizationAppleIDCredential *)credential;

@end
