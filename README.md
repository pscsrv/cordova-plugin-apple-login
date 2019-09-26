# cordova-plugin-apple-login

## Install

```
npm i cordova-plugin-apple-login
```

## Usage

### `SignInWithApple.isAvailable()`

Returns true if Sign in with Apple is available.

#### Sample: 

```js
SignInWithApple.isAvailable().then(function (isAvailable) {
  console.info(isAvailable)
})
```

### `SignInWithApple.request(options)`

Request authentication for Apple ID.

#### Options: 

```js
{
  requestedScopes: [ SignInWithApple.Scope.Email ],
  requestedOperation: SignInWithApple.Operation.Login,
  user: 'userId',
  state: 'state',
  nonce: 'nonce'
}
```

#### Returns: 

```js
{
  authorizedScopes: [],
  identityToken: 'identityToken',
  authorizationCode: 'authorizationCode',
  realUserStatus: 1,
  fullName: {
    namePrefix: null,
    givenName: null,
    nameSuffix: null,
    middleName: null,
    familyName: null,
    nickname: null
  },
  email: null,
  state: null,
  user: 'userId'
}
```

see: https://developer.apple.com/documentation/authenticationservices/asauthorizationappleidcredential

#### Sample: 

```js
SignInWithApple.request({
  requestedScopes: [ SignInWithApple.Scope.Email, SignInWithApple.Scope.FullName ],  
}).then(function (credential) {
  console.info(credential)
})
```

### `SignInWithApple.getCredentialState(options)`

Returns the user credential status.

#### Options: 

```js
{
  userId: 'userId'
}
```

#### Returns: 

see: https://developer.apple.com/documentation/authenticationservices/asauthorizationappleidprovider/credentialstate

#### Sample: 

```js
SignInWithApple.getCredentialState({
  userId: 'userId',  
}).then(function (credentialState) {
  console.info(credentialState)
})
```
