module Admin.Routing exposing (..)

import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)
import Json.Decode as Decode
import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = CompetitionsRoute
    | CompetitionRoute Int
    | NotFoundRoute


competitionsPath : String
competitionsPath =
    "/admin/competitions"


competitionPath : Int -> String
competitionPath id =
    "/admin/competitions/" ++ (toString id)


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


nor : Bool -> Bool -> Bool
nor x y =
    not (x || y)


preventDefaultUnlessKeyPressed : Decode.Decoder Bool
preventDefaultUnlessKeyPressed =
    Decode.map2
        nor
        (Decode.field "ctrlKey" Decode.bool)
        (Decode.field "metaKey" Decode.bool)


onLinkClick : msg -> Attribute msg
onLinkClick message =
    let
        options =
            { stopPropagation = False
            , preventDefault = True
            }
    in
        onWithOptions
            "click"
            options
            (preventDefaultUnlessKeyPressed
                |> Decode.andThen (maybePreventDefault message)
            )


maybePreventDefault : msg -> Bool -> Decode.Decoder msg
maybePreventDefault msg preventDefault =
    case preventDefault of
        True ->
            Decode.succeed msg

        False ->
            Decode.fail "Delegated to browser default"
