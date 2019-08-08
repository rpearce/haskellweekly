module HaskellWeekly.Handler.PodcastFeed
  ( podcastFeedHandler
  )
where

import qualified Data.List
import qualified Data.Map
import qualified Data.Ord
import qualified HaskellWeekly.Handler.Base
import qualified HaskellWeekly.Template.PodcastFeed
import qualified HaskellWeekly.Type.Config
import qualified HaskellWeekly.Type.Episode
import qualified HaskellWeekly.Type.State
import qualified Network.HTTP.Types
import qualified Network.Wai

podcastFeedHandler
  :: Applicative f => HaskellWeekly.Type.State.State -> f Network.Wai.Response
podcastFeedHandler state =
  let
    baseUrl = HaskellWeekly.Type.Config.configBaseUrl
      $ HaskellWeekly.Type.State.stateConfig state
    episodes =
      Data.List.sortOn (Data.Ord.Down . HaskellWeekly.Type.Episode.episodeDate)
        . Data.Map.elems
        $ HaskellWeekly.Type.State.stateEpisodes state
  in
    pure
    . HaskellWeekly.Handler.Base.feedResponse Network.HTTP.Types.ok200 []
    $ HaskellWeekly.Template.PodcastFeed.podcastFeedTemplate baseUrl episodes
