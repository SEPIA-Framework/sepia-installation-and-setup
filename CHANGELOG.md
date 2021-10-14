## Release history and changelog

### v2.6.0 - 2021.10.10

Updated client to v0.24.0:
* Complete rework of audio system and switch to new **SEPIA Web-Audio library**:
  * Split old, monolithic speech library into smaller, more specific files + completely new, modular audio recorder
  * Handle audio processing in 'AudioWorklets' and 'Worker' threads
  * Support for new **SEPIA STT Server v2** with many new features (Docker container for all platforms available)
  * New WebRTC VAD (voice-activity-detection) module and experimental custom VAD module
  * Replaced old Porcupine wake-word library with new module to support v1.4-1.9
  * Support for many new Porcupine wake-words like Computer, Jarvis, Alexa, Hey Siri, Hey Edison, etc.
  * Support for external TTS server (Mary-TTS compatible API)
  * Added support for media-device selection (set 'sinkId' for mic and speaker) + media-devices settings view
  * Added microphone test-page
  * New audio.effects library (e.g. for TTS filter effects etc.)
  * Support for 'one-time' language option in TTS (switch to specific language for just one output)
  * Global recorder events
  * Support for MediaSession API
* Greatly improved features and support for custom voice-widgets (aka custom views/frames) including handling of speech events, input and animations (build your own voice interface)
* Added demo custom voice-widget: clock (use client demo-mode to get a first impression)
* Improved Teach-UI commands overview + new search field
* Added support for Teach-UI service 'music' (music search)
* Implemented remote action 'notify' and updated 'broadcast' interface and button (broadcast TTS messages to clients with same account)
* Improved media-control actions + optional 'delayUntilIdle' for client-control actions
* Completely new embedded media-player with custom widget support and powerful interface (build your own audio players)
* New 'Cards.embed' library for embedded card widgets + new YouTube embedded player + YouTube URL detection
* Added a few extra sounds for mic-trigger (original: coin, new: blob, chirp, bleeb, click)
* Fixes and ASR support for Microsoft Edge and Apple's Safari browser
* Added 'sections' to my-view
* Improved card context-menus, e.g. send music to other clients via media-player share button (new 'embedded_player' remote media action) etc.
* Style tweaks for big-screen mode + landscape mode for smaller screens
* Implemented screen orientation API and added setting to choose between landscape, portrait and automatic mode
* Added µPlot (lazy) library for visualizations and graph cards
* Added 'Cards' functions for WAV and line plot
* Added new 'UI.myView' module and improved 'add to my-view' feature
* Improved old skins and added new: 'Alabaster' (3 variants), 'Essential' (green + orange), 'Orange Style 2.0' (OS2)
* New avatars: 'The Dots', 'Classy', ILA O-Five (3 variants), 'S-Tech'
* New create-account info view and optimized labels of login box
* Improved list items and added properties 'id', 'lastEdit', 'eleType'
* Added ability to reload/refresh basic lists via context menu button
* Always remove old timer cards on sync + improved stability of 'Events.syncTimeEvents'
* Many style and UI improvements + updated icon-set
* Improved main menu (settings view)
* Updated tutorial
* Optimized 'UI.setup' and 'Config.loadAppSettings' to handle async. ready events
* Added support for a general 'sepia-info-event' dispatch (e.g. for CLEXI log)
* Added button to export (show) client settings as JSON (handy for headless client setup)
* Made experimental languages accessible via language selector
* Introduced new URL path variable '<sepia_website>' (in addition to existing '<assist_server>' etc.)
* Improved service-worker handling + offline page and disabled service-worker by default (use new URL param. 'pwa' to enable)
* Android: Added 'android.intent.action.VOICE_COMMAND' handling
* Improved security checks for URLs and actions

Updated Control-HUB (admin-tools) to v1.4.1:
* Added 'get mediadevices' command to CLEXI help
* Updated icon set
* Improved service-worker and offline.html

Updated Assist-server to v2.5.2:
* Created new 'WebContent/widgets' folder and added default media-player (YouTube etc.) files
* Added new 'clock' demo view to 'WebContent/views' folder and updated old demo view
* Updated 'MusicSearch' service to support new media-player widgets and 'data' parameter
* Added new YouTubeAPI class and updated config and property files to support API key
* Tweaked YouTube web-search results
* Updated radio stations
* Updated news outlets
* Updated radio and music service answer sets
* Prepared open-liga worker and parameters for new season (Bundesliaga)
* Added Porcupine wake-word files for HTML client to 'WebContent/files' folder
* Added support for option 'skipIfEmbeddable' to URL action
* Added support for optional 'delayUntilIdle' parameter of client_control_fun ACTION
* Updated 'ActionBuilder' class with more convenience methods
* Updated MaryTTS info
* Added 'updateListData' to DB methods and test script for list data CRUD operations
* Optimized alarms and lists code using new 'UserDataList.createEntry' methods
* Allow "_id" as filter when loading user-data lists
* Updated rome-tools (as usual) and fixed a bug in 'RssFeedReader'

Updated WebSocket Chat-Server to v1.3.2:
* Added notify as 'RemoteActionType'

Updated Teach-Server to v2.2.2:
* Added support for sorting commands by date
* Added Teach-UI service 'music' (music search)
* Allow custom (success) answers for music stream commands
* Minor code tweaks

Updated Core-tools to v2.2.9:
* Added fields to UserDataList 'checkable' item: 'itemId', 'priority' and 'dateAdded'
* Added optional 'delayUntilIdle' to client_control_fun ACTION
* Moved class 'RandomGen' from 'assist.tools' to 'core.tools'
* Updated spark-core to 2.9.3
* Updated commons-io and apache.httpcomponents
* Removed dependency 'google.guava' (use 'Apache Utils' and Java 8 classes instead)
* Tweaked HTTP connection methods

Other servers, tools and common changes:
* Removed SEPIA reverse-proxy from SEPIA-Home package (use Nginx or Apache instead)
* Updated all servers to core-tools v2.2.9
* Added new sections to 'sepia-extensions' repository for custom media-player widgets and client-views
* In preparation: improved DIY client (installation, logging, features)
* In preparation: updated SDK, demo Docker containers

### v2.5.1 - 2020.10.21

