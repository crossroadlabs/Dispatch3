//===--- DispatchQueue.swift ---------------------------------------------===//
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
import Boilerplate

#if swift(>=3.0) && !os(Linux)
#else
    public final class DispatchSpecificKey<T> {
        init() {}
    }
    
    public class DispatchQueue : DispatchObject {
        var queue:dispatch_queue_t! { return object as! dispatch_queue_t! }
        
        init(queue: dispatch_queue_t) {
            super.init(object: queue)
        }
        
        public convenience init(label: String, attributes: DispatchQueueAttributes = .`default`, target: DispatchQueue? = nil) {
            let attr = dispatchAttrTFromQueueAttributes(dispatchQueueAttributes: attributes, relativePriority: 0)
            self.init(queue: dispatch_queue_create(label, attr))
            if let target = target {
                dispatch_set_target_queue(queue, target.queue)
            }
        }
    }
    
    extension DispatchQueue {
        public struct GlobalAttributes : OptionSet, RawRepresentable {
            public typealias Element = GlobalAttributes
            public typealias RawValue = UInt64
            
            public let rawValue: RawValue
            
            public init(rawValue: RawValue) {
                self.rawValue = rawValue
            }
            
            init(rawValue: UInt32) {
                self.rawValue = UInt64(rawValue)
            }
            
            public static let qosUserInteractive = DispatchQueue.GlobalAttributes(rawValue: DispatchQoS.QoSClass.userInteractive.rawValue)
            public static let qosUserInitiated = DispatchQueue.GlobalAttributes(rawValue: DispatchQoS.QoSClass.userInitiated.rawValue)
            public static let qosDefault = DispatchQueue.GlobalAttributes(rawValue: DispatchQoS.QoSClass.`default`.rawValue)
            public static let qosUtility = DispatchQueue.GlobalAttributes(rawValue: DispatchQoS.QoSClass.utility.rawValue)
            public static let qosBackground = DispatchQueue.GlobalAttributes(rawValue: DispatchQoS.QoSClass.background.rawValue)
            
            public static let `default` = DispatchQueue.GlobalAttributes.qosDefault
        }
    }
    
    extension DispatchQueue {
        
        public var label: String { return String(dispatch_queue_get_label(queue)) }
        
        public var qos: DispatchQoS {
            var relativePriority:Int32 = 0
            let cls = dispatch_queue_get_qos_class(queue, &relativePriority)
            return DispatchQoS(qosClass: DispatchQoS.QoSClass(rawValue: cls.rawValue), relativePriority: Int(relativePriority))
        }
        
        public static let main: DispatchQueue = DispatchQueue(queue: dispatch_get_main_queue())
        
        
        public func getSpecific<Value>(key: DispatchSpecificKey<Value>) -> Value? {
            let val = dispatch_queue_get_specific(queue, unsafeAddress(of: key))
            return val == .null ? nil : UnsafePointer<Value>(val).pointee
        }
        
        public func setSpecific<Value>(key: DispatchSpecificKey<Value>, value: Value) {
            dispatch_queue_set_specific(queue, unsafeAddress(of: key), nil, nil)
        }
        
        
        public class func concurrentPerform(iterations: Int, execute work: (Int) -> Swift.Void) {
            dispatch_apply(iterations, dispatch_get_global_queue(Int(GlobalAttributes.qosDefault.rawValue), 0), work)
        }
        
        public class func global(attributes: DispatchQueue.GlobalAttributes = .`default`) -> DispatchQueue {
            return DispatchQueue(queue: dispatch_get_global_queue(Int(attributes.rawValue), 0))
        }
        
        public class func getSpecific<Value>(key: DispatchSpecificKey<Value>) -> Value? {
            let val = dispatch_get_specific(unsafeAddress(of: key))
            return val == .null ? nil : UnsafePointer<Value>(val).pointee
        }
        
        public func sync(execute workItem: DispatchWorkItem) {
            dispatch_sync(queue, workItem.block)
        }
        
        public func sync<T>(flags: DispatchWorkItemFlags = .`default`, execute work: () throws -> T) throws -> T {
            var e: ErrorProtocol? = nil
            var res: T? = nil
            sync(execute:DispatchWorkItem(group:nil, qos: .unspecified, flags: flags) {
                do {
                    res = try work()
                } catch {
                    e = error
                }
                })
            if let e = e {
                throw e
            }
            return res!
        }
        
        public func after(when: DispatchTime, execute: DispatchWorkItem) {
            dispatch_after(when.rawValue, queue, execute.block)
        }
        
        public func after(walltime when: DispatchWallTime, execute: DispatchWorkItem) {
            after(DispatchTime(rawValue: when.rawValue), execute: execute)
        }
        
        func after(when: DispatchTime, qos: DispatchQoS = .`default`, flags: DispatchWorkItemFlags = .`default`, execute work: () -> Void) {
            after(when, execute: DispatchWorkItem(group: nil, qos: qos, flags: flags, execute: work))
        }
        
        func after(walltime when: DispatchWallTime, qos: DispatchQoS = .`default`, flags: DispatchWorkItemFlags = .`default`, execute work: () -> Void) {
            after(DispatchTime(rawValue: when.rawValue), qos: qos, flags: flags, execute: work)
        }
        
        public func async(execute workItem: DispatchWorkItem) {
            dispatch_async(queue, workItem.block)
        }
        
        public func async(group: DispatchGroup? = nil, qos: DispatchQoS = .`default`, flags: DispatchWorkItemFlags = .`default`, execute work: @convention(block) () -> Swift.Void) {
            async(execute: DispatchWorkItem(group: group, qos: qos, flags: flags, execute: work))
        }
    }
#endif
