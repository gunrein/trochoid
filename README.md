Animate the construction of various [trochoids](http://en.wikipedia.org/wiki/Trochoid) for fun.

# Versions

* 0.1 - Initial version animating the construction of a constant hypotrochoid.

# Ideas

* Add user controls for the parameters of the hypotrochoid
* Show the guide and rolling circles plus the distance in the animation
* Show the parametric equations in the animation along with numeric (both radians and degrees) and a visual representation of theta
* Wrap the animation in a responsive shell with some explanations and links
* Add a cycloid
* Add a hypertrochoid

# Dependencies

* [Elm](http://elm-lang.org/) 0.8
    * If upgrading Elm, make sure to copy the latest version of `elm-runtime.js` to `lib/`.
* A modern web browser to view the animation.

# Development

Run `elm-server` in the `src/` directory and then view the pages in your browser.

# Building

Run `make` to build final files ready for static web publishing. The static files are found in `build/`.
