module Admin.Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = CompetitionsRoute
    | CompetitionRoute Int
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map CompetitionRoute (s "admin" </> s "competitions" </> int)
        , map CompetitionsRoute (s "admin" </> s "competitions")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parsePath matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
