###*
  @fileoverview Polymer PointerEvents polyfill incorporated into Este.
  @see http://www.polymer-project.org/platform/pointer-events.html
###
goog.provide 'este.thirdParty.pointerEvents'

goog.require 'goog.userAgent'

###*
  @return {boolean}
###
este.thirdParty.pointerEvents.isSupported = ->
  !goog.userAgent.IE || goog.userAgent.isVersionOrHigher 10

###*
  @type {boolean}
  @private
###
este.thirdParty.pointerEvents.installed_ = false

este.thirdParty.pointerEvents.install = ->
  return if !este.thirdParty.pointerEvents.isSupported()
  return if este.thirdParty.pointerEvents.installed_
  este.thirdParty.pointerEvents.installed_ = true
  goog.globalEval "// Copyright (c) 2013 The Polymer Authors. All rights reserved.\n//\n// Redistribution and use in source and binary forms, with or without\n// modification, are permitted provided that the following conditions are\n// met:\n//\n//    * Redistributions of source code must retain the above copyright\n// notice, this list of conditions and the following disclaimer.\n//    * Redistributions in binary form must reproduce the above\n// copyright notice, this list of conditions and the following disclaimer\n// in the documentation and/or other materials provided with the\n// distribution.\n//    * Neither the name of Google Inc. nor the names of its\n// contributors may be used to endorse or promote products derived from\n// this software without specific prior written permission.\n//\n// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\n// \"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\n// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\n// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT\n// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,\n// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT\n// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,\n// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY\n// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT\n// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE\n// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n\"undefined\"==typeof WeakMap&&!function(){var a=Object.defineProperty,b=Date.now()%1e9,c=function(){this.name=\"__st\"+(1e9*Math.random()>>>0)+(b++ +\"__\")};c.prototype={set:function(b,c){var d=b[this.name];d&&d[0]===b?d[1]=c:a(b,this.name,{value:[b,c],writable:!0})},get:function(a){var b;return(b=a[this.name])&&b[0]===a?b[1]:void 0},\"delete\":function(a){this.set(a,void 0)}},window.WeakMap=c}(),function(a){a=a||{},a.external=a.external||{};var b={shadow:function(a){return a?a.shadowRoot||a.webkitShadowRoot:void 0},canTarget:function(a){return a&&Boolean(a.elementFromPoint)},targetingShadow:function(a){var b=this.shadow(a);return this.canTarget(b)?b:void 0},olderShadow:function(a){var b=a.olderShadowRoot;if(!b){var c=a.querySelector(\"shadow\");c&&(b=c.olderShadowRoot)}return b},allShadows:function(a){for(var b=[],c=this.shadow(a);c;)b.push(c),c=this.olderShadow(c);return b},searchRoot:function(a,b,c){if(a){var d,e,f=a.elementFromPoint(b,c);for(e=this.targetingShadow(f);e;){if(d=e.elementFromPoint(b,c)){var g=this.targetingShadow(d);return this.searchRoot(g,b,c)||d}e=this.olderShadow(e)}return f}},owner:function(a){for(var b=a;b.parentNode;)b=b.parentNode;return b},findTarget:function(a){var b=a.clientX,c=a.clientY,d=this.owner(a.target);return d.elementFromPoint(b,c)||(d=document),this.searchRoot(d,b,c)}};a.targetFinding=b,a.findTarget=b.findTarget.bind(b),window.PointerEventsPolyfill=a}(window.PointerEventsPolyfill),function(){function a(a){return'[touch-action=\"'+a+'\"]'}function b(a){return\"{ -ms-touch-action: \"+a+\"; touch-action: \"+a+\"; touch-action-delay: none; }\"}var c=[\"none\",\"auto\",\"pan-x\",\"pan-y\",{rule:\"pan-x pan-y\",selectors:[\"pan-x pan-y\",\"pan-y pan-x\"]}],d=\"\";c.forEach(function(c){d+=String(c)===c?a(c)+b(c):c.selectors.map(a)+b(c.rule)});var e=document.createElement(\"style\");e.textContent=d,document.head.appendChild(e)}(),function(a){function b(a,e){e=e||{};var f=e.buttons;if(void 0===f)switch(e.which){case 1:f=1;break;case 2:f=4;break;case 3:f=2;break;default:f=0}var i;if(c)i=new MouseEvent(a,e);else{i=document.createEvent(\"MouseEvent\");for(var j,k={},l=0;l<g.length;l++)j=g[l],k[j]=e[j]||h[l];i.initMouseEvent(a,k.bubbles,k.cancelable,k.view,k.detail,k.screenX,k.screenY,k.clientX,k.clientY,k.ctrlKey,k.altKey,k.shiftKey,k.metaKey,k.button,k.relatedTarget)}i.__proto__=b.prototype,d||Object.defineProperty(i,\"buttons\",{get:function(){return f},enumerable:!0});var m=0;return m=e.pressure?e.pressure:f?.5:0,Object.defineProperties(i,{pointerId:{value:e.pointerId||0,enumerable:!0},width:{value:e.width||0,enumerable:!0},height:{value:e.height||0,enumerable:!0},pressure:{value:m,enumerable:!0},tiltX:{value:e.tiltX||0,enumerable:!0},tiltY:{value:e.tiltY||0,enumerable:!0},pointerType:{value:e.pointerType||\"\",enumerable:!0},hwTimestamp:{value:e.hwTimestamp||0,enumerable:!0},isPrimary:{value:e.isPrimary||!1,enumerable:!0}}),i}var c=!1,d=!1;try{var e=new MouseEvent(\"click\",{buttons:1});c=!0,d=1===e.buttons}catch(f){}var g=[\"bubbles\",\"cancelable\",\"view\",\"detail\",\"screenX\",\"screenY\",\"clientX\",\"clientY\",\"ctrlKey\",\"altKey\",\"shiftKey\",\"metaKey\",\"button\",\"relatedTarget\"],h=[!1,!1,null,null,0,0,0,0,!1,!1,!1,!1,0,null];b.prototype=Object.create(MouseEvent.prototype),a.PointerEvent||(a.PointerEvent=b)}(window),function(a){function b(){if(c){var a=new Map;return a.pointers=d,a}this.keys=[],this.values=[]}var c=window.Map&&window.Map.prototype.forEach,d=function(){return this.size};b.prototype={set:function(a,b){var c=this.keys.indexOf(a);c>-1?this.values[c]=b:(this.keys.push(a),this.values.push(b))},has:function(a){return this.keys.indexOf(a)>-1},\"delete\":function(a){var b=this.keys.indexOf(a);b>-1&&(this.keys.splice(b,1),this.values.splice(b,1))},get:function(a){var b=this.keys.indexOf(a);return this.values[b]},clear:function(){this.keys.length=0,this.values.length=0},forEach:function(a,b){this.keys.forEach(function(c,d){a.call(b,c,this.values[d],this)},this)},pointers:function(){return this.keys.length}},a.PointerMap=b}(window.PointerEventsPolyfill),function(a){var b=[\"bubbles\",\"cancelable\",\"view\",\"detail\",\"screenX\",\"screenY\",\"clientX\",\"clientY\",\"ctrlKey\",\"altKey\",\"shiftKey\",\"metaKey\",\"button\",\"relatedTarget\",\"buttons\",\"pointerId\",\"width\",\"height\",\"pressure\",\"tiltX\",\"tiltY\",\"pointerType\",\"hwTimestamp\",\"isPrimary\",\"type\",\"target\",\"currentTarget\",\"which\"],c=[!1,!1,null,null,0,0,0,0,!1,!1,!1,!1,0,null,void 0,0,0,0,0,0,0,\"\",0,!1,\"\",null,null,0],d={targets:new WeakMap,handledEvents:new WeakMap,pointermap:new a.PointerMap,eventMap:{},eventSources:{},eventSourceList:[],registerSource:function(a,b){var c=b,d=c.events;d&&(d.forEach(function(a){c[a]&&(this.eventMap[a]=c[a].bind(c))},this),this.eventSources[a]=c,this.eventSourceList.push(c))},register:function(a){for(var b,c=this.eventSourceList.length,d=0;c>d&&(b=this.eventSourceList[d]);d++)b.register.call(b,a)},unregister:function(a){for(var b,c=this.eventSourceList.length,d=0;c>d&&(b=this.eventSourceList[d]);d++)b.unregister.call(b,a)},contains:a.external.contains||function(a,b){return a.contains(b)},down:function(a){this.fireEvent(\"pointerdown\",a)},move:function(a){this.fireEvent(\"pointermove\",a)},up:function(a){this.fireEvent(\"pointerup\",a)},enter:function(a){a.bubbles=!1,this.fireEvent(\"pointerenter\",a)},leave:function(a){a.bubbles=!1,this.fireEvent(\"pointerleave\",a)},over:function(a){a.bubbles=!0,this.fireEvent(\"pointerover\",a)},out:function(a){a.bubbles=!0,this.fireEvent(\"pointerout\",a)},cancel:function(a){this.fireEvent(\"pointercancel\",a)},leaveOut:function(a){this.contains(a.target,a.relatedTarget)||this.leave(a),this.out(a)},enterOver:function(a){this.contains(a.target,a.relatedTarget)||this.enter(a),this.over(a)},eventHandler:function(a){if(!this.handledEvents.get(a)){var b=a.type,c=this.eventMap&&this.eventMap[b];c&&c(a),this.handledEvents.set(a,!0)}},listen:function(a,b){b.forEach(function(b){this.addEvent(a,b)},this)},unlisten:function(a,b){b.forEach(function(b){this.removeEvent(a,b)},this)},addEvent:a.external.addEvent||function(a,b){a.addEventListener(b,this.boundHandler)},removeEvent:a.external.removeEvent||function(a,b){a.removeEventListener(b,this.boundHandler)},makeEvent:function(a,b){this.captureInfo&&(b.relatedTarget=null);var c=new PointerEvent(a,b);return b.preventDefault&&(c.preventDefault=b.preventDefault),this.targets.set(c,this.targets.get(b)||b.target),c},fireEvent:function(a,b){var c=this.makeEvent(a,b);return this.dispatchEvent(c)},cloneEvent:function(a){for(var d,e={},f=0;f<b.length;f++)d=b[f],e[d]=a[d]||c[f];return a.preventDefault&&(e.preventDefault=function(){a.preventDefault()}),e},getTarget:function(a){return this.captureInfo&&this.captureInfo.id===a.pointerId?this.captureInfo.target:this.targets.get(a)},setCapture:function(a,b){this.captureInfo&&this.releaseCapture(this.captureInfo.id),this.captureInfo={id:a,target:b};var c=new PointerEvent(\"gotpointercapture\",{bubbles:!0});this.implicitRelease=this.releaseCapture.bind(this,a),document.addEventListener(\"pointerup\",this.implicitRelease),document.addEventListener(\"pointercancel\",this.implicitRelease),this.targets.set(c,b),this.asyncDispatchEvent(c)},releaseCapture:function(a){if(this.captureInfo&&this.captureInfo.id===a){var b=new PointerEvent(\"lostpointercapture\",{bubbles:!0}),c=this.captureInfo.target;this.captureInfo=null,document.removeEventListener(\"pointerup\",this.implicitRelease),document.removeEventListener(\"pointercancel\",this.implicitRelease),this.targets.set(b,c),this.asyncDispatchEvent(b)}},dispatchEvent:a.external.dispatchEvent||function(a){var b=this.getTarget(a);return b?b.dispatchEvent(a):void 0},asyncDispatchEvent:function(a){setTimeout(this.dispatchEvent.bind(this,a),0)}};d.boundHandler=d.eventHandler.bind(d),a.dispatcher=d,a.register=d.register.bind(d),a.unregister=d.unregister.bind(d)}(window.PointerEventsPolyfill),function(a){function b(a,b,c,d){this.addCallback=a.bind(d),this.removeCallback=b.bind(d),this.changedCallback=c.bind(d),g&&(this.observer=new g(this.mutationWatcher.bind(this)))}var c=Array.prototype.forEach.call.bind(Array.prototype.forEach),d=Array.prototype.map.call.bind(Array.prototype.map),e=Array.prototype.slice.call.bind(Array.prototype.slice),f=Array.prototype.filter.call.bind(Array.prototype.filter),g=window.MutationObserver||window.WebKitMutationObserver,h=\"[touch-action]\",i={subtree:!0,childList:!0,attributes:!0,attributeOldValue:!0,attributeFilter:[\"touch-action\"]};b.prototype={watchSubtree:function(b){a.targetFinding.canTarget(b)&&this.observer.observe(b,i)},enableOnSubtree:function(a){this.watchSubtree(a),a===document&&\"complete\"!==document.readyState?this.installOnLoad():this.installNewSubtree(a)},installNewSubtree:function(a){c(this.findElements(a),this.addElement,this)},findElements:function(a){return a.querySelectorAll?a.querySelectorAll(h):[]},removeElement:function(a){this.removeCallback(a)},addElement:function(a){this.addCallback(a)},elementChanged:function(a,b){this.changedCallback(a,b)},concatLists:function(a,b){return a.concat(e(b))},installOnLoad:function(){document.addEventListener(\"DOMContentLoaded\",this.installNewSubtree.bind(this,document))},isElement:function(a){return a.nodeType===Node.ELEMENT_NODE},flattenMutationTree:function(a){var b=d(a,this.findElements,this);return b.push(f(a,this.isElement)),b.reduce(this.concatLists,[])},mutationWatcher:function(a){a.forEach(this.mutationHandler,this)},mutationHandler:function(a){if(\"childList\"===a.type){var b=this.flattenMutationTree(a.addedNodes);b.forEach(this.addElement,this);var c=this.flattenMutationTree(a.removedNodes);c.forEach(this.removeElement,this)}else\"attributes\"===a.type&&this.elementChanged(a.target,a.oldValue)}},g||(b.prototype.watchSubtree=function(){console.warn(\"PointerEventsPolyfill: MutationObservers not found, touch-action will not be dynamically detected\")}),a.Installer=b}(window.PointerEventsPolyfill),function(a){var b=a.dispatcher,c=b.pointermap,d=25,e={POINTER_ID:1,POINTER_TYPE:\"mouse\",events:[\"mousedown\",\"mousemove\",\"mouseup\",\"mouseover\",\"mouseout\"],register:function(a){b.listen(a,this.events)},unregister:function(a){b.unlisten(a,this.events)},lastTouches:[],isEventSimulatedFromTouch:function(a){for(var b,c=this.lastTouches,e=a.clientX,f=a.clientY,g=0,h=c.length;h>g&&(b=c[g]);g++){var i=Math.abs(e-b.x),j=Math.abs(f-b.y);if(d>=i&&d>=j)return!0}},prepareEvent:function(a){var c=b.cloneEvent(a),d=c.preventDefault;return c.preventDefault=function(){a.preventDefault(),d()},c.pointerId=this.POINTER_ID,c.isPrimary=!0,c.pointerType=this.POINTER_TYPE,c},mousedown:function(a){if(!this.isEventSimulatedFromTouch(a)){var d=c.has(this.POINTER_ID);d&&this.cancel(a);var e=this.prepareEvent(a);c.set(this.POINTER_ID,a),b.down(e)}},mousemove:function(a){if(!this.isEventSimulatedFromTouch(a)){var c=this.prepareEvent(a);b.move(c)}},mouseup:function(a){if(!this.isEventSimulatedFromTouch(a)){var d=c.get(this.POINTER_ID);if(d&&d.button===a.button){var e=this.prepareEvent(a);b.up(e),this.cleanupMouse()}}},mouseover:function(a){if(!this.isEventSimulatedFromTouch(a)){var c=this.prepareEvent(a);b.enterOver(c)}},mouseout:function(a){if(!this.isEventSimulatedFromTouch(a)){var c=this.prepareEvent(a);b.leaveOut(c)}},cancel:function(a){var c=this.prepareEvent(a);b.cancel(c),this.cleanupMouse()},cleanupMouse:function(){c[\"delete\"](this.POINTER_ID)}};a.mouseEvents=e}(window.PointerEventsPolyfill),function(a){var b,c=a.dispatcher,d=a.findTarget,e=a.targetFinding.allShadows.bind(a.targetFinding),f=c.pointermap,g=Array.prototype.map.call.bind(Array.prototype.map),h=2500,i=200,j=\"touch-action\",k=\"string\"==typeof document.head.style.touchAction,l={scrollType:new WeakMap,events:[\"touchstart\",\"touchmove\",\"touchend\",\"touchcancel\"],register:function(a){k?c.listen(a,this.events):b.enableOnSubtree(a)},unregister:function(a){k&&c.unlisten(a,this.events)},elementAdded:function(a){var b=a.getAttribute(j),d=this.touchActionToScrollType(b);d&&(this.scrollType.set(a,d),c.listen(a,this.events),e(a).forEach(function(a){this.scrollType.set(a,d),c.listen(a,this.events)},this))},elementRemoved:function(a){this.scrollType[\"delete\"](a),c.unlisten(a,this.events),e(a).forEach(function(a){this.scrollType[\"delete\"](a),c.unlisten(a,this.events)},this)},elementChanged:function(a,b){var c=a.getAttribute(j),d=this.touchActionToScrollType(c),f=this.touchActionToScrollType(b);d&&f?(this.scrollType.set(a,d),e(a).forEach(function(a){this.scrollType.set(a,d)},this)):f?this.elementRemoved(a):d&&this.elementAdded(a)},scrollTypes:{EMITTER:\"none\",XSCROLLER:\"pan-x\",YSCROLLER:\"pan-y\",SCROLLER:/^(?:pan-x pan-y)|(?:pan-y pan-x)|auto$/},touchActionToScrollType:function(a){var b=a,c=this.scrollTypes;return\"none\"===b?\"none\":b===c.XSCROLLER?\"X\":b===c.YSCROLLER?\"Y\":c.SCROLLER.exec(b)?\"XY\":void 0},POINTER_TYPE:\"touch\",firstTouch:null,isPrimaryTouch:function(a){return this.firstTouch===a.identifier},setPrimaryTouch:function(a){(0===f.pointers()||1===f.pointers()&&f.has(1))&&(this.firstTouch=a.identifier,this.firstXY={X:a.clientX,Y:a.clientY},this.scrolling=!1,this.cancelResetClickCount())},removePrimaryPointer:function(a){a.isPrimary&&(this.firstTouch=null,this.firstXY=null,this.resetClickCount())},clickCount:0,resetId:null,resetClickCount:function(){var a=function(){this.clickCount=0,this.resetId=null}.bind(this);this.resetId=setTimeout(a,i)},cancelResetClickCount:function(){this.resetId&&clearTimeout(this.resetId)},touchToPointer:function(a){var b=c.cloneEvent(a);return b.pointerId=a.identifier+2,b.target=d(b),b.bubbles=!0,b.cancelable=!0,b.detail=this.clickCount,b.button=0,b.buttons=1,b.width=a.webkitRadiusX||a.radiusX||0,b.height=a.webkitRadiusY||a.radiusY||0,b.pressure=a.webkitForce||a.force||.5,b.isPrimary=this.isPrimaryTouch(a),b.pointerType=this.POINTER_TYPE,b},processTouches:function(a,b){var c=a.changedTouches,d=g(c,this.touchToPointer,this);d.forEach(function(b){b.preventDefault=function(){this.scrolling=!1,this.firstXY=null,a.preventDefault()}},this),d.forEach(b,this)},shouldScroll:function(a){if(this.firstXY){var b,c=this.scrollType.get(a.currentTarget);if(\"none\"===c)b=!1;else if(\"XY\"===c)b=!0;else{var d=a.changedTouches[0],e=c,f=\"Y\"===c?\"X\":\"Y\",g=Math.abs(d[\"client\"+e]-this.firstXY[e]),h=Math.abs(d[\"client\"+f]-this.firstXY[f]);b=g>=h}return this.firstXY=null,b}},findTouch:function(a,b){for(var c,d=0,e=a.length;e>d&&(c=a[d]);d++)if(c.identifier===b)return!0},vacuumTouches:function(a){var b=a.touches;if(f.pointers()>=b.length){var c=[];f.forEach(function(a,d){if(1!==a&&!this.findTouch(b,a-2)){var e=d.out;c.push(this.touchToPointer(e))}},this),c.forEach(this.cancelOut,this)}},touchstart:function(a){this.vacuumTouches(a),this.setPrimaryTouch(a.changedTouches[0]),this.dedupSynthMouse(a),this.scrolling||(this.clickCount++,this.processTouches(a,this.overDown))},overDown:function(a){f.set(a.pointerId,{target:a.target,out:a,outTarget:a.target}),c.over(a),c.down(a)},touchmove:function(a){this.scrolling||(this.shouldScroll(a)?(this.scrolling=!0,this.touchcancel(a)):(a.preventDefault(),this.processTouches(a,this.moveOverOut)))},moveOverOut:function(a){var b=a,d=f.get(b.pointerId);if(d){var e=d.out,g=d.outTarget;c.move(b),e&&g!==b.target&&(e.relatedTarget=b.target,b.relatedTarget=g,e.target=g,b.target?(c.leaveOut(e),c.enterOver(b)):(b.target=g,b.relatedTarget=null,this.cancelOut(b))),d.out=b,d.outTarget=b.target}},touchend:function(a){this.dedupSynthMouse(a),this.processTouches(a,this.upOut)},upOut:function(a){this.scrolling||(c.up(a),c.out(a)),this.cleanUpPointer(a)},touchcancel:function(a){this.processTouches(a,this.cancelOut)},cancelOut:function(a){c.cancel(a),c.out(a),this.cleanUpPointer(a)},cleanUpPointer:function(a){f[\"delete\"](a.pointerId),this.removePrimaryPointer(a)},dedupSynthMouse:function(b){var c=a.mouseEvents.lastTouches,d=b.changedTouches[0];if(this.isPrimaryTouch(d)){var e={x:d.clientX,y:d.clientY};c.push(e);var f=function(a,b){var c=a.indexOf(b);c>-1&&a.splice(c,1)}.bind(null,c,e);setTimeout(f,h)}}};k||(b=new a.Installer(l.elementAdded,l.elementRemoved,l.elementChanged,l)),a.touchEvents=l}(window.PointerEventsPolyfill),function(a){var b=a.dispatcher,c=b.pointermap,d=window.MSPointerEvent&&\"number\"==typeof window.MSPointerEvent.MSPOINTER_TYPE_MOUSE,e={events:[\"MSPointerDown\",\"MSPointerMove\",\"MSPointerUp\",\"MSPointerOut\",\"MSPointerOver\",\"MSPointerCancel\",\"MSGotPointerCapture\",\"MSLostPointerCapture\"],register:function(a){b.listen(a,this.events)},unregister:function(a){b.unlisten(a,this.events)},POINTER_TYPES:[\"\",\"unavailable\",\"touch\",\"pen\",\"mouse\"],prepareEvent:function(a){var c=a;return d&&(c=b.cloneEvent(a),c.pointerType=this.POINTER_TYPES[a.pointerType]),c},cleanup:function(a){c[\"delete\"](a)},MSPointerDown:function(a){c.set(a.pointerId,a);var d=this.prepareEvent(a);b.down(d)},MSPointerMove:function(a){var c=this.prepareEvent(a);b.move(c)},MSPointerUp:function(a){var c=this.prepareEvent(a);b.up(c),this.cleanup(a.pointerId)},MSPointerOut:function(a){var c=this.prepareEvent(a);b.leaveOut(c)},MSPointerOver:function(a){var c=this.prepareEvent(a);b.enterOver(c)},MSPointerCancel:function(a){var c=this.prepareEvent(a);b.cancel(c),this.cleanup(a.pointerId)},MSLostPointerCapture:function(a){var c=b.makeEvent(\"lostpointercapture\",a);b.dispatchEvent(c)},MSGotPointerCapture:function(a){var c=b.makeEvent(\"gotpointercapture\",a);b.dispatchEvent(c)}};a.msEvents=e}(window.PointerEventsPolyfill),function(a){var b=a.dispatcher;if(void 0===window.navigator.pointerEnabled){if(Object.defineProperty(window.navigator,\"pointerEnabled\",{value:!0,enumerable:!0}),window.navigator.msPointerEnabled){var c=window.navigator.msMaxTouchPoints;Object.defineProperty(window.navigator,\"maxTouchPoints\",{value:c,enumerable:!0}),b.registerSource(\"ms\",a.msEvents)}else b.registerSource(\"mouse\",a.mouseEvents),void 0!==window.ontouchstart&&b.registerSource(\"touch\",a.touchEvents);b.register(document)}}(window.PointerEventsPolyfill),function(a){function b(a){if(!e.pointermap.has(a))throw new Error(\"InvalidPointerId\")}var c,d,e=a.dispatcher,f=window.navigator;f.msPointerEnabled?(c=function(a){b(a),this.msSetPointerCapture(a)},d=function(a){b(a),this.msReleasePointerCapture(a)}):(c=function(a){b(a),e.setCapture(a,this)},d=function(a){b(a),e.releaseCapture(a,this)}),window.Element&&!Element.prototype.setPointerCapture&&Object.defineProperties(Element.prototype,{setPointerCapture:{value:c},releasePointerCapture:{value:d}})}(window.PointerEventsPolyfill);"

# Hint for compiler dead code removal, it prevents src duplication.
# grunt build --stage // should be around 8.6KB.
goog.globalEval ';'