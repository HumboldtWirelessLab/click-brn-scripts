#!/usr/bin/Rscript

suppressPackageStartupMessages(library("optparse"))

generate.calculated.box.placement <- function(
    bridge.distance = 300, 
    left.first.distance = 170,
    left.second.distance = 60,
    left.third.distance = 0,
    left.node.count = 10,
    right.first.distance = 170,
    right.second.distance = 60,
    right.third.distance = 0,
    right.node.count = 10) {
    stopifnot(left.node.count > 0)
    x1 = 0
    y1 = 0
    left.node.count = left.node.count - 1
    
    stopifnot(right.node.count > 0)
    x2 = bridge.distance
    y2 = 0
    right.node.count = right.node.count - 1
    
    result = data.frame(x = c(x1, x2), y = c(y1, y2))
    
    #
    # Left side
    #
    r = left.second.distance
    n = 0
    while( n < left.node.count) {
        r.plus = runif(1, 0, left.third.distance)
        
        repeat{
            a = runif(1, 0, 2 * pi)
            
            x = (r + r.plus) * cos(a) + x1 - left.first.distance
            y = (r + r.plus) * sin(a) + y1
            
            if(x < x1 - left.first.distance) {
                result = rbind(result, data.frame(x, y))
                n = n + 1 
                break
            }
        }
    }
    
    #
    # Right side
    #
    r = right.second.distance
    n = 0
    while( n < right.node.count) {
        r.plus = runif(1, 0, right.third.distance)
        
        repeat{
            a = runif(1, 0, 2 * pi)
            
            x = (r + r.plus) * cos(a) + x2 + right.first.distance
            y = (r + r.plus) * sin(a) + y2
            
            if(x > x2 + right.first.distance) {
                result = rbind(result, data.frame(x, y))
                n = n + 1 
                break
            }
        }
    }
    
    for(i in 1:nrow(result)) {
        result$name[i] = sprintf("sk%d", i)
    }
    
    result$x = as.integer(result$x)
    result$y = as.integer(result$y)
    result$z = as.integer(0)
    result = subset(result, select = c(name, x, y, z))
    result
}


main <- function() {
    cmd.opts = list(
        make_option(c("--b" ), dest = "bridge.distance", type = "integer", default = 200, help = "Distance btw. both nets"),
        make_option(c("--ln"), dest = "left.node.number", type = "integer", default = 6, help = "Left number of nodes"),
        make_option(c("--l1"), dest = "left.first.distance", type = "integer", default = 170, help = "Left min distance btw bridge-node and other nodes at the box"),
        make_option(c("--l2"), dest = "left.second.distance", type = "integer", default = 60, help = "Left first + second distance is the minimal distance or the radius related to the bridge node of a box."),
        make_option(c("--l3"), dest = "left.third.distance", type = "integer", default = 0, help = "Left first + second + third distance is the maximal distance or the radius related to the bridge node of a box."),
        make_option(c("--rn"), dest = "right.node.number", type = "integer", default = 6, help = "Right number of nodes"),
        make_option(c("--r1"), dest = "right.first.distance", type = "integer", default = 170, help = "Right min distance btw bridge-node and other nodes at the box"),
        make_option(c("--r2"), dest = "right.second.distance", type = "integer", default = 60, help = "Right first + second distance is the minimal distance or the radius related to the bridge node of a box."),
        make_option(c("--r3"), dest = "right.third.distance", type = "integer", default = 0, help = "Right first + second + third distance is the maximal distance or the radius related to the bridge node of a box.")
    )
    cmd.args <- parse_args(OptionParser(option_list = cmd.opts))
    
    df = generate.calculated.box.placement(
        bridge.distance = cmd.args$bridge.distance, 
        left.first.distance = cmd.args$left.first.distance, 
        left.second.distance = cmd.args$left.second.distance, 
        left.third.distance = cmd.args$left.third.distance, 
        left.node.count = cmd.args$left.node.number,
        right.first.distance = cmd.args$right.first.distance, 
        right.second.distance = cmd.args$right.second.distance, 
        right.third.distance = cmd.args$right.third.distance, 
        right.node.count = cmd.args$right.node.number)
    write.table(df, file = stdout(), sep = " ", quote = F, row.names = F, col.names = F)
}


if(interactive() == F)
    main()