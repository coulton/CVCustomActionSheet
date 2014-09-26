CVCustomActionSheet
===================

A super-simple, customizable iOS 8 - styled ActionSheet... Now with blocks!

![ss](https://raw.github.com/coultonvento/CVCustomActionSheet/master/ss.png)

Usage
===================

- Import “CVCustomActionSheet.h”
- Init and present


```
CVCustomActionSheet *actionSheet = [[CVCustomActionSheet alloc] initWithOptions:@[@"Apples", @"Oranges", @"Bananas"] andCancelButtonTitle:@"Cancel"];
[actionSheet show:^{} cancelPressed:^{} optionPressed:^(NSInteger buttonIndex, NSString *buttonTitle) { }];
```

Customization
===================

Check out CVCustomActionSheet.h, you can customize literally everything. 

- Custom Fonts
- Button background & text colors
- Line colors
- Button heights