Updated client to v0.23.0:
* Added support for PWA (progressive web app) feature of browsers/OS via new basic service worker and PWA manifest file
* Android 10 support aka set 'targetSdkVersion' to 29, updated Cordova to v9, android-platform plugin to v8.1.0 and several other plugins
* Implemented context menu for every result card, e.g. radio/music-stream (+ playlist button, if available), news (read or copy), weather, etc.
* Improved presentation of weather results and added more mini icons
* Greatly extended capabilities of custom view frames with proper integration of microphone, new scoped functions (e.g. 'handleSpeechToTextInput') and secure loading from SEPIA client (folder available in Android as well) or server (SEPIA web-server folder)
* New folders for HTML 'templates', 'custom-data' and 'local_data' + automatic file path expansion for the tags '<custom_data>/', '<local_data>/', '<app_data>/' (root folder), '<assist_server>/' (URL to SEPIA web-server), '<teach_server>/' and '<chat_server>/'
* Added example custom view to new 'xtensions/custom-data/' folder
* Support for new service-actions 'open_settings', 'frames_view_action', 'close_frames_view' and 'switch_stt_engine'
* Support for new service-action 'custom_event' to trigger internal events that can e.g. be captured in the new custom view frames (works very well with SDK services)
* Added new remote-action type 'sync' for remote my-view, list and time-event updates and implemented it to update timers instantly across active devices
* Start and stop audio streams via new remote-action type 'audio_stream' + 'control' and changed data type 'music' to 'media'
* Added functions to get and show user clients and to send remote-actions via WebSocket chat-server
* Added 'connect', 'disconnect', 'wakeWordOn', 'wakeWordOff' and 'reload' to remote-action "hotkeys" (shortcuts: 'co', 'dc', 'ww', 'wm', 'F5')
* Added request source check to some remote-actions to allow e.g. 'mic' or 'connect' only if source is "protected" (aka coming from 'sepia-chat-server' or 'clexi-remote' + clexi-ID)
* Automatically mark open lists as out-of-date if any active client changes the data
* New client event 'sepia_alarm_event' that will be broadcasted (to CLEXI) when an alarm is triggered/removed/stopped
* New client event 'sepia-audio-player-event' that will inform about audio streams (start/stop/URL etc.)
* Additional client events for 'sepia-account-error' and 'sepia-client-error' + 'sepia-state' event will now inform about 'connection' state (active, closed, etc.)
* Increased maximal number of custom buttons from 16 to 42 and in addition load custom buttons that were stored via assistant user (this way admins can create buttons for all users at once)
* Updated icon-set for custom command buttons and improved material-icons loading procedure
* Improved login-restore procedure on app start and added automatic login-retry after connection or server error
* Improved checks and handling of expired login tokens and prevent login-refresh try if client-ID was changed
* Added settings button to login-box to quickly change device ID etc. before login
* New touch-bar control style selectable via settings that uses only the bottom of the screen for swipe and automatically minimizes text input field (double-tap triggers back button)
* New animations for speech input (speech-bubble-box 'processing')
* Very basic dual-screen support (e.g. Surface-Duo, wip)
* Added (very) basic big-screen mode to optionally remove size-limit of client window (settings)
* Added 'deviceId' to all account related API calls
* Interpret double-space as line-break in chat messages
* Added support for automatic-actions to UI pop-up and used it to trigger several retry-button actions automatically after few seconds delay (e.g. after connection loss)
* Fixed a bug that could sometimes crash the event queue after an empty speech result so that the client would not return to idle state
* Fixed a bug in Android speech recognition that could crash the app when the service was not supported/activated
* Added an auto-reset trigger if client is in 'loading' state for more than 45s and (if enabled) made sure that the wake-word listener will restart reliably
* Added 'keywords' field to remote terminal cmd 'get wakeword'
* Improved audio-player error handling
* Made the client more secure by adding 'DOMPurify' library and better sanitizing injected HTML code in cards, actions and chat
* Improved demo mode with new test actions (e.g. for 'open_frames_view' action via "action frame_1")
* Added some more language codes to the experimental ASR settings
* Improved audio recorder code + added ability to define custom sound for mic activation confirm and default recorder buffer length (hidden in "Hey SEPIA" settings page)
* Added settings option to select avatar independently from skin, made possible by splitting CSS files for skin and avatar + added ability to load 'base' skins and avatars when adding new skins
* New skins "flaming squirrel" and "flaming squirrel dark"
* Added support for "alive-ping" messages from WebSocket chat-server
* Send device info (device local-site etc.) to chat-server ('userOrDeviceInfo' via 'Client.sendOrRequestDataUpdate')
* Added new smart-home room types to local device-site menu
* Added support for 'userPreferredSearchEngine' and search-engine selector to settings
* Added new 'Assistant.waitForOpportunitySayLocalTextAndRunAction' function to make it easier to trigger text + action etc. via custom views
* Fixed an occasional render bug in chat (Chromium only)
* Improved support for storage-access API (web-dev)
* UI + UX improvements, better error messages, fixes and smaller improvements for very old browsers (e.g. IE11 and old Androids)
  
Updated Control-HUB (admin-tools) to v1.4.0:
* Improved code-ui with new user custom-services manager to load, edit and delete previously uploaded services (source-code)
* Improved code-ui to automatically select smart-service extension type when service file is opened
* New user-roles editor UI (replaces old, error-prone input field)
* Optimized CLEXI connection flow by using 'pingAndConnect' instead of just 'connect'
* Added new CLEXI remote terminal 'set' command examples ('micReset', 'connect', 'disconnect') and tweaked log colors
* Added button to client-connections page to show active clients via new 'getOwnClientConnections' chat-server endpoint
* Added 'DOMPurify' library with new function 'sanitizeHtml' and applied it to code, tts and smart home page
* Added statistics button to chat-server card in server overview page
* New room types 'entrance' and 'attic' for smart-home page
* Several smaller UI tweaks (e.g. for pop-up messages), updated material icons and improved icon loading
* Added support for PWA (progressive web app) feature of browsers/OS via new basic service worker and PWA manifest file
  
Updated Assist-server to v2.5.1:
* New news section 'maker' and new news outlets 'NY Times', 'The Guardian', '1E9', 'SPIEGEL Start' (replaces 'Bento'), 'Raspberry Pi' and 'SEPIA' + improved default selection for different sections
* Added SDK endpoint 'get-services' to load a list of user installed services
* Improved SDK service upload, store source code and load it via new '/get-service-source' endpoint
* New 'EventsBroadcaster' class, adaptations to 'RemoteActionEndpoint' and new method 'sendRemoteAction' (ServiceBuilder) for services
* New 'changeEvent' class and broadcaster to push e.g. user-data updates like changed lists and alarms directly to active clients
* Added new "custom view demo" (Xtensions/WebContent/views/custom-view-demo.html)
* Added new command 'frame_control' to create custom commands for custom view frames more easily
* Allow parameter extraction in services via named-groups in 'setCustomTriggerRegX' 
* Added 'qwant' and 'ecosia' as default web search options and evaluate user preference (if given via client 'prefSearchEngine')
* Fixed a nasty bug inside the string conversion method for optional parameters (could prevent runtime commands from working when custom JSON was used)
* Renamed legacy service 'OpenDashboard' to 'SettingsService' and fixed it to open settings info page
* Added new 'ActionBuilder' class to make usage in services easier + adjustments to handle changes in 'ACTIONS' class (core-tools)
* Fixes and improvements for some NLU parameters and services (e.g. 'AlarmName', 'NewsSection', 'SportsTeam', 'OpenCustomLink') + slightly improved 'RssFeedReader'
* New 'Room' parameter types 'entrance' and 'attic'
* Fixed a bug in smart device type filter that could prevent automatic device loading from HUBs like 'FHEM' or 'openHAB'
* Sanitized device loading procedure for internal smart home HUB to improve timing for larger lists of items
* Automatically replace "/" at the end of smart home interface URLs to improve UX
* Added new 'validUntil' field to authentication endpoint and improved error code for expired tokens
* Added 'playlistURL' to card-data of each radio station if available
* Added CORS support for static file hosting + 2 new config options for assist.[].properties: 'enable_cors' and 'enable_file_cors'
* Updated Bundesliga service and teams for new season
* Moved 'ThreadManager' to core tools and adjusted code
* Changed threshold for failed login attempts from 3 to 5 
* Tweaked 'saveStatistics' method to introduce random delay of 0-1s to reduce multiple quasi-simultaneous requests to DB
* Increased WebSocket maximal message size from 64 KB to 256 KB
* Smaller fixes and improvements (as usual)
  
