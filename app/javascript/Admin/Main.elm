module Admin.Main exposing (main)

import Admin.DataLoader as DataLoader
import Admin.Messages exposing (..)
import Admin.Pages.Competitions
import Admin.Pages.Competition
import Admin.Pages.NotFound
import Admin.Routing as Routing exposing (Route(..))
import Admin.Types exposing (Competition, MailingList)
import Html exposing (Html)
import Navigation exposing (Location)


type alias Flags =
    { competitions : String
    , mailingLists : String
    }


type alias Model =
    { competitions : List Competition
    , mailingLists : List MailingList
    , route : Route
    , currentCompetition : Maybe Competition
    }


init : Flags -> Location -> ( Model, Cmd Msg )
init { competitions, mailingLists } location =
    let
        currentRoute =
            Routing.parseLocation location

        comps =
            case DataLoader.loadCompetitions competitions of
                Ok data ->
                    data

                Err _ ->
                    []

        currentCompetition =
            loadCurrentCompetition comps currentRoute

        lists =
            case DataLoader.loadMailingLists mailingLists of
                Ok data ->
                    data

                Err _ ->
                    []
    in
        ( { competitions = comps
          , mailingLists = lists
          , route = currentRoute
          , currentCompetition = currentCompetition
          }
        , Cmd.none
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeLocation path ->
            ( model, Navigation.newUrl path )

        OnLocationChange location ->
            let
                newRoute =
                    Routing.parseLocation location

                currentCompetition =
                    loadCurrentCompetition model.competitions newRoute
            in
                ( { model | route = newRoute, currentCompetition = currentCompetition }, Cmd.none )

        UpdateName name ->
            let
                newCompetition =
                    case model.currentCompetition of
                        Just competition ->
                            Just { competition | name = name }

                        Nothing ->
                            Nothing
            in
                ( { model | currentCompetition = newCompetition }, Cmd.none )

        UpdateMailingListId id ->
            let
                newCompetition =
                    case model.currentCompetition of
                        Just competition ->
                            Just { competition | mailingListId = Just id }

                        Nothing ->
                            Nothing
            in
                ( { model | currentCompetition = newCompetition }, Cmd.none )

        UpdateRequireEntryName val ->
            let
                newCompetition =
                    case model.currentCompetition of
                        Just competition ->
                            Just { competition | requiresEntryName = val }

                        Nothing ->
                            Nothing
            in
                ( { model | currentCompetition = newCompetition }, Cmd.none )


loadCurrentCompetition : List Competition -> Route -> Maybe Competition
loadCurrentCompetition competitions route =
    case route of
        CompetitionRoute id ->
            findCompetition competitions id

        _ ->
            Nothing


findCompetition : List Competition -> Int -> Maybe Competition
findCompetition list id =
    List.head (List.filter (\c -> c.id == id) list)


view : Model -> Html Msg
view model =
    case model.route of
        CompetitionsRoute ->
            Admin.Pages.Competitions.view model.competitions

        CompetitionRoute id ->
            case model.currentCompetition of
                Just c ->
                    Admin.Pages.Competition.view c model.mailingLists

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
