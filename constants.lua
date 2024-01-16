TEST_VALUE = 123344334
TEST_GLOBAL = nil

---------- PATHS ----------

STEEL_STUDIO_FOLDER_NAME = 'steelstudio'

TRACK_PATH = ac.getFolder(ac.FolderID.ContentTracks) .. "\\" .. ac.getTrackID()
TRACK_EXTENSION_PATH = TRACK_PATH .. "\\extension\\"
STEEL_STUDIO_FOLDER_PATH = TRACK_EXTENSION_PATH .. STEEL_STUDIO_FOLDER_NAME

---------- THEMES ----------

THEMES_PREFIX = 'theme_'

THEMES = {}
CURRENT_THEME = {}
FETCHED_THEMES = false
FETCHED_LOCATIONS = false

---------- LOCATIONS ----------

LOCATIONS_FILE_NAME = 'locations.json'
FOUND_LOCATIONS_FILE = nil

LOCATIONS = {}