#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>

#import "SIWAConverters.h"

id SIWANullIfNil(id value)
{
    return value == nil ? [NSNull null] : value;
}

@implementation SIWAConverters

+ (NSArray<ASAuthorizationScope> *)convertScopes: (NSArray<NSNumber *> *)scopes
{
    NSMutableArray<ASAuthorizationScope> *convertedScopes = [NSMutableArray array];
    
    for (NSNumber *scope in scopes) {
        ASAuthorizationScope convertedScope = [self convertScope:scope];
        if (convertedScope != nil) {
            [convertedScopes addObject:convertedScope];
        }
    }
    
    return convertedScopes;
}

+ (ASAuthorizationScope)convertScope: (NSNumber *)scope
{
    switch (scope.intValue) {
        case 0:
            return ASAuthorizationScopeFullName;
        case 1:
            return ASAuthorizationScopeEmail;
        default:
            return nil;
    }
}

+ (ASAuthorizationOpenIDOperation)convertOperation: (NSNumber *)operation
{
    switch (operation.intValue) {
        case 0:
            return ASAuthorizationOperationImplicit;
        case 1:
            return ASAuthorizationOperationLogin;
        case 2:
            return ASAuthorizationOperationRefresh;
        case 3:
            return ASAuthorizationOperationLogout;
        default:
            return nil;
    }
}

+ (NSDictionary *)convertCredential: (ASAuthorizationAppleIDCredential *)credential
{
    return @{
        @"user": credential.user,
        @"authorizedScopes": [self convertAuthorizedScopes:credential.authorizedScopes],
        @"state": SIWANullIfNil(credential.state),
        @"authorizationCode": [self convertData:credential.authorizationCode],
        @"identityToken": [self convertData:credential.identityToken],
        @"email": SIWANullIfNil(credential.email),
        @"fullName": SIWANullIfNil([SIWAConverters convertName:credential.fullName]),
        @"realUserStatus": @(credential.realUserStatus)
    };
}

+ (NSArray<NSNumber *> *)convertAuthorizedScopes: (NSArray<ASAuthorizationScope> *)authorizedScopes
{
    NSMutableArray<NSNumber *> *convertedScopes = [NSMutableArray array];
    
    for (ASAuthorizationScope authorizedScope in authorizedScopes) {
        NSNumber *convertedScope = [self convertAuthorizedScope:authorizedScope];
        if (convertedScope != nil) {
            [convertedScopes addObject:convertedScope];
        }
    }
    
    return convertedScopes;
}

+ (NSNumber *)convertAuthorizedScope: (ASAuthorizationScope)authorizedScope
{
    if (authorizedScope == ASAuthorizationScopeFullName) {
        return @0;
    } else if (authorizedScope == ASAuthorizationScopeEmail) {
        return @1;
    } else {
        return nil;
    }
}

+ (NSString *)convertData: (NSData *)data
{
    if (data == nil) return nil;

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSDictionary<NSString *, id> *)convertName:(NSPersonNameComponents *)name
{
    if (name == nil) return nil;
    
    NSMutableDictionary *convertedName = [@{
        @"namePrefix": SIWANullIfNil(name.namePrefix),
        @"givenName": SIWANullIfNil(name.givenName),
        @"middleName": SIWANullIfNil(name.middleName),
        @"familyName": SIWANullIfNil(name.familyName),
        @"nameSuffix": SIWANullIfNil(name.nameSuffix),
        @"nickname": SIWANullIfNil(name.nickname)
    } mutableCopy];
    
    if (name.phoneticRepresentation != nil) {
        [convertedName setObject:[self convertName:name.phoneticRepresentation] forKey:@"phoneticRepresentation"];
    }
    
    return convertedName;
}

@end