Updated WebSocket Chat-Server to v1.3.1:
* Increased WebSocket maximal message size from 64 KB to 256 KB
* Added "broadcast to all devices" feature to remote-action handler and allow client-to-client actions for devices with same user
* Improved error messages for several handlers, e.g. 'SepiaAuthenticationHandler'
* Added new 'ClientManager' class and related endpoint '/getOwnClientConnections' to get a list of active clients for a specific user-id
* Added message data type 'ping' and new background service to test if a client is still alive and active (ClientPingRequestHandler)
* Added new statistics and endpoint (basically identical to the other servers)
* Added 'userOrDeviceInfo' to 'updateData' handler to obtain 'deviceLocalSite' and 'deviceGlobalLocation' info from client
* Changed remote-action type 'music' to 'media'
  
Updated Teach-Server to v2.2.1:
* Added 'frame_control' with examples and description to Teach-UI config ('common.js')
* New 'getAllCustomAssistantCommands' endpoint to get commands that were defined via assistant user
* Improved server statistics log
* Minor tweaks and fixes, e.g. in teach-ui 'common.js'
  
Updated Core-tools to v2.2.7:
* Moved 'ThreadManager' class from assist server to core tools, merged with old class and improved code
* Added 'frame_control' command to 'CMD'
* Cleaned up 'ACTIONS' class, fixed some legacy stuff and added 'button_custom_event', 'close_frames_view', 'frames_view_action' and 'switch_stt_engine'
* Fixed and improved 'unescapeHTML' method (Converters)
* Added CORS control method for static server files
* Smaller fix to avoid 'user agent' issues with 'Connectors' class
* Added 'node_red' name to 'CLIENTS' for future integrations
* Improved error code handling for failed user-account login requests
* Added "authentication time" statistics to 'BasicStatistics' class (for all servers)
* Replaced old 'javax.xml.bind.DatatypeConverter' with 'org.apache.commons.codec.DecoderException' to resolve Java version conflicts
* A few new methods, e.g. 'writeStringToFile' (FilesAndStreams) and 'getId' (UserDataList)
  
Other servers, tools and common changes:
* Updated all servers to core-tools v2.2.7 and JUnit 14.3.1
* Improvements to README files and more API docs (see API folder in sepia-docs repository)
* Improved server scripts with: new embedded Java download links, extended backup procedure (added custom views), proxy test during server start ('test-cluster.sh' only)
* Experimental Node.js support + Node-RED Nodes: https://github.com/SEPIA-Framework/sepia-node-js-client (check dev branch too)
* In preparation: updated SDK, DIY client scripts and Docker containers
  
### v2.5.0 - 2020.06.06

Updated client to v0.22.0:
* Major updates to Teach-UI to make creation of custom commands easier and more intuitive including examples and input pop-up for parameter data
* Added function to open Teach-UI via long-press on custom command button to edit command (uses new server endpoint, see below)
* Exported **wake-word** configuration to 'wakeWord.js' file (folder 'xtensions'), implemented switching of Porcupine engine (v1.4-1.6) and added all free wake-words (>40). Instructions included in folder.
* Updates for new weather service including new icons, styles and card updates
* Load new TTS voices list from SEPIA server (TTS endpoint) + smaller TTS fixes
* New skin 'historic future' as homage to 80s science fiction including **new avatar** for always-on mode 
* Fixed bugs in 'geocoder' module and related errors in my-view page update
* Fixed a bug in speech recognition that could sometimes prevent the result from loading at first try
* Updated CLEXI lib to v0.8.2, added support for 'runtime-commands' (e.g to handle DIY client reboot and shutdown) and fixed a bug in CLEXI connection
* Added broadcasting of speech events via CLEXI connection (intended for DIY client e.g. to set LED status lights)
* Added support for integrated speech recognition in Firefox Nightly (currently requires activation of 'media.webspeech.recognition.enable' and 'media.webspeech.recognition.force_enable' flags in FF)
* Improved security by restricting access to certain SEPIA library functions via session token and by escaping all HTML code inside plain chat messages (includes adjustments to handle new chat server behavior)
* Improved 'inputControls' module, fixed gamepad support and remote trigger
* Improved handling of 'lastAudioStream' and stream title
* Added proper chat labels (indicators that show when messages were posted) for 'today' and improved 'UI.showInfo'
* Improved 'intent://' handling of Android inApp browser
* Added URL param 'autoSetup' (similar to headless-mode) to load settings.js at start and enter setup mode after 8s if no user is logged in
* Added basic web-worker interface that can be used to run code in background thread
* Optimized app start-up, initial page and skin loading
* Improved logger (for dev tools console)
* Smaller and bigger skin and style tweaks all over the place (skin upgrades, Firefox scrollbar support, etc.)
  
Updated Control-HUB (admin-tools) to v1.3.2:
* Several updates and improvements to 'smart home' page including full suport for new internal HUB, custom interfaces (including ioBroker and MQTT), smart device creation and more intuitive server settings handling
* Implemented new 'user list' endpoint and added request button to 'user management' page
* Added 'runtime-commands' support (new CLEXI feature) to 'client connection' page and updated CLEXI lib to v0.8.2
* More colors for CLEXI remote-terminal connection broadcasts + log filter options
* Added save file button to 'Code-UI' page and implemented auto-loading of class name on code paste event (if possible)
* Adjustments to handle all server changes (see below, e.g. camel-case in JSON etc.)
* Improved automatic hostname detection for public URLs during login
* Improved logger (for dev tools console)
  
Updated Assist-server to v2.5.0:
* Added completely new weather services with improved results, new icons and NO API KEY requirements
* Integrated TTS engines 'Pico' (3 voices) and 'Mary-TTS' (5 voices + X, requires server) + automatic handling of Mary-TTS server at SEPIA start
* Manage smart devices inside SEPIA and handle multiple smart HUB interfaces at the same time via the new interface 'SmartDevicesDb' using the new database indices 'smart-devices' and 'smart-interfaces' (implementation: 'SmartDevicesElasticsearch')
* Added new smart home HUB connectors (partially supporting 'SmartHomeHub') for **ioBroker** and **MQTT**
* Added new smart home HUB interface 'InternalHub' that stores smart devices inside the internal SEPIA DB and can connect to multiple instances of: openHAB, FHEM, ioBroker and MQTT to read/control devices
* Several improvements to 'SmartDevice' NLU parameter to find best device match for example extraction of known (buffered) device names
* Several improvements to 'SmartHomeHub' interface to support new implementations
* New types 'terrace' and 'balcony' for parameter 'Room' and tweaks for type 'other'
* Added GZIP header for FHEM interface to avoid (potential) bug with large 'getDevices' results
* Changed 'SmartHomeDevice' JSON fields to use camel-case consistently
* Improved smart home service to use all new features and fixed some bugs
* Updated news with sections for 'health' and 'corona' and added answer for devices without active display
* Created new 'ThreadManager' class to better handle all (most) active threads of the server and offer some convenience methods e.g. for parallel processing
* Added new worker type 'DuplexConnectionInterface' + MQTT implementation and improved existing workers
* Improved collection and presentation of server statistics to include smart home APIs, new workers and threads
* Added 'processTime' field to 'NluResult' JSON output with details about NLU and service time
* Updated 'ClientControls' service and 'ClientFunction' parameter to support new 'runtime-commands' feature (related to CLEXI updates)
* Added 'resume' to NLU parameter 'Action' and improved music and radio related services
* Extended 'UserManagementEndpoint' to accept action 'list' and return a basic overview of all user accounts
* Added general support for **Kotlin** and added 'com.willowtreeapps.fuzzywuzzy' (0.1.1) Kotlin library 
* Added new new fuzzy match methods to 'StringCompare'
* Added class 'ParameterTools' to run performance critical methods via a profiler that will auto-skip slow calls
* Changed NLU sentence normalizers to keep '?' if its in the MIDDLE of a sentence
* Improved 'WebsearchBasic' service to handle devices that don't have an active display (via 'ENVIRONMENTS.deviceHasActiveDisplay')
* Improved 'OpenCustomLink' service security for links that contain Javascript code
* Improved RSS feed reader error correction
* Improved account data validation
* Many smaller tweaks to parameters, services and answers
* Code clean-ups for Java 11
  
