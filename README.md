CVCustomActionSheet
===================

A super-simple, customizable iOS 7 - styled ActionSheet.

![ss](https://raw.github.com/coultonvento/CVCustomActionSheet/master/ss.png)

Usage
===================

- Import “CVCustomActionSheet.h”
- Set CVCustomActionSheetDelegate
- Implement delegate methods.


```
- (void)actionSheetButtonClicked:(CVCustomActionSheet *)actionSheet withButtonIndex:(NSNumber *)buttonIndex withButtonTitle:(NSString *)buttonTitle;
- (void)actionSheetCancelled:(CVCustomActionSheet *)actionSheet;
```

- Init and present


```
CVCustomActionSheet *actionSheet = [[CVCustomActionSheet alloc] initWithDelegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Apples",@"Oranges",@"Bananas"]];
[actionSheet show];
```

Customization
===================

Check out CVCustomActionSheet.h, you can customize literally everything. 

- Custom Fonts
- Button background & text colors
- Line colors
- Button heights
