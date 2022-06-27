# Internal dependencies

Internally the SDK uses these dependencies. Note, as sourcecode is shared with our Close App, not all of these dependencies are actually used at run-time.

    'SwiftySound', '1.2.0'
    'SQLite.swift', '0.12.2'
    'SnapKit', '5.0.1'
    'ReachabilitySwift', '4.3.0'
    'SwiftSocket', '2.0.2'
    'Device', '3.2.1'
    'BSImagePicker', '2.10.3'
    'Fuzi', '3.1.1'
    'SwiftyRSA', '1.6.0'
    'CryptoSwift', '1.4.1'

These dependencies are statically linked in the SDK. As the SDK itself is a dynamic library framework it should not cause duplicate symbols or other clashes when your project is using the same libraries.

[Back to the main page](../README.md)
