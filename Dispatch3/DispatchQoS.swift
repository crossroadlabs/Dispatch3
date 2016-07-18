//===--- DispatchQoS.swift ------------------------------------------------===//
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
    public struct DispatchQoS : Equatable {
        public let qosClass: DispatchQoS.QoSClass
        public let relativePriority: Int
        
        public static let background = DispatchQoS(qosClass: .background, relativePriority: 0)
        public static let utility = DispatchQoS(qosClass: .utility, relativePriority: 0)
        public static let `default` = DispatchQoS(qosClass: .`default`, relativePriority: 0)
        public static let userInitiated = DispatchQoS(qosClass: .userInitiated, relativePriority: 0)
        public static let userInteractive = DispatchQoS(qosClass: .userInteractive, relativePriority: 0)
        public static let unspecified = DispatchQoS(qosClass: .unspecified, relativePriority: 0)
        
        public struct QoSClass : RawRepresentable {
            public typealias RawValue = UInt32
            
            public let rawValue: RawValue
            public init(rawValue: RawValue) {
                self.rawValue = rawValue
            }
            
            public static let background = QoSClass(rawValue: QOS_CLASS_BACKGROUND.rawValue)
            public static let utility = QoSClass(rawValue: QOS_CLASS_UTILITY.rawValue)
            public static let `default` = QoSClass(rawValue: QOS_CLASS_DEFAULT.rawValue)
            public static let userInitiated = QoSClass(rawValue: QOS_CLASS_USER_INITIATED.rawValue)
            public static let userInteractive = QoSClass(rawValue: QOS_CLASS_USER_INTERACTIVE.rawValue)
            public static let unspecified = QoSClass(rawValue: QOS_CLASS_UNSPECIFIED.rawValue)
        }
        
        public init(qosClass: DispatchQoS.QoSClass, relativePriority: Int) {
            self.qosClass = qosClass
            self.relativePriority = relativePriority
        }
    }
    
    public func ==(lhs: DispatchQoS, rhs: DispatchQoS) -> Bool {
        return lhs.qosClass == rhs.qosClass && lhs.relativePriority == rhs.relativePriority
    }
    
    extension dispatch_qos_class_t {
        static func from(dispatchQoS qos: DispatchQoS) -> dispatch_qos_class_t {
            return dispatch_qos_class_t(rawValue: qos.qosClass.rawValue)
        }
    }
#endif
