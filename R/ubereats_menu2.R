menuList <- googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1TiIzwbPL5a94JY-lTKj4hUJVhbJ9daCfgCCyuZTgj24/edit?gid=259626420#gid=259626420",
    shee="files: 2024-9-8")


fileId <- menuList$ID[[1]]

# download the file as a tempfile and import it
menuFile <- googledrive::drive_download(as_id(fileId), path = tempfile(fileext = ".csv"))
menuFile$local_path
ubereats_menu <- readr::read_csv(menuFile$local_path) 

ubereats_menu

importMenu <- function(fileId){
    menuFile <- googledrive::drive_download(as_id(fileId), path = tempfile(fileext = ".csv"))
    ubereats_menu <- readr::read_csv(menuFile$local_path) 
    return(ubereats_menu)
}
