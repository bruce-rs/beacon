const kSmallScreenMaxWidth = 600.0;
const kMediumScreenMaxWidth = 840.0;
const kLargeScreenMaxWidth = 1200.0;

/// Width cap for modal sheets on large screens.
///
/// Deliberately its own value rather than a page constant: sheets are shown
/// above the navigator, so they never inherit a page's constraints and are free
/// to size independently of them.
const kBottomSheetMaxWidth = 840.0;
