//===--- DispatchWorkItem.swift -------------------------------------------===//
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
    public struct DispatchWorkItemFlags : OptionSet, RawRepresentable {
        public let rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        public typealias Element = DispatchWorkItemFlags
        public typealias RawValue = UInt
        
        
        public static let barrier = DispatchWorkItemFlags(rawValue: DISPATCH_BLOCK_BARRIER.rawValue)
        public static let detached = DispatchWorkItemFlags(rawValue: DISPATCH_BLOCK_DETACHED.rawValue)
        public static let assignCurrentContext = DispatchWorkItemFlags(rawValue: DISPATCH_BLOCK_ASSIGN_CURRENT.rawValue)
        public static let noQoS = DispatchWorkItemFlags(rawValue: DISPATCH_BLOCK_NO_QOS_CLASS.rawValue)
        public static let inheritQoS = DispatchWorkItemFlags(rawValue: DISPATCH_BLOCK_INHERIT_QOS_CLASS.rawValue)
        public static let enforceQoS = DispatchWorkItemFlags(rawValue: DISPATCH_BLOCK_ENFORCE_QOS_CLASS.rawValue)
        public static let `default` = DispatchWorkItemFlags(rawValue: 0)
    }
    
    extension dispatch_block_flags_t {
        static func from(dispatchWorkItemFlags: DispatchWorkItemFlags) -> dispatch_block_flags_t {
            return dispatch_block_flags_t(rawValue: dispatchWorkItemFlags.rawValue)
        }
    }
    
    public class DispatchWorkItem {
        let block: dispatch_block_t
        let flags: DispatchWorkItemFlags
        let group: DispatchGroup?
        
        public init(group: DispatchGroup? = nil,
                    qos: DispatchQoS = .unspecified,
                    flags: DispatchWorkItemFlags = [],
                    execute: () -> ()) {
            self.flags = flags
            self.group = group
            self.block = dispatch_block_create_with_qos_class(dispatch_block_flags_t.from(flags), dispatch_qos_class_t.from(dispatchQoS: qos), Int32(qos.relativePriority), execute)
        }
        
        public func perform() {
            dispatch_block_perform(dispatch_block_flags_t.from(flags), block)
        }
        
        public func wait(timeout: DispatchTime = .distantFuture) -> DispatchTimeoutResult {
            return dispatch_block_wait(block, timeout.rawValue) == 0 ? .Success : .TimedOut
        }
        
        public func wait(wallTimeout: DispatchWallTime) -> DispatchTimeoutResult {
            return dispatch_block_wait(block, wallTimeout.rawValue) == 0 ? .Success : .TimedOut
        }
        
        public func notify(qos: DispatchQoS = .`default`, flags: DispatchWorkItemFlags = .`default`, queue: DispatchQueue, execute: () -> Void) {
            notify(queue, execute: DispatchWorkItem(group: group, qos: qos, flags: flags, execute: execute))
        }
        
        public func notify(queue: DispatchQueue, execute: DispatchWorkItem) {
            dispatch_block_notify(block, queue.queue, execute.block)
        }
        
        public func cancel() {
            dispatch_block_cancel(self.block)
        }
        
        public var isCancelled: Bool {
            return dispatch_block_testcancel(self.block) != 0
        }
    }
#endif
