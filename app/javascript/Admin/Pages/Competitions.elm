module Admin.Pages.Competitions exposing (..)

import Html exposing (Html, table, thead, tr, th, text, tbody, td, a)
import Html.Attributes exposing (classList)
import Admin.Competition exposing (Competition)
import Date.Format exposing (format)


view : List Competition -> Html msg
view competitions =
    table
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


competitionRow : Competition -> Html msg
competitionRow c =
    tr []
        [ td []
            [ a [] [ text c.name ]
            ]
        , td [] [ text (toString c.entryCount) ]
        , td [] [ text (format "%B %e, %Y" c.createdOn) ]
        ]
