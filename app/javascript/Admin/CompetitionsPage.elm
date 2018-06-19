module Admin.CompetitionsPage exposing (..)

import Html exposing (Html, table, thead, tr, th, text, tbody, td, a)
import Html.Attributes exposing (classList)
import Admin.Competition exposing (Competition)
import Admin.CompetitionLoader as CompetitionLoader
import Date exposing (Date)
import Date.Format exposing (format)


-- MODEL


type alias Flags =
    { competitions : String
    }


type alias Model =
    { competitions : List Competition
    , error : Maybe String
    }



-- INIT


init : Flags -> ( Model, Cmd Message )
init { competitions } =
    case CompetitionLoader.loadCompetitions competitions of
        Ok data ->
            ( { competitions = data, error = Nothing }, Cmd.none )

        Err msg ->
            ( { competitions = [], error = Just msg }, Cmd.none )



-- VIEW


view : Model -> Html Message
view model =
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
            (List.map
                (\c -> competitionRow c)
                model.competitions
            )
        ]


competitionRow : Competition -> Html Message
competitionRow c =
    tr []
        [ td []
            [ a [] [ text c.name ]
            ]
        , td [] [ text (toString c.entryCount) ]
        , td [] [ text (format "%B %e, %Y" c.createdOn) ]
        ]



-- MESSAGE


type Message
    = None



-- UPDATE


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    ( model, Cmd.none )



-- MAIN


main : Program Flags Model Message
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
