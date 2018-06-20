module Admin.Pages.Competitions exposing (..)

import Html exposing (Html, div, article, table, thead, tr, th, text, tbody, td, a)
import Html.Attributes exposing (classList, class, href)
import Admin.Messages exposing (..)
import Admin.Routing exposing (competitionPath, linkTo)
import Admin.Types exposing (Competition)
import Date.Format exposing (format)


view : List Competition -> Maybe String -> Html Msg
view competitions flash =
    div []
        [ showFlash flash
        , table
            [ classList
                [ ( "table", True )
                , ( "is-fullwidth", True )
                , ( "is-hoverable", True )
                ]
            ]
            [ thead []
                [ tr []
                    [ th [] [ text "Name" ]
                    , th [] [ text "Entries" ]
                    , th [] [ text "Created On" ]
                    ]
                ]
            , tbody []
                (List.map competitionRow competitions)
            ]
        ]


showFlash : Maybe String -> Html Msg
showFlash flash =
    case flash of
        Just f ->
            article [ class "message is-success" ]
                [ div [ class "message-body" ]
                    [ text f ]
                ]

        Nothing ->
            text ""


competitionRow : Competition -> Html Msg
competitionRow c =
    tr []
        [ td []
            [ a (linkTo (competitionPath c.id)) [ text c.name ]
            ]
        , td [] [ text (toString c.entryCount) ]
        , td [] [ text (format "%B %e, %Y" c.createdOn) ]
        ]
