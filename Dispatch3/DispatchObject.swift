//===--- DispatchObject.swift ---------------------------------------------===//
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

#if swift(>=3.0) && !os(Linux)
#else
    public class DispatchObject {
        let object: dispatch_object_t!
        
        init(object: dispatch_object_t!) {
            self.object = object
        }
        
        /*!
         * @function dispatch_activate
         *
         * @abstract
         * Activates the specified dispatch object.
         *
         * @discussion
         * Dispatch objects such as queues and sources may be created in an inactive
         * state. Objects in this state have to be activated before any blocks
         * associated with them will be invoked.
         *
         * The target queue of inactive objects can be changed using
         * dispatch_set_target_queue(). Change of target queue is no longer permitted
         * once an initially inactive object has been activated.
         *
         * Calling dispatch_activate() on an active object has no effect.
         * Releasing the last reference count on an inactive object is undefined.
         *
         * @param object
         * The object to be activated.
         * The result of passing NULL in this parameter is undefined.
         */
        public func activate() {
            // Do nothing. Only in 10.12
        }
        
        
        /*!
         * @function dispatch_suspend
         *
         * @abstract
         * Suspends the invocation of blocks on a dispatch object.
         *
         * @discussion
         * A suspended object will not invoke any blocks associated with it. The
         * suspension of an object will occur after any running block associated with
         * the object completes.
         *
         * Calls to dispatch_suspend() must be balanced with calls
         * to dispatch_resume().
         *
         * @param object
         * The object to be suspended.
         * The result of passing NULL in this parameter is undefined.
         */
        public func suspend() {
            dispatch_suspend(object)
        }
        
        
        /*!
         * @function dispatch_resume
         *
         * @abstract
         * Resumes the invocation of blocks on a dispatch object.
         *
         * @discussion
         * Dispatch objects can be suspended with dispatch_suspend(), which increments
         * an internal suspension count. dispatch_resume() is the inverse operation,
         * and consumes suspension counts. When the last suspension count is consumed,
         * blocks associated with the object will be invoked again.
         *
         * For backward compatibility reasons, dispatch_resume() on an inactive and not
         * otherwise suspended dispatch source object has the same effect as calling
         * dispatch_activate(). For new code, using dispatch_activate() is preferred.
         *
         * If the specified object has zero suspension count and is not an inactive
         * source, this function will result in an assertion and the process being
         * terminated.
         *
         * @param object
         * The object to be resumed.
         * The result of passing NULL in this parameter is undefined.
         */
        public func resume() {
            dispatch_resume(object)
        }
    }
#endif
