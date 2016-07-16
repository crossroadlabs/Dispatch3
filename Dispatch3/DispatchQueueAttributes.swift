//===--- DispatchQueueAttributes.swift -------------------------------------===//
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
import Dispatch
import Boilerplate

#if swift(>=3.0) && !os(Linux)
#else
    public struct DispatchQueueAttributes : OptionSet, RawRepresentable {
        public typealias Element = DispatchQueueAttributes
        public typealias RawValue = UInt64
        
        public let rawValue: RawValue
        
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
        public static let serial = DispatchQueueAttributes(rawValue: 1)
        public static let concurrent = DispatchQueueAttributes(rawValue: 2)
        
        public static let qosUserInteractive = DispatchQueueAttributes(rawValue: 4)
        public static let qosUserInitiated = DispatchQueueAttributes(rawValue: 8)
        public static let qosDefault = DispatchQueueAttributes(rawValue: 16)
        public static let qosUtility = DispatchQueueAttributes(rawValue: 32)
        public static let qosBackground = DispatchQueueAttributes(rawValue: 64)
        
        public static let `default` = DispatchQueueAttributes.serial
    }
    
    func dispatchAttrTFromQueueAttributes(dispatchQueueAttributes attributes: DispatchQueueAttributes, relativePriority: Int) -> dispatch_queue_attr_t {
        let attr = attributes == .concurrent ? DISPATCH_QUEUE_CONCURRENT : DISPATCH_QUEUE_SERIAL
        var qos: dispatch_qos_class_t
        if attributes == .qosUserInteractive {
            qos = QOS_CLASS_USER_INTERACTIVE
        } else if attributes == .qosUserInitiated {
            qos = QOS_CLASS_USER_INITIATED
        } else if attributes == .qosBackground {
            qos = QOS_CLASS_BACKGROUND
        } else if attributes == .qosUtility {
            qos = QOS_CLASS_UTILITY
        } else if attributes == .qosDefault {
            qos = QOS_CLASS_DEFAULT
        } else {
            qos = QOS_CLASS_UNSPECIFIED
        }
        
        return dispatch_queue_attr_make_with_qos_class(attr, qos, Int32(relativePriority))
    }
#endif
