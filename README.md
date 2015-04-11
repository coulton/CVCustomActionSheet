CVCustomActionSheet
===================

A super-simple, customizable iOS 8 - styled ActionSheet... Now with blocks!

Usage
===================

1. Import “CVCustomActionSheet.h”
2. Init
```
CVCustomActionSheet *actionSheet = [[CVCustomActionSheet alloc] init];
```
3. Add actions

```
[actionSheet addAction:[CVCustomAction actionWithTitle:@"Option"
                                                  type:CVCustomActionTypeDefault
                                               handler:nil]];

[actionSheet addAction:[CVCustomAction actionWithTitle:@"Cancel"
                                                  type:CVCustomActionTypeCancel
                                               handler:nil]];
```
4. And present!
```
[actionSheet show];
```

Customization
===================

Check out CVCustomActionSheetButtonConfiguration.h, you can customize literally everything. 
