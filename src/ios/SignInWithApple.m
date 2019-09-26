#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>

#import "SignInWithApple.h"
#import "SIWAConverters.h"

@interface SignInWithApple () <ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@property (nonatomic) CDVInvokedUrlCommand* command;

@end

@implementation SignInWithApple

- (void)isAvailable:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult *pluginResult;
    if (@available(iOS 13.0, *)) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:NO];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)request:(CDVInvokedUrlCommand*)command
{    
    NSDictionary *options = command.arguments[0];
    
    if (@available(iOS 13.0, *)) {
        self.command = command;
        [self requestWithOptions:options];
    } else {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{
            @"error": @"UNAVAILABLE_ERROR",
            @"message": @"This device does not support Sign in with Apple."
        }];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)getCredentialState:(CDVInvokedUrlCommand*)command
{
    NSDictionary *options = command.arguments[0];

    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
        [provider getCredentialStateForUserID:options[@"userId"] completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSInteger:credentialState];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    } else {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{
            @"error": @"UNAVAILABLE_ERROR",
            @"message": @"This device does not support Sign in with Apple."
        }];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)requestWithOptions: (NSDictionary *)options
{
    ASAuthorizationAppleIDRequest *request = [[[ASAuthorizationAppleIDProvider alloc] init] createRequest];
    
    if (options[@"requestedScopes"]) {
        request.requestedScopes = [SIWAConverters convertScopes:options[@"requestedScopes"]];
    }
    if (options[@"requestedOperation"]) {
         request.requestedOperation = [SIWAConverters convertOperation:options[@"requestedOperation"]];
    }
    if (options[@"user"]) {
        request.user = options[@"user"];
    }
    if (options[@"state"]) {
        request.state = options[@"state"];
    }
    if (options[@"nonce"]) {
        request.nonce = options[@"nonce"];
    }
    
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
}

#pragma mark - ASAuthorizationControllerDelegate

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization
{
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:[SIWAConverters convertCredential:authorization.credential]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
    self.command = nil;
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error
{
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{
        @"error": @"REQUEST_ERROR",
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
    self.command = nil;
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller
{
    return self.viewController.view.window;
}

@end
