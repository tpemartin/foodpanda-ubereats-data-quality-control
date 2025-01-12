fileLink <- "https://drive.google.com/file/d/1Y9PpuSGq3yWj4wbjumfUtsTqkOpjZQ46/view?usp=drive_link"

# Get the file dribble
dribbl <- fileLink |>
    as_dribble()

# download the file
drive_download(dribbl, path = dribbl$name)

# read csv from dribb name
dribbl$name
foodpanda <- read_csv(dribbl$name)

glimpse(foodpanda)
