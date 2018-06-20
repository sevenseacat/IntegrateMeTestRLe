module Admin.Main exposing (main)

import Admin.Competition exposing (Competition)
import Admin.CompetitionLoader as CompetitionLoader
import Admin.Messages exposing (..)
import Admin.Pages.Competitions
import Admin.Pages.Competition
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


init : Flags -> Location -> ( Model, Cmd Msg )
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeLocation path ->
            ( model, Navigation.newUrl path )

        OnLocationChange location ->
            let
                newRoute =
                    Routing.parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )


view : Model -> Html Msg
view model =
    case model.route of
        CompetitionsRoute ->
            Admin.Pages.Competitions.view model.competitions

        CompetitionRoute id ->
            case List.head (List.filter (\c -> c.id == id) model.competitions) of
                Just c ->
                    Admin.Pages.Competition.view c

                Nothing ->
                    Admin.Pages.NotFound.view

        NotFoundRoute ->
            Admin.Pages.NotFound.view


main : Program Flags Model Msg
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
