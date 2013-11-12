module Main where

import Graphics.UI.Gtk
import Graphics.UI.Gtk.Display.StatusIcon
import System.GIO.File.File
import System.GIO.File.FileMonitor
import System.Directory
import System.Environment
import qualified Data.ByteString.Char8 as B

data EvState = EvState
 { evNewMailDir :: String
 , evIcon :: StatusIcon
 }

filesInDir :: FilePath -> IO Int
filesInDir dir = getDirectoryContents dir >>= return.length

updateMailStatus :: EvState -> IO ()
updateMailStatus s = do
  n <- filesInDir (evNewMailDir s)
  if n > 2 -- not counting "." and ".."
  then statusIconSetBlinking (evIcon s) True
  else statusIconSetBlinking (evIcon s) False

main = do
  initGUI --unsafeInitGUIForThreadedRTS
  dir <- getArgs >>= return.head
  icon <- statusIconNewFromFile "no_mail.png"
  let state = EvState { evIcon = icon
                      , evNewMailDir = dir
                      }
  fm <- fileMonitorDirectory (fileFromPath (B.pack dir)) [FileMonitorSendMoved] Nothing
  updateMailStatus state -- set icon right initially
  fm `on ` fileMonitorChanged $ evHandler state
  mainGUI

evHandler :: EvState -> Maybe File -> Maybe File -> FileMonitorEvent -> IO ()
evHandler s _ _ _ = updateMailStatus s

makeTrayIcon = statusIconNewFromFile "no_mail.png"
