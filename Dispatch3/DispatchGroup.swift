//===--- DispatchGroup.swift ----------------------------------------------===//
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
    public class DispatchGroup : DispatchObject {
        
        var group: dispatch_group_t! {
            return object as! dispatch_group_t!
        }
        
        public init() {
            super.init(object: dispatch_group_create())
        }
        
    }
    
    extension DispatchGroup {
        
        public func notify(qos: DispatchQoS = .`default`, flags: DispatchWorkItemFlags = .`default`, queue: DispatchQueue, execute work: @convention(block) () -> ()) {
            notify(queue, work: DispatchWorkItem(group: self, qos: qos, flags: flags, execute: work))
        }
        
        public func notify(queue: DispatchQueue, work: DispatchWorkItem) {
            dispatch_group_notify(group, queue.queue, work.block)
        }
        
        public func wait(timeout: DispatchTime = .distantFuture) -> DispatchTimeoutResult {
            return dispatch_group_wait(group, timeout.rawValue) == 0 ? .Success : .TimedOut
        }
        
        public func wait(wallTimeout timeout: DispatchWallTime) -> DispatchTimeoutResult {
            return wait(DispatchTime(rawValue:timeout.rawValue))
        }
    }
    
    extension DispatchGroup {
        
        public func enter() {
            dispatch_group_enter(group)
        }
        
        public func leave() {
            dispatch_group_leave(group)
        }
    }
#endif
