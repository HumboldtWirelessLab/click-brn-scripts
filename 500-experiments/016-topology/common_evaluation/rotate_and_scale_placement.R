#!/usr/bin/Rscript

suppressPackageStartupMessages(library("optparse"))

get.angle <- function(x, y) {
    
    alpha = 0
    if(x > 0) {
        alpha = atan(y / x)
    }else if((x < 0) & (y >= 0)) {
        alpha = atan(y / x) + pi        
    }else if((x < 0) & (y < 0)) {
        alpha = atan(y / x) - pi
    }else if((x == 0) & (y > 0)) {
        alpha = pi / 2
    }else if((x == 0) & (y < 0)) {
        alpha = pi / -2
    }
    
    alpha
}

get.distance <- function(x, y) {
    sqrt(x^2 + y^2)
}

# @input net data.frame with col.names x,y
# @input angle in rad
rotate_and_scale.placement <- function(net, center.x, center.y, angle.offset = 0, scale = 1) {
    net$x = net$x - center.x
    net$y = net$y - center.y
    
    r = get.distance(net$x, net$y)
    r = r * scale
    
    angles = apply(subset(net, select = x:y), 1, function(p) get.angle(p[1], p[2]))
    angles = angles + angle.offset
    
    net$x = r * cos(angles) + center.x
    net$y = r * sin(angles) + center.y
    
    net
}


main <- function() {
    cmd.opts = list(
        make_option(c("--placement" ), dest = "placement.path", type = "character", default = "placementfile.plm", help = "Placement file path"),
        make_option(c("-x", "--center.x"), type = "integer", default = 0, help = "Center to scale and rotate"),
        make_option(c("-y", "--center.y"), type = "integer", default = 0, help = "Center to scale and rotate"),
        make_option(c("-a", "--angle"), type = "double", default = 0, help = "Angle to rotate"),
        make_option(c("-s", "--scale"), dest = "scale.factor", type = "double", default = 1, help = "Factor to scale"),
        make_option(c("-f", "--use.first.node.as.center"), type = "logical", action = "store_true", default = FALSE, help = "Use first node as center")
    )
    cmd.args <- parse_args(OptionParser(option_list = cmd.opts))
    
    net = read.csv(file = cmd.args$placement.path, sep = "", header = F)
    names(net) = c("name", "x", "y", "z")
    
    if(cmd.args$use.first.node.as.center) {
        center.x = net$x[1]
        center.y = net$y[1]
    } else {
        center.x = cmd.args$center.x
        center.y = cmd.args$center.y
    }
    
    net = rotate_and_scale.placement(net, center.x, center.y, cmd.args$angle, cmd.args$scale.factor)
    
    net
}


if(interactive() == F)
    main()

