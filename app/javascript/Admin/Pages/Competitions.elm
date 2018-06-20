module Admin.Pages.Competitions exposing (..)

import Html exposing (Html, table, thead, tr, th, text, tbody, td, a)
import Html.Attributes exposing (classList, href)
import Admin.Messages exposing (..)
import Admin.Routing exposing (competitionPath, linkTo)
import Admin.Types exposing (Competition)
import Date.Format exposing (format)


view : List Competition -> Html Msg
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


competitionRow : Competition -> Html Msg
competitionRow c =
    tr []
        [ td []
            [ a (linkTo (competitionPath c.id)) [ text c.name ]
            ]
        , td [] [ text (toString c.entryCount) ]
        , td [] [ text (format "%B %e, %Y" c.createdOn) ]
        ]
