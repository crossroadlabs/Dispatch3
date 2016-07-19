//===--- DispatchTime.swift ------------------------------------------------===//
//Copyright (c) 2016 Daniel Leping (dileping)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.
//===----------------------------------------------------------------------===//

import Foundation

#if swift(>=3.0) && !os(Linux)
#else
    public struct DispatchTime {
        
        public let rawValue: dispatch_time_t
        
        public static func now() -> DispatchTime {
            return DispatchTime(rawValue: DISPATCH_TIME_NOW)
        }
        
        public static let distantFuture: DispatchTime = DispatchTime(rawValue: DISPATCH_TIME_FOREVER)
    }
    
    
    public struct DispatchWallTime {
        
        public let rawValue: dispatch_time_t
        
        init(rawValue: dispatch_time_t) {
            self.rawValue = rawValue
        }
        
        public static func now() -> DispatchWallTime {
            return DispatchWallTime(rawValue:DISPATCH_TIME_NOW)
        }
        
        public static let distantFuture: DispatchWallTime = DispatchWallTime(rawValue: DISPATCH_TIME_FOREVER)
        
        public init(time: timespec) {
            var t = time
            self.init(rawValue: dispatch_walltime(&t, 0))
        }
    }
    
    public enum DispatchTimeoutResult {
        case Success
        case TimedOut
    }
    
    
    public enum DispatchTimeInterval {
        case seconds(Int)
        case milliseconds(Int)
        case microseconds(Int)
        case nanoseconds(Int)
        
        public func toDispatchTimeT() -> dispatch_time_t {
            switch self {
            case .seconds(let t):
                return UInt64(t)*NSEC_PER_SEC
            case .milliseconds(let t):
                return UInt64(t)*NSEC_PER_MSEC
            case .microseconds(let t):
                return UInt64(t)*NSEC_PER_USEC
            case .nanoseconds(let t):
                return UInt64(t)
            }
        }
    }
    
    func +(time: DispatchTime, interval: DispatchTimeInterval) -> DispatchTime {
        return DispatchTime(rawValue:dispatch_time(time.rawValue, Int64(interval.toDispatchTimeT())))
    }
    
    func -(time: DispatchTime, interval: DispatchTimeInterval) -> DispatchTime {
        return DispatchTime(rawValue:dispatch_time(time.rawValue, -Int64(interval.toDispatchTimeT())))
    }
    
    func +(time: DispatchTime, seconds: Double) -> DispatchTime {
        return DispatchTime(rawValue:dispatch_time(time.rawValue, Int64(dispatch_time_t(seconds*Double(NSEC_PER_SEC)))))
    }
    
    func -(time: DispatchTime, seconds: Double) -> DispatchTime {
        return DispatchTime(rawValue:dispatch_time(time.rawValue, -Int64(dispatch_time_t(seconds*Double(NSEC_PER_SEC)))))
    }
    
    func +(time: DispatchWallTime, interval: DispatchTimeInterval) -> DispatchWallTime {
        return DispatchWallTime(rawValue:dispatch_time(time.rawValue, Int64(interval.toDispatchTimeT())))
    }
    
    func -(time: DispatchWallTime, interval: DispatchTimeInterval) -> DispatchWallTime {
        return DispatchWallTime(rawValue:dispatch_time(time.rawValue, -Int64(interval.toDispatchTimeT())))
    }
    
    func +(time: DispatchWallTime, seconds: Double) -> DispatchWallTime {
        return DispatchWallTime(rawValue:dispatch_time(time.rawValue, Int64(dispatch_time_t(seconds*Double(NSEC_PER_SEC)))))
    }
    
    func -(time: DispatchWallTime, seconds: Double) -> DispatchWallTime {
        return DispatchWallTime(rawValue:dispatch_time(time.rawValue, -Int64(dispatch_time_t(seconds*Double(NSEC_PER_SEC)))))
    }
#endif
