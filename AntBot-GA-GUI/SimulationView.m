#import "SimulationView.h"

@implementation SimulationView

@synthesize simulation, robots, team, tags, pheromones, regions, clusters;

-(void) awakeFromNib {
    [self translateOriginToPoint:NSMakePoint(0,0)];
}

-(void) redraw {
    if(drawTimer == nil) {
        drawTimer = [NSTimer timerWithTimeInterval:.016f target:self selector:@selector(drawTimerDidFire:) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:drawTimer forMode:NSDefaultRunLoopMode];
    }
}

-(void) drawTimerDidFire:(NSTimer*)timer {
    [drawTimer invalidate];
    drawTimer = nil;
    [self setNeedsDisplay:YES];
}

-(void) drawRect:(NSRect)dirtyRect {
    float w = self.frame.size.width,
          h = self.frame.size.height;
    NSSize grid = simulation.gridSize;
    float cellWidth = (1./grid.width) * w,
          cellHeight = (1./grid.height) * h;

    //Clear background.
    [[NSColor blackColor] set];
    NSRectFill(dirtyRect);
    
    //Draw Nest as white circle with diameter of 3 centered at nest
    NSRect rect = NSMakeRect((simulation.nest.x * cellWidth) - cellWidth, (simulation.nest.y * cellHeight) - cellHeight, cellWidth * 3, cellHeight * 3);
    NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
    
    [[NSColor blackColor] set];
    [path fill];
    [[NSColor whiteColor] set];
    [path stroke];
    
    for(float i = 0; i < grid.width; i++) {
        [[NSColor grayColor] set];
        NSBezierPath* path = [NSBezierPath bezierPath];
        [path setLineWidth:.5];
        [path moveToPoint:NSMakePoint(roundf((i/grid.width)*self.frame.size.width),0)];
        [path lineToPoint:NSMakePoint(roundf((i/grid.width)*self.frame.size.width),h)];
        [path stroke];
    }
    for(float i = 0; i < grid.height; i++) {
        [[NSColor grayColor] set];
        NSBezierPath* path = [NSBezierPath bezierPath];
        [path setLineWidth:.5];
        [path moveToPoint:NSMakePoint(0,roundf((i/grid.height)*self.frame.size.height))];
        [path lineToPoint:NSMakePoint(w,roundf((i/grid.height)*self.frame.size.height))];
        [path stroke];
    }
    
    for(Robot* robot in robots) {
        NSRect rect = NSMakeRect((robot.position.x/grid.width)*w, (robot.position.y/grid.height)*h, cellWidth, cellHeight);
        NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
        
        if([[robot discoveredTags] count] > 0) {
            [[NSColor greenColor] set];
        }
        else if(robot.status == ROBOT_STATUS_DEPARTING) {
            [[NSColor redColor] set];
        }
        else if(robot.status == ROBOT_STATUS_SEARCHING) {
            [[NSColor purpleColor] set];
        }
        else if(robot.status == ROBOT_STATUS_RETURNING) {
            [[NSColor orangeColor] set];
        }
        [path fill];
        [[NSColor whiteColor] set];
        [path stroke];
        
        if ([robot recruitmentTarget].x > 0) {
            float range = [simulation wirelessRange];
            rect = NSMakeRect(((robot.position.x - range/2)/grid.width)*w, ((robot.position.y - range/2)/grid.height)*h, range*cellWidth, range*cellHeight);
            path = [NSBezierPath bezierPathWithOvalInRect:rect];
            [[NSColor colorWithCalibratedRed:0. green:.5 blue:1. alpha:1.] set];
            [path stroke];
        }
    }

    for(Tag* tag in tags) {
        if (![tag isKindOfClass:[NSNull class]]) {
            NSRect rect = NSMakeRect(((float)[tag position].x/grid.width)*w + (cellWidth*.25),
                                     ((float)[tag position].y/grid.height)*h + (cellWidth*.25),cellWidth*.5, cellHeight*.5);
            NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
            
            if(tag.pickedUp){[[NSColor blackColor] set];}
            else if([tag discovered]){[[NSColor magentaColor] set];}
            else{[[NSColor whiteColor] set];}
            [path setLineWidth:2];
            [path fill];
            [path setLineWidth:1];
            [[NSColor darkGrayColor] set];
            [path stroke];
        }
    }
    
    for(Pheromone* pheromone in pheromones) {
        [[NSColor colorWithCalibratedRed:0. green:.6 blue:0. alpha:1.] set];
        NSBezierPath* path = [NSBezierPath bezierPath];
        [path setLineWidth:3*pheromone.n];
        [path moveToPoint:NSMakePoint(simulation.nest.x * cellWidth, simulation.nest.y * cellHeight)];
        [path lineToPoint:NSMakePoint(((float)[pheromone position].x/grid.width)*w,((float)[pheromone position].y/grid.height)*h)];
        [path stroke];
//        float range = 10;
//        NSRect rect = NSMakeRect(((pheromone.x - range/2)/grid.width)*w, ((pheromone.y - range/2)/grid.height)*h, range*cellWidth, range*cellHeight);
//        path = [NSBezierPath bezierPathWithOvalInRect:rect];
//        [[NSColor colorWithCalibratedRed:0. green:.5 blue:1. alpha:1.] set];
//        [path stroke];
   }
    
    for(QuadTree* region in regions) {
        [[NSColor redColor] set];
        NSRect rect = NSMakeRect([region origin].x * cellWidth, [region origin].y * cellWidth, [region width] * cellWidth, [region height] * cellWidth);
        NSBezierPath* path = [NSBezierPath bezierPathWithRect:rect];
        [path setLineWidth:3];
        [path stroke];
    }
    
    for(Cluster* cluster in clusters) {
        [[NSColor blueColor] set];
        NSRect rect = NSMakeRect([cluster center].x * cellWidth, [cluster center].y * cellWidth, [cluster width] * cellWidth, [cluster height] * cellWidth);
        NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
        [path setLineWidth:2];
        [path stroke];
    }
}

-(void) updateDisplayWindowWithRobots:(NSMutableArray*)_robots team:(Team*)_team tags:(Array2D*)_tags pheromones:(NSMutableArray*)_pheromones regions:(NSMutableArray*)_regions clusters:(NSMutableArray *)_clusters {
    robots = _robots;
    team = _team;
    tags = _tags;
    pheromones = _pheromones;
    regions = _regions;
    clusters = _clusters;
    [self redraw];
}

@end