Updated WebSocket Chat-Server to v1.3.0:
* Updated 'SepiaMqttClient' and 'SepiaMqttClientOptions' with new methods, e.g. for topic subscriptions and connection checks
* Introduced server-side HTML encoding for the 'text' field in 'SocketMessage' to prevent HTML injections by default
* NOTE: Due to the changes in 'SocketMessage' SEPIA services cannot use HTML content in plain answers anymore (use actions or cards instead)
  
Updated Teach-Server to v2.2.0:
* New endpoint 'getPersonalCommandsByIds'
* Restructuring of 'common.json' file used by Teach-UI to define shared parameters + general improvements and more info for commands. 
* NOTE: Due to the format changes of 'common.json' old SEPIA clients (<0.22.0) need to be updated
  
Updated Core-tools to v2.2.6:
* Added new user roles: infant, kid, teen, elderly
* Extended 'AuthenticationInterface' and 'Elasticsearch' with methods for 'listUsers' and 'getDocuments'
* Extended 'ConnectionCheck' tool to optionally print error via 'printError' argument
* Optimized Http GET/POST/etc. methods in 'Connectors' to support GZIP encoding header, fixed some header issues and added timeout parameter
* Added 'CsvUtils' to tools to read CSV data
* Added 'deviceHasActiveDisplay' to 'ENVIRONMENTS'
* Added 'org.owasp.encoder' lib and new HTML encode and escape methods to 'Converters' class
* Added Apache Commons-IO lib
* Improvements to 'JSON', 'StringTools', 'URLBuilder', 'RuntimeInterface' and 'EsQueryBuilder'
* Updated jackson-databind to v2.9.10.3
  
Other servers, tools and common changes:
* Improved server setup, run and test scripts including support for Mary-TTS server
* Improved server update and backup scripts and added script to import backups
* Added script to import SSL certificates into Java truststore (Linux, beta, useful for self-signed SSL)
* Improved DIY client installation and setup (more info soon)
* Updated all servers and tools to use core-tools v2.2.6
  
### v2.4.1 - 2020.02.17

Updated client to v0.21.0:
* Introduced new headless mode (URL param. 'isHeadless=true') with support for 'settings.js' file and new remote commandline module (using CLEXI server)
* Client will automatically switch into setup state after few seconds when in headless mode and no login is given (+ audio notification ^^)
* Integrated new TTS engine that streams data from SEPIA server (switch via new voice engine selector in settings)
* Added new 'ILA-Legacy' skin with custom avatar for Always-On mode :-)
* Added new 'server-access' page for detailed connection configuration (accessible from login and settings, replaces hostname field)
* Improved automatic hostname recognition
* Created new icon selection popup and applied it to Teach-UI custom button field
* Added custom GPS location to device site settings
* Slightly improved visibility of missed chat messages
* Improved alarm sound player to better manage other audio sources
* New CSS options to better control status bar and navigation bar color in Android (and probably iOS)
* Fixed bugs in view scrolling and 'switchLanguage' service-action
* Added URL param. 'logout' to start client with automatic logout
* Improved Teach-UI start-up to allow more pre-filled teach fields
* Added more debug/help info for insecure-origin (SSL stuff) issues like microphone access restrictions
* Updated CLEXI lib to v0.8.1
* Added some IE11 polyfills
  
Updated Control-HUB (admin-tools) to v1.3.1:
* New 'Client Connections' page including remote terminal to access headless clients (via CLEXI)
* New 'Speech Synthesis' test page for SEPIA TTS endpoint called
* Smart home: better check of set-cmds entry for toggle button
* Smart home: added 'sunroom' to list of rooms
* Improved automatic hostname recognition for '[IP]:20726/sepia/...' origins
* Updated CLEXI lib to v0.8.1
  
