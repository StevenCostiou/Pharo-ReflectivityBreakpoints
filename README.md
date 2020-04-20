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

```Smalltalk
watchVariableWrites: aVariableName in: aClass 
watchVariable: aVariableName in: aClass 
watchVariablesWritesIn: aClass 
watchVariablesIn: aClass 
watchVariablesReadsIn: aClass 
watchVariableReads: aVariableName in: aClass 
allSlotNamesFor: aClass 

```
