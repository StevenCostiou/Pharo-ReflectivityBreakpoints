# Pharo-ReflectivityBreakpoints
Improving Reflectivity breakpoints 

## Breakpoint Observer

Observers can register to the Breakpoint class using the `registerObserver:` and `unregisterObserver:` methods.

These observers will receive notifications objects holding the affected breakpoint and a collection of nodes on which it is installed or removed from.

Notifications are either a `BreakpointAddedNotification` or a `BreakpointRemovedNotification`.
