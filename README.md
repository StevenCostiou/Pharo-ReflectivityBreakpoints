# Pharo-ReflectivityBreakpoints
Improving Reflectivity breakpoints with:
- a simple observer infrastructure to allow tools to monitor when breakpoints are added/removed
- a field watchpoint implementation
- an object-centric field watchpoint implementation

## Breakpoint Observer

Observers can register to the Breakpoint class using the `registerObserver:` and `unregisterObserver:` methods.

These observers will receive notifications objects holding the affected breakpoint and a collection of nodes on which it is installed or removed from.

Notifications are either a `BreakpointAddedNotification` or a `BreakpointRemovedNotification`.

To get all breakpoints present in the system: 
```Smalltalk
Breakpoint all
```

To know where a breakpoint is installed (for example here with the first one): 
```Smalltalk
Breakpoint all first node. "gets the AST node on which the breakpoint is installed"
Breakpoint all first node methodNode. "gets the method node in which the breakpoint is installed"
```
## Field Watchpoint

A `FieldWatchpoint` is a breakpoint that halts the execution when a field of an object is accessed.

It is implemented as a subclass of `BreakPoint`, therefore installation of field watchpoints is notified as a breakpoint change through the observer mechanics described above.

Breakpoints and field watchpoints responds to the `isWatchpoint` interface, which returns `true` for instances of `FieldWatchpoint` and `false` otherwise.


### Breaking on any instance variable access

Through the following API, you can configure a field watchpoint to break if any instance variable of instances of a class `aClass` is accessed (read, write, or both).

```Smalltalk
FieldWatchpoint>>watchVariablesIn: aClass 
FieldWatchpoint>>watchVariablesWritesIn: aClass 
FieldWatchpoint>>watchVariablesReadsIn: aClass 
```

### Breaking on a specific instance variable access

Through the following API, you can configure a field watchpoint to break if a specific instance variable named `aVariableName` of instances of a class `aClass` is accessed (read, write, or both).

```Smalltalk
FieldWatchpoint>>watchVariable: aVariableName in: aClass 
FieldWatchpoint>>watchVariableWrites: aVariableName in: aClass 
FieldWatchpoint>>watchVariableReads: aVariableName in: aClass 
```
