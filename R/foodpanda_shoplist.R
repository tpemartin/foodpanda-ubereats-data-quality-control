library(googledrive)

# shoplist ----
fileUrl <- "https://drive.google.com/file/d/1o0PaCp3uCcKueumwr5kIsJeQjFRIrwRI"
# Download the file
drive_download(as_dribble(fileUrl), overwrite = T)

# Anchor points -----
library(readr)
shoplist <- read_csv("stacked_lines2.csv")
