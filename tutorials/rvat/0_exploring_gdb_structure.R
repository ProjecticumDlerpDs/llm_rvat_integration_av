# In this script the structure of the gdb is explored to further understanding
# of the gdb to better interpret and use the database
# For this first run tutorials/rvat/1a_setup_gdb.R

# slotNames() returns names of slot of gdb (which is an S4 object)
slotNames(gdb)
# [1] "ptr"                 "dbname"              "loadable.extensions"
# [4] "flags"               "vfs"                 "ref"                
# [7] "bigint"              "extended_types"

# What do these names mean? Instead of $ which is used to see inside variables
# of tibble/dataframes etc. S4 classes use @
# Use this to check class of each slot
class(gdb@ptr)
# [1] "externalptr" ## external pointers to avoid R making large objects 
                    ## and instead using external memory
class(gdb@dbname)
# [1] "character"
class(gdb@loadable.extensions)
# [1] "logical"
class(gdb@flags)
# [1] "integer"
class(gdb@vfs)
# [1] "character"
class(gdb@ref)
# [1] "environment"
class(gdb@bigint)
# [1] "character"
class(gdb@extended_types)
# [1] "logical"
