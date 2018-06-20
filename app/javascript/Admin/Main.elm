module Admin.Main exposing (main)

import Admin.Competition exposing (Competition)
import Admin.CompetitionLoader as CompetitionLoader
import Admin.Pages.Competitions
import Admin.Pages.NotFound
import Admin.Routing as Routing exposing (Route(..))
import Html exposing (Html)
import Navigation exposing (Location)


type alias Flags =
    { competitions : String
    }


type alias Model =
    { competitions : List Competition
    , route : Route
    }


type Message
    = OnLocationChange Location


init : Flags -> Location -> ( Model, Cmd Message )
init { competitions } location =
    let
        currentRoute =
            Routing.parseLocation location

        comps =
            case CompetitionLoader.loadCompetitions competitions of
                Ok data ->
                    data

                Err _ ->
                    []
    in
        ( { competitions = comps, route = currentRoute }, Cmd.none )


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    ( model, Cmd.none )


view : Model -> Html msg
view model =
    case model.route of
        CompetitionsRoute ->
            Admin.Pages.Competitions.view model.competitions

        CompetitionRoute id ->
            Admin.Pages.NotFound.view

        NotFoundRoute ->
            Admin.Pages.NotFound.view


main : Program Flags Model Message
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
