//
//  Created by Anthony Shoumikhin on 6/25/15.
//  Copyright © 2015 shoumikh.in. All rights reserved.
//

import Foundation

//==============================================================================
public class StreamScanner
{
    static let standard = StreamScanner(source: NSFileHandle.fileHandleWithStandardInput())
    private let source: NSFileHandle
    private let delimiters: NSCharacterSet
    private var buffer: NSScanner?

    public init(source: NSFileHandle,
            delimiters: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet())
    {
        self.source = source
        self.delimiters = delimiters
    }

    public func next<T>() -> T?
    {
        if buffer == nil || buffer!.atEnd
        {
            if let nextInput = NSString(data: source.availableData,
                                    encoding: NSUTF8StringEncoding)
            {
                buffer = NSScanner(string: nextInput as String)
            }
        }

        var token: NSString?

        buffer?.scanUpToCharactersFromSet(delimiters, intoString: &token)

        if token != nil
        {
            return scan(token as! String)
        }

        return nil
    }

    private func scan<T>(token: String) -> T?
    {
        let scanner = NSScanner(string: token)
        var ret: T? = nil

        switch ret
        {
        case is String? :
            var value: NSString? = ""
            if scanner.scanString(token, intoString: &value)
            {
                ret = value as? T
            }
        case is Int? :
            var value: Int = 0
            if scanner.scanInteger(&value)
            {
                ret = value as? T
            }
        case is Int32? :
            var value: Int32 = 0
            if scanner.scanInt(&value)
            {
                ret = value as? T
            }
        case is Int64? :
            var value: Int64 = 0
            if scanner.scanLongLong(&value)
            {
                ret = value as? T
            }
        case is UInt64? :
            var value: UInt64 = 0
            if scanner.scanUnsignedLongLong(&value)
            {
                ret = value as? T
            }
        case is Float? :
            var value: Float = 0
            if scanner.scanFloat(&value)
            {
                ret = value as? T
            }
        case is Double? :
            var value: Double = 0
            if scanner.scanDouble(&value)
            {
                ret = value as? T
            }
        default :
            ret = nil
        }

        return ret
    }
}
//------------------------------------------------------------------------------
infix operator >>> { associativity left }
public func >>><T>(lhs: StreamScanner, inout rhs: T?) -> StreamScanner
{
    rhs = lhs.next()

    return lhs
}
//==============================================================================
public let cin = StreamScanner.standard
//==============================================================================