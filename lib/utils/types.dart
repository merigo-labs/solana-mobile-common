/// Types
/// ------------------------------------------------------------------------------------------------

// Integers
// 
// Native applications (mobile/desktop) representations:
// 
//   [int]    = 64-bit signed two's complement.
//              -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807
// 
//   [double] = 64-bit floating point.
//              0,
//              2.2250738585072014e-308 to 1.7976931348623158e+308,
//              -1.7976931348623158e+308 to -2.2250738585072014e-308
// 
// TODO: Handle `u64` and `usize` integer representations correctly. 
// 
//   [u64]   = Values >= 2^63 will overflow.
// 
//   [usize] = Values >= 2^63 will overflow on 64-bit architectures.
//              

typedef i8    = int;  // ignore: camel_case_types
typedef u8    = int;  // ignore: camel_case_types
typedef i16   = int;  // ignore: camel_case_types
typedef u16   = int;  // ignore: camel_case_types
typedef i32   = int;  // ignore: camel_case_types
typedef u32   = int;  // ignore: camel_case_types
typedef i64   = int;  // ignore: camel_case_types
typedef u64   = int;  // ignore: camel_case_types
typedef isize = int;  // ignore: camel_case_types
typedef usize = int;  // ignore: camel_case_types

// Floats
typedef f32   = double; // ignore: camel_case_types
typedef f64   = double; // ignore: camel_case_types

/// A function signature to convert an [input] value of type `U` into an instance of type `T`.
typedef JsonRpcParser<T, U> = T Function(U input);

/// A function signature to convert an [Object] into an instance of type `T`.
typedef JsonRpcObjectParser<T> = JsonRpcParser<T, Object>;

/// A function signature to convert a JSON object into an instance of type `T`.
typedef JsonRpcMapParser<T> = JsonRpcParser<T, Map<String, dynamic>>;

/// A function signature to convert a List into list of type `T`.
typedef JsonRpcListParser<T> = JsonRpcParser<List<T>, List>;

/// A subscription's unique identifier.
typedef SubscriptionId = int;

/// An opaque string representing a unique identifying token issued by the wallet endpoint to the 
/// dApp endpoint. The format and contents are an implementation detail of the wallet endpoint. The 
/// dApp endpoint can use this on future connections to reauthorize access to privileged methods.
typedef AuthToken = String;

/// A base-64 encoded `account address`.
typedef Base64EncodedAddress = String;

/// A base-64 encoded `transaction signature`.
typedef Base64EncodedSignature = String;

/// A base-64 encoded `message payload`.
typedef Base64EncodedMessage = String;

/// A base-64 encoded `signed message`.
typedef Base64EncodedSignedMessage = String;

/// A base-64 encoded `signed transaction`.
typedef Base64EncodedSignedTransaction = String;

/// A base-64 encoded `transaction payload`.
typedef Base64EncodedTransaction = String;