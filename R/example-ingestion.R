pacman::p_load(
  "tidyverse", 
  "readxl", 
  "fs"
)


# Basic mechanics 

## Read one excel sheet 

dat_wizard <- 
  
  read_excel(
    "data/cool-classes.xlsx", 
    sheet = "wizard"
  )

## Add the sheet name as a column

dat_wizard <- dat_wizard %>% 
  
  mutate(
    sheet = "wizard"
  )

## Get sheet names 

sheets_cool <- excel_sheets("data/cool-classes.xlsx")

## Simple map

sheets_cool %>% 
  
  map(
    # within map, ~ creates a lambda function. 
    # you can think of it as a shorthand for function(.x)
    ~ str_c("the result of a function using ", .x)
  )


# Get all the data from one sheet

## Recall our sheets_cool vector

## Use the powers of map

dat_cool <- sheets_cool %>% 
  
  # For each sheet
  map(
    # read in the data
    ~ read_excel("data/cool-classes.xlsx", sheet = .x) %>%
      # name the sheet in the data
      mutate(sheet = .x)
  )

## Note: 
#    This returns a list of dataframes.
#    I prefer to keep this stage
#    because it lets you solve data type conflicts 
#    that will break bind_rows()


## Concatenate vertically

dat_cool <- dat_cool %>%
  
  bind_rows()

dat_cool

## Functionalize it... if you dare

read_wb_for_migration <- function(wb_path) {
  
  sheets <- excel_sheets(wb_path)
  
  res <- sheets %>% 
    
    map(
      ~ read_excel(wb_path, sheet = .x) %>% 
        mutate(sheet = .x)
    ) %>% 
    
    bind_rows()
  
  res
}


dat_cool_ez <- read_wb_for_migration("data/cool-classes.xlsx")

# Multiball


## Get file names

files_of_interest <- dir_ls("data")

## Same shit here

dat_classes <- files_of_interest %>% 
  
  map(
    ~ read_wb_for_migration(.x) %>% 
      mutate(file = .x)
  ) %>% 
  
  bind_rows()


## If the file names share a common format, 
#  you can extract the info they rep with regex

dat_classes <- dat_classes %>% 
  
  mutate(
    coolness = file %>% str_extract("lame|cool")
  )

dat_classes

## You could even... functionalize this, etc. 

read_wb_for_migration <- function(wb_path) {
  
  sheets <- excel_sheets(wb_path)
  
  res <- sheets %>% 
    
    map(
      ~ read_excel(wb_path, sheet = .x) %>% 
        mutate(sheet = .x)
    ) %>% 
    
    bind_rows()
  
  res
}

read_folder_for_migration <- function(dir_path) {
  
  files <- dir_ls(dir_path)
  
  res <- files %>% 
    
    map(
      ~ read_wb_for_migration(.x) %>% 
        mutate(file = .x)
    ) %>% 
    
    bind_rows()
  
  res
}

## Usage

dat_classes_alt <- read_folder_for_migration("data")


dat_classes_alt
