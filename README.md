# Trello Card Slider UI
A Flutter application that mimics a Trello-like card slider with drag-and-drop functionality across multiple lists. This UI supports automatic horizontal scrolling when cards are dragged close to the edges, simulating an infinite canvas experience. Additionally, cards are given a tilted effect when being dragged for enhanced visual feedback.

# Features
Card Slider with Drag-and-Drop: Move cards between lists by dragging and dropping.
Auto Horizontal Scrolling: When a card is dragged near the left or right edge, the UI automatically scrolls in that direction, stopping when the card is centered.
Tilt Effect on Drag: Cards tilt slightly to the right during drag, making the interaction more dynamic.
Customizable Lists: Multiple lists (investment categories) with animated item addition and removal.
Fade-Out Effect: Cards fade out in their original position when being dragged to another list.

# Project Structure
main.dart: The main file, containing the UserDashboard widget and card slider logic.
CardContent class: Defines the data model for the cards.
buildDragTarget(): Generates lists for each category, allowing drag-and-drop functionality.
autoScrollOnDrag(): Implements auto-scrolling when a card is dragged to the screen edges.
_buildAnimatedItem(): Manages the animation of cards with tilt and fade effects.

# Customization
You can easily modify the following parameters in main.dart:

Scroll Speed: Adjust the scrollSpeed variable in autoScrollOnDrag() for faster or slower auto-scrolling.
Tilt Angle: Change the rotation angle in Matrix4.rotationZ() for a more or less pronounced tilt on drag.
Fade Opacity: Update the opacity value in childWhenDragging to control how transparent the card becomes while dragging.

# Dependencies
Flutter (>=2.0.0)
Google Fonts - For custom font styling.
Font Awesome Flutter - For additional icons.

# Usage
The app is designed to simulate a Trello-style card management UI where users can drag items from one list to another with animated feedback. This UI is suitable for applications involving task management, item categorization, and investment tracking.

# Contributions
Feel free to contribute by submitting issues, feature requests, or pull requests. For significant contributions, please open an issue first to discuss the changes you wish to make.
