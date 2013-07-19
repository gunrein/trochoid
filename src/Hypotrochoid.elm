module Hypotrochoid where

import Window

{--
  Game template from
  https://github.com/evancz/elm-lang.org/blob/master/public/examples/Intermediate/GameSkeleton.elm
--}

{-- Part 1: Model the user input ----------------------------------------------

What information do you need to represent all relevant user input?

These parameters control the animation and hypotrochoid shape. A future
version will provide ways to change them in a UI.

------------------------------------------------------------------------------}

type UserInput = { maxSize : Float -- Maximum size of the hypotrochoid drawing
                 , guideR : Float -- Guide circle radius
                 , rollerR : Float -- Roller circle radius
                 , distance : Float -- Distance from roller circle center to drawing point
                 , thetaSize : Float -- Resolution at which to draw the hypotrochoid
                 , speed : Float -- Speed at which to draw the hypotrochoid
                 , lineColor : Color -- Color of the line to draw
                 }

-- Default parameter values
parameters = { maxSize = 1.97 * pi
             , guideR = 60
             , rollerR = 6
             , distance = 30
             , thetaSize = pi / 180.0
             , speed = pi / 1800.0
             , lineColor = red
             }

userInput : Signal UserInput
userInput = constant parameters

data Input = Input Float UserInput

{-- Part 2: Model the game ----------------------------------------------------

What information do you need to represent the entire game?

The game's state is defined by two angles representing the arcs covered by the
shape as well as the user input and the path of the curve itself.
angles:

* `size` - the length of the arc through which the hypotrochoid is drawn
* `offset` - the offset angle from which to start drawing the hypotrochoid
* `userInput` - the parameters set by the user
* 'curvePath` - the path that the curve follows for the current state of the animation

------------------------------------------------------------------------------}

type CircleSegment = { size  : Float -- The size of the segment as an angle in radians
                     , offset : Float -- The rotation of the segment as an angle in radians
                     }

type GameState = { segment : CircleSegment
                 , curvePath : [(Float, Float)]
                 , userInput : UserInput
                 }

defaultGame : GameState
defaultGame = { segment = { offset = 0.0, size = 0.0 }
              , curvePath = []
              , userInput = parameters
              }

{-- Part 3: Update the game ---------------------------------------------------

How does the game step from one state to another based on user input?

Updates `size`, `offset`, `curvePath`, and `userInput`.

------------------------------------------------------------------------------}

stepGame : Input -> GameState -> GameState
stepGame (Input delta userInput) gameState =
  let size = gameState.segment.size
      offset = gameState.segment.offset
      totalDelta = delta * userInput.speed
      atMaxSize = size >= userInput.maxSize
      -- The function for calculating the point positions on the curve for this
      -- frame of the animation.
      posEq = posEquation userInput.guideR userInput.rollerR userInput.distance
      -- Generate all of the angles for the curve for this frame.
      genThetas = generateThetas size offset userInput.thetaSize
      -- Calculate the path for the curve.
      curvePath = map posEq genThetas
  in
    { segment = { 
                  -- Increments `offset` as long as `size` has reached its maximum.
                  -- This keeps the hypotrochoid from appearing to rotate until it
                  -- has reached its maximum size.
                  offset = if atMaxSize then offset + totalDelta else offset
                  -- Increments `size` until `size` reaches its maximum. This keeps
                  -- the beginning and end of the hypotrochoid from overlapping.
                , size = if not atMaxSize then size + totalDelta else size 
                }
    , curvePath = curvePath 
    , userInput = userInput
    }

-- Generate all of the angles for this frame
generateThetas : Float -> Float -> Float -> List
generateThetas size offset thetaSize = 
  let numAngles = ceiling (size / thetaSize)
  in map (\x -> offset + toFloat x * thetaSize) [0..numAngles]

-- Calculate a single point on the shape for the given parameters
posEquation guideRadius rollingRadius d theta =
  let
    radiusDiff = guideRadius - rollingRadius
    thetaRatio = (radiusDiff / rollingRadius) * theta
  in
    ( radiusDiff * (cos theta) + d * (cos thetaRatio)
    , radiusDiff * (sin theta) - d * (sin thetaRatio)
    )

{-- Part 4: Display the game --------------------------------------------------

How should the GameState be displayed to the user?

Draw the path of the curve.

------------------------------------------------------------------------------}

-- Draw the shape
display : (Int,Int) -> GameState -> Element
display (w,h) gameState =
  let
    curvePath = gameState.curvePath
    lineColor = gameState.userInput.lineColor
    x = (toFloat w) / 2.0
    y = (toFloat h) / 2.0
  in
    collage x y [ traced (solid lineColor) (path <| curvePath)]

{-- That's all folks! ---------------------------------------------------------

The following code puts it all together and shows it on screen.

------------------------------------------------------------------------------}

delta = fps 30
input = sampleOn delta (lift2 Input delta userInput)

gameState = foldp stepGame defaultGame input

main = lift2 display Window.dimensions gameState