Updated Assist-server to v2.4.1:
* The TTS module of the server has been updated and upgraded to support the 'espeak' engine (flite and picoTTS will follow soon). This means every client can stream TTS from the SEPIA server now if required. Please check the updated 'setup' scripts to install the packages!
* Improved DataLoader to allow custom command and answer files, e.g. chats_en_custom.txt in addition to chats_en.txt (folder: sepia-assist-server/Xtensions/Assistant/...). This way users can better manage global custom commands.
* Smart home interfaces (FHEM, openHAB, TestHub) will load devices correctly via unique ID now
* The smart home service will ask the user now if its ok to use the first result in case a device search has multiple matches (given a specific room)
* If a command uses a smart home device with specific name (tag) e.g. because it was defined via Teach-UI the tag will now be used properly to search the device (see Teach-UI examples)
* Added 'sunroom' type to Room parameter
* All brackets in the names of smart home devices will correctly be removed during voice output (use them e.g. to give your devices numbers)
* Fix for FHEM interface if CrfToken is deactivated in FHEM server
* Several smaller fixes/tweaks to the smart home interface (better 'state' and 'stateType' checks, "device with number X" works, correct handling of non-existing device types, etc.)
* Updated radio stations, fixed a bug and added "chill-out" to parameter 'MusicGenre'
* Improved output format of local time in answers
* Updated news outlets and removed "11FREUNDE" (feed does not exist anymore :-( )
* Added a README for the directory listing endpoint that can be found inside the web-content folder
* Improved Java 11 compatibility
  
Updated Core-tools to v2.2.5:
* Fixed a bug in RuntimeInterface
* Added new 'open_frames_view' action (to be used by services)
* Better error messages for Apache Http GET method
* Updated mp3spi lib to v1.9.5.4 to fix a Java 11 issue
  
Other servers and tools:
* Added scripts to install Java locally into SEPIA folder (~/SEPIA/java). Very useful for Windows systems.
* Updated server scripts to offer more options, better overview and improved features (e.g. setup Nginx and TTS engine, handle errors better, etc.)
* Updated installation scripts and descriptions to get rid of some outdated info and stuff (e.g. promote Java 11, sudo warnings, etc.)
* Teach-Server v2.1.1 has some improved descriptions for Teach-UI commands
* Updated all servers and tools to use core-tools v2.2.5
* Updated Dockerfile and added new script to build the build-environment for SEPIA-Home
* Prepared everything for the release of the official "headless" Raspberry Pi SEPIA-Client
  
### v2.4.0 - 2019.12.30

Updated client to v0.20.0:
* Integrated SEPIA Control HUB into settings frontpage of app (will show when user has certain role, e.g. 'tinkerer' or 'smarthomeadmin')
* New setting for preferred temperature unit (Celsius/Fahrenheit) that can be accessed in services via user account or device settings
* Added new page for 'device local site' to set a specific location for the client like 'home:living-room' that can be read by any smart service on the server
* Load up to 16 custom command buttons to my-view by default (up from 10)
* Load services config of Teach-UI from new teach-server endpoint
* Added a help button for extended login box that redirects to SEPIA docs
* Auto-assign a 'dark-skin' or 'light-skin' class when selecting a skin to better handle certain CSS rules
* Basic post-message interface for apps that run inside IFrames (to be extended soon)
* Tweaked TTS voice selection indicator depending on platform
* Added 'env' parameter to launcher page
  
Updated Control-HUB (admin-tools) to v1.3.0:
* Added post-message interface to load tools in IFrame and login user (used for example in client app to show Control HUB and auto-login user)
* Smart home: Uses new 'integrations' endpoint of assist-server to communicate with HUBs instead of calling them from client (in addition: HUB host URLs must match server setting now to prevent unsafe HTTP calls)
* Smart home: Completely reworked device cards and interface (new options, hide/filter devices, auto-refresh, test button, etc. ...) and added Test-HUB for experiments
* Smart home: Support for a total of 11 device types (lights, shutters, thermostats, etc.) and 14 room types (bath, office, living-room, etc.)
* Smart home: Allow device names with numbers in brackets that will be skipped in assistant answers, e.g. name='Bed Light (2)' -> answer: 'your Bed Light is set to ...'
* Smart home: Added extended device settings for experts to fine-adjust state type and set commands
* Assistant testing: Added two new buttons to call 'understand' and 'interview' server endpoints
* Core settings: Show persistant settings as editable list
* STT: Added test button to extract personal commands as (anonymous) training data for language models
  
Updated Assist-server to v2.4.0:
* Added new server endpoints 'understand' (improved version of 'interpret') and 'interview' (shows either intent summary or indicates missing info including question)
* Completely reworked 'SmartHomeHub' interface to improve HUB communication and make it easier to integrate new HUBs (register methods, generalized set values, more sepia-xy tags, common search and filter methods, etc. ...)
* Added FHEM smart home HUB support (config name 'fhem') and a Test-HUB for experimenting (config name 'test')
* Improved 'SmartHomeHubConnector' service and whole smart home methods + NLU to handle a total of 11 device types (lights, shutters, thermostats, etc.) and 14 room types (bath, office, living-room, etc.)
* Added NLU support for device number and room number (e.g.: "set light 2 in bath 2 to 70%") and changed 'SmartDeviceValue' result type from 'Number' to own format
* Added optional reply parameter to smart home service
* Added settings for smart home HUB basic authentication ('smarthome_hub_auth_type', e.g. 'Basic' and 'smarthome_hub_auth_data', e.g. base64 encoded 'username:password')
* New server endpoint for integrations ('integrations/*/*') and first implementation for direct smart home HUB communication (send commands to HUBs like FHEM directly without using the NLU + smart service)
* Questions inside a service can now use wildcards to access previously defined parameters from 'resultInfo' (example dialog: User: "Set light" - Sepia: "Set <1> to what?")
* Added new 'unit_pref_temp' (temperature unit) property to user account
* Services have access to new 'device local site' and 'user preferred temperature unit' (both used in smart home service for example)
* Added temperature convert method (C <-> F) to Number parameter and automatically convert between units in smart home service (depending on user pref. and device state type)
* Added 'ServiceRequirements' class and 'getRequirements' to 'ServiceInterface' to better handle SEPIA version conflicts in the future
* New server endpoint ('web-content-index/[web-server-folder]') and settings (see example folders in 'Xtensions/WebContent/') to generate directory listings of web-server content
* Added 'Size Radio' channel and fixed 'EgoFM' streams
* Support for Elasticsearch Authorization via 'db_elastic_auth_type/data' setting
* Tweaked 'getConfig' server endpoint to show even less sensitive data from properties file (passwords and keys show as 'HIDDEN')
* Added device-ID to Elasticsearch mapping for personal commands
* Several code clean-ups, improvements, NLU tweaks and bug fixes
  
Updated WebSocket Chat-Server to v1.2.2:
* Added Eclipse Paho MQTT client and SEPIA classes (SepiaMqttClient, SepiaMqttClientOptions, SepiaMqttMessage)
* Support for Elasticsearch Authorization via 'db_elastic_auth_type/data' setting
  
Updated Teach-Server to v2.1.0:
* Support for Elasticsearch Authorization via 'db_elastic_auth_type/data' setting
* New endpoint 'getTeachUiServices' and services file (Xtensions/TeachUi/services/common.json) to be able to load Teach-UI configuration from server
* Added command 'smartdevice' to Teach-UI config with examples
* New endpoint 'getAllCustomSentencesAsTrainingData' to be able to extract data for speech recognition language model
* Optionally add device-ID to custom commands for future 'per-device' command selection
  
Updated Core-tools to v2.2.4:
* New user role 'smarthomeadmin' (user that has access to smart home HUB config) and 'tinkerer' (a user that likes to see more detailed configuration options ^_^)
* New CoreEndpoints method 'getWebContentIndex' to index web-server folder and build interactive file list
* Updated Connectors with more control of headers and added 'headers' map to 'HttpClientResult' for 'apacheHttpGET' method to get direct access to result headers
* Added support for 'Authorization' header to Elasticsearch class via 'auth_type' and 'auth_data' settings
* New method 'readFileModifyAndCache' in FileAndStreams class to read a file line-by-line, optionally modify each line and keep result in cache (handy for settings files etc.)
* New decimal format number converters 'stringToNumber' and 'numberToString' to read numbers and get a number string in specific format more easily (uses new common default decimal format)
* Added deviceId as field to Command and SentenceBuilder classes
* Added 'getKeys' and better 'prettyPrint' to JSON class
* New 'Is.typeEqual' and 'Is.typeEqualIgnoreCase' methods
* Added 'modifyThread' permission to SandboxSecurityPolicy to avoid errors with Paho MQTT client
* Tweaked 'httpSuccess' method in Connectors to optionally give cleaner result
* Updated fasterxml.jackson.core (again!) to apply latest security fix
  
Other tools:
* Updated SDK to v0.9.20 to support new SEPIA-Home release and added 'MqttDemo' service to demonstrate how to publish service results to a MQTT broker
* Updated Mesh-Node to v0.9.12 to include new core-tools v2.2.4
  
### v2.3.1 - 2019.10.14

Updated client to v0.19.1:
* Custom-buttons (defined via Teach-UI) work properly now in group-chats
* Show a colored bell in AO mode to indicate 'you have a message in another channel'
* Fixed some bugs related to channel-history feature, e.g. a few seconds scrolling-lock and missing/wrong day tags in chat
* Improved audio-events tracking and handling in connection to 'hey SEPIA' wake-word
* Added option to allow/prevent wake-word while music is playing (default: prevent, to avoid audio artifacts in some mobile clients)
* Improved audio recorder performance and stability and fixed dynamic downsampling
* Fixed some issues with YouTube player (sometimes 'pause music' wasn't working)
* Added 'env' URL parameter to be able to set custom value for 'environment' variable (client info sent to server)
* Fixed deprecated code in iOS audio processing to make build process work again (iOS 12.4, Swift 5 - native ASR still broken, but restored open-source ASR support)
* Improved some error messages after failed login
* Prevent multiple queued follow-up messages of same 'type' (only one will show)
* Prevent chat names that look like user IDs to prevent accidental private messages to wrong receiver
* Prevent auto-scrolling of chat when hidden channel-status message was added
* Updated jquery to 3.4.1
* Added library for voice-activity-detection (VAD, though it is not used yet)
  
Updated Control-HUB (admin-tools) to v1.2.2:
* Updated smart home settings with new device and room options
* Implemented remote-action on 'assistant' page
* Added info message for new temporary 'login blocked' feature and fixed a bug with 'new login'
* Updated jquery to 3.4.1
  
Updated Assist-server to v2.3.1:
* Made NLU interpretation-chain configurable via properties file entry 'nlu_interpretation_chain'
* Introduced 'getWebApiResult' as new interpretation-step to easily integrate different NLU servers (example chain entry for SEPIA Python bridge: `getPersonalCommand, WEB:http://127.0.0.1:20731/nlu/get_nlu_result, ...`)
* Introduced abstract class 'WebApiParameter' to easily integrate custom parameter handlers that use different NLU servers
* Improved JSON import/export methods for 'NluInput', 'NluResult' and 'User' classes and added optional 'custom_data' fields to better serve new web API NLU options
* Introduced 'addCustomTriggerSentence' variations in 'ServiceInfo' to support predefined parameters (raw, normalized or extracted)
* Introduced optional input tags '<i_raw>', '<i_norm>' and '<i_ext>' to 'Interview' module to control how a predefined parameter should be handled
* Updated 'SmartDevice' and 'Room' parameters with new types (tv, fridge, oven, office, ...)
* Updated news outlets with 'Hackaday' RSS feed
* NLU tweaks ("pause music", "switch to german", ...)
* Fixed and improved 'remote-action' endpoint
* Added security feature to natively protect selected accounts from brute-force attacks by blocking login temporarily after too many failed attempts. Add accounts via properties file entry 'protected_accounts_list'
* Added option to deactivate security policy and sandbox via cmd arguments 'nosecuritypolicy' and 'nosandbox'
* Code clean-ups
  
Updated WebSocket Chat-Server to v1.2.1:
* Fixed and improved 'remote-action' handler
* Fixed a bug in sorting of channel history by timestamp
  
Updated Core-tools to v2.2.3:
* Redesigned ENVIRONMENTS class to better reflect possible client types
* Added method to get parameters from command-summary string
* Code tweaks
  
Updated SDK to v0.9.12:
* Support new SEPIA-Home release v2.3.1
* Added 'PythonBridgeDemo' service to demonstrate SEPIA Python bridge and new NLU web-API options
* Updated 'WorkoutHelperDemo' to demonstrate new options for 'addCustomTriggerSentence' with predefined parameters
* Updated readme to emphasize JDK dependency
* Updated FasterXML/jackson core to 2.9.10 to include latest security fix 
  
Other tools:
* Updated Teach-Server to v2.0.4 to include core-tools v2.2.3 and fixed version number
* Updated Mesh-Node to v0.9.11 to include new core-tools v2.2.3 and fixed version number
  
### v2.3.0 - 2019.09.08

Updated client to v0.19.0:
* Partially reworked and greatly improved messenger features and UI to support channel create, join, invite (via URL), missed messages, history and more
* Added option to change login password from settings menu (via old password)
* Improved messaging between devices with same login but different device-ID
* Improved handling of SEPIA universal links when posted inside SEPIA chat channels
* Improved UX and security when interacting with SEPIA in group chats (public SEPIA messages will not automatically execute actions or play music anymore)
* Keep keyboard open in mobile apps when 'send'-button is pressed
* Forget last command after 60s (to prevent 'I just told you' kind of SEPIA comments after long idle time)
* Automatically select user-preferred color scheme (read from OS) and set light or dark skin when no skin was selected before
* Optimized 'switch-language' action 
* Renamed 'saythis' button to 'broadcast'
* New 'updateData' message-event handler to support arbitrary data exchange with chat-server via WebSocket connection
* Fixed a rare crash due to outdated splash-screen plugin in Android
* Improved data store/load script to reduce number of writes
* Added onChatOutputHandler for views like AO-Mode (e.g. see SEPIA answer as text in AO)
* Added pause/resume client control for audio players and tweaked YouTube music to properly pause audio when STT is activated
* Added support for new input command 'i18n:XY' to dynamically set input language (e.g. 'i18n:de Guten Tag' will trigger the German 'Hello' even when app language is english)
* New share-menu activated by a long-press on the sender name in a chat message
* Made BLE Beacon remote URL more flexible
* Improved auto-scaling below 300px window width and tweaked tiny-mode
* New launcher.html page to configure launch-options and automatically redirect (handy for app in browser kiosk-mode)
* Reactivated 'application/ld+json' tag in index.html
* Set Android target SDK to 28 (Android 9.0) and improved support including new 'network security config'
* Minor UI, bug and style fixes
  
Updated Control-HUB (admin-tools) to v1.2.1:
* Core-settings page now allows to write assist-server settings (key-value pairs) directly to config file and reload server remotely. This e.g. allows to quickly add API keys etc.
* Smart-home page now allows to load smart-home HUB info data from server (via improved server-config endpoint)
* Added 'delete user' function and button to user-management page
* Fixed channel create function to support new chat-server version
* Get channel history statistics and force database clean-up from chat-settings page
* Style tweaks and more info texts
* Added correct version number to help-page
  
Updated Assist-server to v2.3.0:
* Introduced new SmartHomeHub interface and config settings to make integration of hubs like ioBroker, FHEM and HomeAssistant easier
* Adjusted openHAB integration to use new SmartHomeHub interface
* Updated radio-stations and news-outlets lists
* Fixed OpenLigaWorker and service to support new season of German Bundesliga
* Added background tasks and task-manager support (schedule, check, cancel, etc.) to services (via 'ServiceBuilder.runOnceInBackground') and improved data-storage for services (e.g. via 'ServiceBuilder.readServiceDataForUser')
* Improved and enabled (previously dormant) NLU-parameter 'Language' and tweaked dictionary service
* Added 'LanguageSwitcher' service to support commands like "switch language to German"
* Improved smart home device intent (NLU) to recognize devices more generally (e.g. "status of my XY 1" -> device=XY 1)
* Improved 'no_result' answer when using 'sentence_connect' command (e.g. via Teach-UI) and tweaked internal service redirect
* Tweaked 'reminders' NLU ("remind me to/remember ...")
* Added inputModifiers to InterpretatonChain and implemented new i18n-modifier to be able to switch input language on-the-fly (e.g to share SEPIA links independent of user language)
* Added meta data to OPEN_LINK command to better handle 'linkshare' (note: 'linkshare' is a special chat input cmd, e.g. type: "linkshare https://twitter.com/sepia_fw")
* Improved 'AuthEndpoint' to support password change via old password (or superuser) and tweaked 'delete' user procedure
* Improved 'ConfigServer' endpoint to support editing server settings file (assist.xy.properties) directly, e.g. via SEPIA Control-HUB
* Implemented server restart method and added endpoint option to 'ConfigServer' (it will try to shutdown client and workers as clean as possible and reload settings)
* Fixed code in GeoCoding and Weather API to make them more stable
* Adjustments in SEPIA WebSocket client to support chat-server update (including device-ID message routing)
* Updated and added new Elasticsearch database mappings for chat (channels, users, messages) and added test-method to server start that will add missing ES indices automatically
  
Updated WebSocket Chat-Server to v1.2.0:
* Re-organized and improved code, e.g. to get better access to all the message handlers (create channel, join, auth, etc.)
* New and improved methods/handlers/endpoints for channel create, join, delete
* New database interfaces and implementations (Elasticsearch) for channel-data (store/load created channels), channel-users (store/load missed events) and channel messages (store/load channel history)
* New settings in config file for database modules (in-memory and Elasticsearch) and options like 'store_messages_per_channel' or 'max_channels_per_user' etc.
* Automatic clean-up in background of old messages (e.g. when 'store_messages_per_channel' threshold is reached), see config option 'channel_clean_up_schedule_delay'
* Broadcast 'missed message' event to online users when in different channel and store events for offline users to inform them later on login
* Improved message routing by including sender and receiver device-IDs (especially useful when multiple devices run on same account, e.g. smart-speaker in living-room and kitchen etc.)
* Improved handling of channel-ID in combination with channel-name
* New 'updateData' message-event handler to support arbitrary data exchange with clients via WebSocket connection
* Added server-ID to each socket-message (in case we expand the cluster later)
* New endpoints 'getAvailableChannels', 'getChannelHistoryStatistic' and 'removeOutdatedChannelMessages'
  
Updated Core-tools to v2.2.2:
* Added run-single-task and schedule-task methods to 'ThreadManager'
* Added range-match to 'EsQueryBuilder' (e.g. to find all entries older than xy-timestamp)
* Created 'LruCache' class (last-recently-used cache)
* Updated javaspark up to v2.9.1
* Updated fasterxml.jackson.core to 2.9.9.2
  
All servers:
* 'localName' of server is now also used as server-ID and device-ID if one is required (e.g. for load-balancing of cluster or broadcasting info to chat channels)
  
Other tools:
* Added code for [Microbit BLE Beacon remote](sepia-microbit-projects)
* Updated Teach-Server to v2.0.3 to include new core-tools v2.2.2 and thus javaspark v2.9.1 (no other code changes)
* Updated SDK to support new SEPIA-Home release and added 'WorkoutHelperDemo' service to demonstrate pro-active background messages and database access
* Updated reverse-proxy to v0.3.2 to include security fix for undertow-core v2.0.23
* Updated Mesh-Node to v0.9.10 to include new core-tools v2.2.2 and thus javaspark v2.9.1
* Updated browser extension to v0.6.2 to exclude localhost, local domains and SEPIA path from showing navbar

### v2.2.2 - 2019.05.31

Updated client to v0.18.0:
* Added new 'music-search' and 'media' function to client-controls with Android MEDIA_BUTTON Intent support
* Added selector for default music app including YouTube, Spotify, Apple Music (Browser/Mobile) and VLC (Android only)
* Added music-search as link-card type and added support for YouTube embedded videos (including stop and next command interface)
* Added new skins "Spots" and "DarkCanary"
* Added new context menu for cards to link and timer cards with buttons like 'share' and 'copy' (link)
* Added 'add to Android calendar' and 'add to Android alarms' buttons to timer cards
* Improved link-cards
* New and upgraded implementation for universal deeplinks (e.g. share reminders, requests, links, etc.)
* Filled Teach-UI help button with many examples and info for each command
* Added Teach-UI support for flex-parameters in sentence_connect (see new help for more info)
* Added new platform_controls command to Teach-UI (one sentence - device dependent actions like URL-call or Android-Intent)
* Improved reconnect behavior after lost connection
* Added server version check and incompatibility warning to start-up sequence 
* Added new client info to server requests (deviceId, platform, default music app etc.)
* Fixed and improved 'Hey SEPIA' code (still some smaller issues left)
* Added Android ASSIST Intent listener to allow SEPIA to become default system assistant (long-press on home button)
* Added Android Intent plugin
* Added Android navigation bar plugin for colored soft-keys (bottom of screen)
* Fixed some issues related to active chat-channel and messages
* Added onActive and onBeforeActive event queue
* Added button to store/load app settings to/from account after login
* Support for follow-up messages from server (received after initial service 'completion')
* Updated CLEXI client library to v0.8.0 (with support for CLEXI http events)
* Added CLEXI connection status indicator
* Improved handling of well-being/pro-active notifications (e.g.: inform server of received notes to prevent duplicated messages, deliver when active, etc.)
* Improved my-view updates
* Improved list scrolling on footer minimize-click
* Improved audio player animation
* Improvements to pop-up messages
  
Updated Assist-server to v2.2.2:
* New MediaControls parameter and improved ClientControls service to handle 'next song', 'stop music', (improved) 'volume', etc.
* Added dynamic select parameter to ServiceBuilder to easily add choose-one-of questions to any service
* Added SpotifyApi (see properties file for API client/key) and iTunesApi classes to handle music search requests
* New service: MusicSearch with parameters for song, artist, service, playlist, genre and support for music search link-cards
* New service: PlatformControls (see client Teach-UI for more info)
* Improved cards and URL actions in some services (location, direction, music, etc.)
* Tweaked WebSearch service to better handle YouTube
* Added flex-parameter support to sentence matcher (see client Teach-UI for more info)
* Updated news outlets
* Added deviceId, platform and custom data to NluInput (for things like default music app etc.)
* Added support for 'recently triggered pro-active notification' to events manager
* Improved NLU and several parameters, e.g. action, number, list sub-type, date/time
* Improved link-cards with new type and brand options (e.g. to distinguish music links and web-search)
* Added support to store and read app settings (per user-id and device-id)
* Added follow-up message support (delayed assistant answers etc.) for duplex connections (e.g. with default WebSocket client)
* Improved RSS feed reader (again! less errors finally and improved backup check for outdated content)
* Moved basic Elasticsearch interface to core-tools
  
Updated WebSocket Chat-Server to v1.1.1:
* Support for follow-up messages (see assist-server and client for more info)
* Moved code for channel management endpoint to new ChannelManager class
* Improved SocketChannel with JSON import/export of data
* Preparations for improved channel create/join support
  
Updated Core-tools to v2.2.1:
* Added new content to CMD, PARAMETERS and CLIENTS
* Improved Connectors (e.g. http GET with headers and better encoding)
* Moved Elasticsearch interface from assist-server package
* Updated FasterXML/jackson core to 2.9.9 to include latest security fix

### v2.2.1 - 2019.03.24

Updated client to v0.17.0:
* Added support for Bluetooth LE beacons to be used as remote control triggers
* Added [Node.js CLEXI](https://www.npmjs.com/package/clexi) integration to handle BLE support on e.g. Desktop browsers
* Improved remote control settings (aka gamepad settings) to support BLE beacons
* Added new client-controls function including new Teach-UI command (use e.g. to control volume or call Mesh-Nodes and CLEXI form client)
* New wake-word settings, fixed wake-word for AO-mode, proper settings storing and auto-load of engine
* Store and load selected voice (per language)
* New 'view' URL parameter to e.g. launch Always-On mode ('aomode') directly on start
* New 'isTiny' URL parameter to be able to handle very small screens (e.g. 240x240) via sepiaFW-style-tiny.css file
* New Always-On animations (mouth). AO-mode can be activated via double-tap on SEPIA label (center top)
* UX tweaks (mic press stops alarm, bigger shortcuts button area etc.) and skin improvements
* Renamed 'Chatty reminders' to 'Well-being reminders' (and made them opt-in by default) ;-)
* New idle-time action queue (used e.g. in client-control to get voice feedback on error)
* Custom environmental variable during AO-mode: avatar_display (use for services)
* Fixed a bug in Chrome TTS and other minor bug- and UX-fixes
  
Updated Assist-server to v2.2.1:
* Added client-controls service and client-function parameter to handle e.g. volume control, toggle settings and AO-mode, trigger a Mesh-Node or CLEXI call from client and more
* Imroved RSS feed reader, updated ROME tools and fixed news-outlets
* Improved some NLU parameters (e.g. radio station and location)
  
Updated Mesh-Node to v0.9.9:
* Added PIN and localhost security options to plugins
  
Notable mentions:
* SEPIA STT-Server has been updated with new english Kaldi model
* Smaller fixes to the SEPIA control HUB
* A [browser plugin](https://chrome.google.com/webstore/detail/sepia-framework-tools/gbdjpbipoaacccffgemiflnhfldahopp) has been release to improve the SEPIA client running in Chromium kiosk mode

### v2.2.0 - 2019.01.31

New additions and changes:
* Added [SEPIA Mesh-Node server](https://github.com/SEPIA-Framework/sepia-mesh-nodes) to the SEPIA-Home bundle: A small, lightweight server that can be distributed in your network to run tasks securely triggered from anywhere using SEPIA.
* Completely rebuilt the SEPIA Admin-Tools (on top of the ByteMind Web-App template) and renamed them to SEPIA Control-HUB (internally) :-)
* Added a web-based code editor called Code-UI to the Control-HUB (following in the footsteps of the Teach-UI ^^) that can be used to code and upload custom Smart-Services to the SEPIA core server and plugins to a SEPIA Mesh-Node.
* The code editor can load services and plugins directly from the new [SEPIA Extensions repository](https://github.com/SEPIA-Framework/sepia-extensions). You can think of it as some kind of "skill store light", contributions welcome ;-)
* Introduced [the new SEPIA Java SDK](https://github.com/SEPIA-Framework/sepia-sdk-java) to build, test and upload Smart-Services (standalone, download separately).  

Updated Assist-server to v2.2.0:
* Many internal changes to support the new Java SDK, the rebuilt Control-HUB and the Code-UI
* Implemented the feature to add "real" custom answers (multi language + variation) right inside a service. Previously they had to be defined in the assistant database. This will make it easier to deliver high quality dialog with the SDK.
* Added a Mesh-Node connector to handle calls to Mesh-Node Plugins like a service with parameters (this enables the new 'plugin' command in the Teach-UI, see below)
* Tweaked settings endpoint to write changes submitted by Control-HUB permanently to the active config-file (previously they were lost after restart)
* Improvements in 'Number' and 'DateAndTime' parameters
* Improved 'Alarm' service to better handle "this event is in the past" cases
* Added a limited-size cache for custom commands (saves some database calls)
* Improved Java 9+ support
* Fixes and clean-ups all over the place
* Updated SEPIA core tools to v2.2.0 (this applies to all core servers)  

Updated client to v0.16.0:
* Added new 'plugin' command (mesh_node_plugin) to the Teach-UI to easily interface with SEPIA Mesh-Nodes (see above)
* Added speech-to-text output to AlwaysOn-mode
* Automatically close await-dialog state (yellow mic) after 15s
* Improved my-view automatic refresh (e.g. after wake-up from background)
* Fixed link-cards for dark skins and HTML link colors
* Added skin 'Nightlife'
* Translated tutorial to German (and added language support to Frames)
* Added ACTION "switch_language" to experiment with custom services in non-default languages
* Improved demo-mode
* Fixed a bug in the mic-reset function
* Fixed a bug in Teach-UI for unsupported commands

### v2.1.3 - 2018.12.16

Updated client to v0.15.2 with following changes:
* Added drag & drop module and applied it to shopping and to-do list for sorting (activate via long-press on item check-button)
* Added 3-states support for to-do lists (similar to Kanban-cards: open/in-progress/done)
* Updated to-do/shopping list design and list context-menu in general
* Updated tutorial with new list features and generally more info
* Added a help and support button to settings menu (pointing to SEPIA docs page)
* Improved alarms during AlwaysOn-mode
* Introduced smart-microphone toggle (enable in settings) that auto-activates mic on voice based questions (beta)
* Added new skins 'Study', 'Odyssey1', 'Odyssey2', 'Professional' (with less rounded corners ^^), reworked 'NeoSepiaDark' and changed old one to 'Malachite', updated 'Grid' and tweaked other styles
* Fixed some bugs in GPS event handling
* Improved handling of large lists to show them more often in 'big-results'-view and sorted time-events by date
* Split Alarms/Timers button in shortcuts into 2 buttons
* Introduced upper limit for maximal visible chat entries (to improve performance)
* Added mood indicator to AlwaysOn-mode avatar (mouth angle ^_^)
* Improved hotkeys/gamepad config menu
* Reworked AudioRecorder module to support different recorder types
* Introduced new WakeTriggers module and added new config options (e.g. (dis)allow remote hotkey)
* Improved file reader to handle array-buffers so that we can import WebAssembly code
* Added Porcupine JS wake-word tool as 'xtension' and beta-test view to experiment with 'Hey SEPIA' (access from settings)
* Added embedded module with (very) basic offline NLU and services (currently only used for demo-mode e.g. to load a demo list)
* Updated demo mode with offline custom buttons
* Fixed a bug that crashed app when a Bluetooth devices was (dis)connected  

Updated Assist-server to v2.1.4:
* Read more than 10 lists with one request (handle paging in service)
* Improved lists NLU ('show me my A and B lists'), radio NLU ('play radio with songs of BAND'), time/date and location parameters
* Updated news-outlets, Wired Germany will close down end of 2018 :-(  

Other changes:
* Improved installation scripts

### v2.1.2 - 2018.11.xx (internal version)

Updated client to v0.14.3 with some nice upgrades, e.g.:
* Define custom button for your own commands via the Teach-UI
* Add music stream commands via Teach-UI
* Always-On view with animated avatar and controls (beta)
* Power-events e.g. open AO-mode on power plugin
* Gamepad and hotkey support for remote microphone trigger and other controls (beta)
* Design update of quick-access menu (bottom left) and additional smaller changes (skins etc.)
* Fixed bug where radio won't turn off via voice
* Fixed a bug that prevented timer stop via voice
* Many smaller fixes  

Other changes:
* Teach-server update to v2.0.2 with custom buttons support for personal commands
* Assist-server update to v2.1.3 with reworked radio stations (external, curated file), time/date answers and fixes
* Admin-Tools support for server URL parameters
* Added server backup script (Unix) and updated Windows setup and run
* Fixed a UTF-8 encoding bug for Windows

### v2.1.0a - 2018.10.26

Updated assist-server to v2.1.0 with numerous improvements, e.g.:
* Added smart home NLU, parameters (device, room) and service BETA via openHAB integration (currently testing Hue lights)
* Updated news service and exported the hard-coded outlet data to external .json file for easier editing and fixing
* Updated Bundesliga soccer service with data of new season
* Updated and improved setup scripts (e.g. for admin password reset)
* Fixes in NLU and parameter extractions (e.g. for location parameter)
* Improved handling of internal error with proper client message  

Other changes:
* Upgraded dependencies, mainly: Java Spark (2.5.4 -> 2.8.0) and Jetty Server (9.3 -> 9.4)
* Updated SEPIA Reverse-Proxy to use external properties file and added some features
* Added new menues to Admin-Tools (e.g. smart home configuration and speech recognition)
* Many smaller bugfixes

### v2.0.1a - 2018.07.07

* Updated assist-server to v2.0.1 (smaller bugfixes)
* Added SEPIA Reverse-Proxy, a tiny JAVA proxy for the custom-bundle. This will save you the installation of a 3rt-party proxy and it works well with ngrok ;-)
* Updated SEPIA HTML client to v0.11.4 (better hostname handling)
* Updated core-tools to v2.0.1 and replaced 'connection-check.jar' with 'sepia-core-tools-*.jar connection-check'

### v2.0.0a - 2018.07.02

First public, open-source release of SEPIA-Framework 2.0 (v1 was proprietary software).
